import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain_layer.dart';
import '../../../app/route/routes.dart';
import '../../../common/page/loading_page.dart';
import '../../../common/page/message_page.dart';
import '../../../common/widget/async_guard_layer.dart';
import '../../../common/widget/confirm_dialog.dart';
import '../../../l10n/translations.dart';
import '../widget/avatar.dart';

/// Contacts page.
///
/// Display the list of contacts from [ContactsUseCase] and a floating button
/// to add pseudo random contacts (use case personalities and fake contacts).
///
/// This consumer widget watches the list of contacts and rebuilds its
/// internal stateless widget when the list changes.
class ContactsAsyncPage extends ConsumerWidget {
  /// Const constructor.
  const ContactsAsyncPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = Translations.of(context);
    final usecase = ref.read(contactsAsyncUseCaseProvider);

    // AsyncValue resolution:
    return ref.watch(contactsAsyncProvider).when(
          loading: () => LoadingPage(tr.contacts_title),
          data: (data) => _ContactsPage(
            tr,
            contacts: data,
            usecase: usecase,
          ),
          error: ErrorMessagePage.errorBuilder,
        );
  }
}

/// Internal stateless widget.
///
/// Display the list of contacts from [ContactsUseCase] and a floating button
/// to add pseudo random contacts (use case personalities and fake contacts).
class _ContactsPage extends ConsumerWidget {
  /// Const constructor.
  const _ContactsPage(this.tr, {required this.contacts, required this.usecase});

  final Translations tr;
  final List<Contact> contacts;
  final ContactsAsyncUseCase usecase;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final isWaitingAction = ref.watch(contactsAsyncGuardProvider);
    return Scaffold(
      appBar: AppBar(title: Text(tr.contacts_title)),
      body: AsyncGuardLayer(
        asyncGuardProvider: contactsAsyncGuardProvider,
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
            onDelete: () => _removeContact(context, contact),
            onTap: () => _viewContact(context, contact),
          );
        },
      ),
    );
  }

  /// Handler to navigate to a contact page passing the contact id.
  void _viewContact(BuildContext context, Contact contact) {
    context.goNamed(Routes.viewContactAsync, params: {'id': contact.id!.toString()});
  }

  /// Handler to remove a contact invoking [ContactsSyncUseCase.remove].
  Future<void> _removeContact(BuildContext context, Contact contact) async {
    final ok = (contact.isPersonality)
        ? await showConfirmDialog(context: context, message: tr.confirm_delete_personality_message)
        : true;
    if (ok == true) {
      usecase.remove(contact.id!);
    }
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
