import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain_layer.dart';
import '../../app/routes/routes.dart';
import '../../common/page/loading_page.dart';
import '../../common/page/message_page.dart';
import '../../l10n/translations.dart';
import 'widget/avatar.dart';
import 'widget/processing_layer.dart';

/// Contacts page.
///
/// Display the list of contacts from [ContactsUseCase] and a floating button
/// to add pseudo random contacts (use case personalities and fake contacts).
///
/// This consumer widget watches the list of contacts and rebuilds its
/// internal stateless widget when the list changes.
class ContactsPage extends ConsumerWidget {
  /// Const constructor.
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = Translations.of(context);
    final usecase = ref.read(contactsUseCaseProvider);
    final guarding = ref.watch(contactsGuardNotifierProvider);

    // AsyncValue resolution:
    return ref.watch(contactsNotifierProvider).when(
          loading: () => LoadingPage(tr.contacts_title),
          data: (data) => _ContactsPage(
            tr,
            contacts: data,
            usecase: usecase,
            isWaitingAction: guarding,
          ),
          error: ErrorMessagePage.errorBuilder,
        );
  }
}

/// Internal stateless widget.
///
/// Display the list of contacts from [ContactsUseCase] and a floating button
/// to add pseudo random contacts (use case personalities and fake contacts).
class _ContactsPage extends StatelessWidget {
  /// Const constructor.
  const _ContactsPage(this.tr, {required this.contacts, required this.usecase, required this.isWaitingAction});

  final Translations tr;
  final List<Contact> contacts;
  final ContactsUseCase usecase;
  final bool isWaitingAction;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(tr.contacts_title)),
      body: _asyncOperationLayer(
        context,
        colors,
        child: contacts.isEmpty ? _buildNoContactsMessage(context) : _buildContactsList(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: isWaitingAction ? null : () => _newContact(),
        backgroundColor: isWaitingAction ? colors.secondaryContainer : null,
        foregroundColor: isWaitingAction ? colors.outline : null,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _asyncOperationLayer(BuildContext context, ColorScheme colors, {required Widget child}) {
    if (isWaitingAction) {
      return Stack(children: [
        child,
        const ProcessingLayer(),
      ]);
    }
    return child;
  }

  /// When there are no contacts.
  Widget _buildNoContactsMessage(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headlineMedium;
    return Center(child: Text(tr.no_contacts_message, style: textStyle));
  }

  /// List of [_ContactCard] items.
  Widget _buildContactsList(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return _ContactCard(
            tr,
            colors,
            contact: contact,
            onDelete: () => _removeContact(contact),
            onTap: () => _viewContact(context, contact),
          );
        },
      ),
    );
  }

  /// Handler to navigate to a contact page passing the contact id.
  void _viewContact(BuildContext context, Contact contact) {
    context.goNamed(Routes.viewContact, params: {'id': contact.id!.toString()});
  }

  /// Handler to remove a contact invoking [ContactsUseCase.remove].
  Future<void> _removeContact(Contact contact) {
    return usecase.remove(contact.id!);
  }

  /// Handler to save a new contact (create for you!).
  Future<Contact> _newContact() {
    return usecase.createContact();
  }
}

/// List tile for a contact.
///
/// Generates a leading initials avatar.
/// Display the contact name.
/// Includes a delete button to remove the contact.
class _ContactCard extends StatelessWidget {
  const _ContactCard(this.tr, this.colors, {required this.contact, required this.onDelete, required this.onTap});

  final Translations tr;
  final ColorScheme colors;
  final Contact contact;
  final Function() onDelete;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: contact.isPersonality ? colors.background : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
        side: BorderSide(color: contact.isPersonality ? colors.primary : colors.outline),
      ),
      child: ListTile(
        leading: Avatar(contact),
        title: Text(contact.name),
        subtitle: contact.isPersonality ? Text(tr.personality_title) : null,
        trailing: IconButton(
          icon: Icon(contact.isPersonality ? Icons.delete : Icons.delete_forever, color: const Color(0xFF992200)),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}
