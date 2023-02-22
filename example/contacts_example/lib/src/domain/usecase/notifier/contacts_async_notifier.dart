part of '../contacts_async_use_case.dart';

@Riverpod(keepAlive: true)
class ContactsAsyncNotifier extends _$ContactsAsyncNotifier {
  @override
  Future<List<Contact>> build() {
    return ref.read(contactsAsyncUseCaseProvider)._loadContacts();
  }
}

final contactAsyncProvider = FutureProvider.family.autoDispose<Contact, int>((ref, id) async {
  return ref.watch(contactsAsyncNotifierProvider.selectAsync((value) => value.firstWhere(
        (element) => element.id == id,
        orElse: () => throw const EntityNotFoundException(),
      )));
});
