import 'package:faker/faker.dart';
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
  Widget _buildContactsList(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return _ContactCard(
              contact: contact,
              onDelete: () => _removeContact(contact),
              onTap: () => _viewContact(context, contact),
            );
          },
        ),
      );

  /// Handler to remove a contact invoking [ContactsUseCase.remove].
  void _removeContact(Contact contact) {
    usecase.remove(contact.id!);
  }

  /// Handler to navigate to a contact page passing the contact id.
  void _viewContact(BuildContext context, Contact contact) {
    context.goNamed(Routes.viewContact, params: {'id': contact.id!.toString()});
  }

  /// Handler to save a new contact (create for you!).
  Future<Contact> _newContact() async {
    return usecase.save(await _createContact());
  }

  /// Creates a contact for example purposes.
  ///
  /// The contact will be a missing personality or a new fake named contact.
  Future<Contact> _createContact() async {
    return await usecase.missingPersonality() ??
        Contact(
          name: faker.person.name(),
          about: faker.lorem.sentences(4).join(),
        );
  }
}

/// List tile for a contact.
///
/// Generates a leading initials avatar.
/// Display the contact name.
/// Includes a delete button to remove the contact.
class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.contact, required this.onDelete, required this.onTap});

  final Contact contact;
  final Function() onDelete;
  final Function() onTap;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          leading: Avatar(contact),
          title: Text(contact.name),
          trailing: IconButton(
            icon: const Icon(Icons.delete, color: Color(0xFF770000)),
            onPressed: onDelete,
          ),
          onTap: onTap,
        ),
      );
}
