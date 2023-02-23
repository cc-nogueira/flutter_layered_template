part of '../contacts_sync_use_case.dart';

/// Persitent [ContactsSyncNotifier] provider (keepAlive: true)
final contactsSyncProvider = NotifierProvider<ContactsSyncNotifier, List<Contact>>(ContactsSyncNotifier.new);

/// All [Contact]s notifier.
///
/// This is the implementatin for the synchronous API example.
///
/// It is initialized with contacts loaded through the use case.
/// The use case will invalidate this notifier when there are changes in storage.
/// There are no public methods to change the state it just fetches all [Contact]s when invalidated and observed.
///
/// The singleton instance is kept by the persistent (keepAlive) provider.
class ContactsSyncNotifier extends Notifier<List<Contact>> {
  @override
  List<Contact> build() {
    return ref.read(contactsSyncUseCaseProvider)._loadContacts();
  }
}

/// A [Contact] provider by id.
///
/// This is an autodispose family provider.
///
/// Get one [Contact] from the the all contacts provider (by id).
/// It only triggers observers when the observed [Contact] changes.
/// It will not trigger if any other [Contact] changes, is delete or added.
///
/// Throws [EntityNotFoundException] if the id is not present in all known contacts.
final contactSyncProvider = Provider.family.autoDispose<Contact, int>(
  (ref, id) => ref.watch(
    contactsSyncProvider.select(
      (value) => value.firstWhere(
        (element) => element.id == id,
        orElse: () => throw const EntityNotFoundException(),
      ),
    ),
  ),
);
