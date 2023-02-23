part of '../contacts_async_use_case.dart';

/// Persitent [WhatsHappeingNotifier] provider (keepAlive: true)
final contactsAsyncProvider = AsyncNotifierProvider<ContactsAsyncNotifier, List<Contact>>(ContactsAsyncNotifier.new);

/// All [Contact]s notifier and provider.
///
/// This is the implementatin for the async API example.
///
/// It is initialized with contacts loaded through the use case.
/// The use case will invalidate this notifier when there are changes in storage.
/// There are no public methods to change the state it just fetches all [Contact]s when invalidated and observed.
///
/// The singleton instance is kept by the generated persistent (keepAlive) provider.
class ContactsAsyncNotifier extends AsyncNotifier<List<Contact>> {
  @override
  Future<List<Contact>> build() {
    return ref.read(contactsAsyncUseCaseProvider)._loadContacts();
  }
}

/// A [Contact] provider by id.
///
/// This is an autodispose family future provider.
///
/// Get one [Contact] from the the all contacts provider (by id).
/// It only triggers observers when the observed [Contact] changes.
/// It will not trigger if any other [Contact] changes, is delete or added.
///
/// Throws [EntityNotFoundException] if the id is not present in all known contacts.
final contactAsyncProvider = FutureProvider.family.autoDispose<Contact, int>((ref, id) async {
  return ref.watch(contactsAsyncProvider.selectAsync((value) => value.firstWhere(
        (element) => element.id == id,
        orElse: () => throw const EntityNotFoundException(),
      )));
});
