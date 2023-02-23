import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain_layer.dart';
import '../../../app/routes/routes.dart';
import '../../../common/widget/confirm_dialog.dart';
import '../../../l10n/translations.dart';
import '../widget/avatar.dart';

/// Contacts page.
///
/// Display the list of contacts from [ContactsSyncUseCase] and a floating button
/// to add pseudo random contacts (use case personalities and fake contacts).
///
/// This consumer widget watches the list of contacts and rebuilds its
/// internal stateless widget when the list changes.
class ContactsSyncPage extends ConsumerWidget {
  /// Const constructor.
  const ContactsSyncPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = Translations.of(context);
    final usecase = ref.read(contactsSyncUseCaseProvider);
    final contacts = ref.watch(contactsSyncProvider);
    return _ContactsPage(tr: tr, contacts: contacts, usecase: usecase);
  }
}

/// Internal stateless widget.
///
/// Display the list of contacts from [ContactsSyncUseCase] and a floating button
/// to add pseudo random contacts (use case personalities and fake contacts).
class _ContactsPage extends StatelessWidget {
  const _ContactsPage({required this.tr, required this.contacts, required this.usecase});

  final Translations tr;
  final List<Contact> contacts;
  final ContactsSyncUseCase usecase;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr.contacts_title)),
      body: contacts.isEmpty ? _buildNoContactsMessage(context) : _buildContactsList(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _newContact(),
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
    context.goNamed(Routes.viewContactSync, params: {'id': contact.id!.toString()});
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

  /// Handler to create a new contact using business rules.
  ///
  /// This may create a Personality or a Fake contact (random rules).
  Contact _newContact() {
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
          icon: Icon(contact.isPersonality ? Icons.delete : Icons.delete_forever, color: colors.error),
          onPressed: onDelete,
        ),
        onTap: onTap,
      ),
    );
  }
}
