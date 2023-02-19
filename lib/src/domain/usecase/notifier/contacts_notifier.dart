part of '../contacts_use_case.dart';

@Riverpod(keepAlive: true)
class ContactsNotifier extends _$ContactsNotifier {
  @override
  List<Contact> build() {
    return ref.read(contactsUseCaseProvider)._loadContacts();
  }
}

final contactProvider = Provider.family.autoDispose<Contact, int>(
  (ref, id) => ref.watch(
    contactsNotifierProvider.select(
      (value) => value.firstWhere(
        (element) => element.id == id,
        orElse: () => throw const EntityNotFoundException(),
      ),
    ),
  ),
);
