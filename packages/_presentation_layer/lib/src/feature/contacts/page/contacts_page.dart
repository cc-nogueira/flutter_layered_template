import 'package:_core_layer/string_utils.dart';
import 'package:_domain_layer/domain_layer.dart';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../routes/routes.dart';

/// Contacts page.
///
/// Display the list of contacts from [ContactsUsecase] and a floating button
/// to add pseudo random contacts (4 fixed contacts and fake contacts from there
/// on)
class ContactsPage extends ConsumerWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usecase = ref.watch(contactsUsecaseProvider);
    final contacts = ref.watch(allContactsProvider);
    return _ContactsPage(contacts: contacts, usecase: usecase);
  }
}

class _ContactsPage extends StatelessWidget {
  const _ContactsPage({Key? key, required this.contacts, required this.usecase})
      : super(key: key);

  final List<Contact> contacts;
  final ContactsUsecase usecase;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: contacts.isEmpty
          ? _buildNoContactsMessage(context)
          : _buildContactsList(context),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _newContact(),
      ),
    );
  }

  Widget _buildNoContactsMessage(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headline4;
    return Center(child: Text('No contacts', style: textStyle));
  }

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

  void _removeContact(Contact contact) => usecase.remove(contact.id);

  void _viewContact(BuildContext context, Contact contact) =>
      Navigator.pushNamed(context, Routes.viewContact, arguments: contact.id);

  Contact _newContact() => usecase.save(_createContact());

  Contact _createContact() {
    if (!contacts.any((element) => element.name == 'Trygve Reenskaug')) {
      return const Contact(name: 'Trygve Reenskaug');
    }
    if (!contacts.any((element) => element.name == 'Gilad Bracha')) {
      return const Contact(name: 'Gilad Bracha');
    }
    if (!contacts.any((element) => element.name == 'Robert Martin')) {
      return const Contact(name: 'Robert Martin');
    }
    if (!contacts.any((element) => element.name == 'Martin Fowler')) {
      return const Contact(name: 'Martin Fowler');
    }
    return Contact(name: Faker().person.name());
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({
    Key? key,
    required this.contact,
    required this.onDelete,
    required this.onTap,
  }) : super(key: key);
  final Contact contact;
  final Function() onDelete;
  final Function() onTap;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          leading: CircleAvatar(child: Text(contact.name.cut(max: 2))),
          title: Text(contact.name),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
          ),
          onTap: onTap,
        ),
      );
}
