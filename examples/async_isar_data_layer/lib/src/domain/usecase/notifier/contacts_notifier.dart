part of '../contacts_use_case.dart';

@Riverpod(keepAlive: true)
class ContactsNotifier extends _$ContactsNotifier {
  @override
  Future<List<Contact>> build() {
    return ref.read(contactsUseCaseProvider)._loadContacts();
  }
}

final contactProvider = FutureProvider.family.autoDispose<Contact, int>((ref, id) async {
  return ref.watch(contactsNotifierProvider.selectAsync((value) => value.firstWhere(
        (element) => element.id == id,
        orElse: () => throw const EntityNotFoundException(),
      )));
});
