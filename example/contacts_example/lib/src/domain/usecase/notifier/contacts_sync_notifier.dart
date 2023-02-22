part of '../contacts_sync_use_case.dart';

@Riverpod(keepAlive: true)
class ContactsSyncNotifier extends _$ContactsSyncNotifier {
  @override
  List<Contact> build() {
    return ref.read(contactsSyncUseCaseProvider)._loadContacts();
  }
}

final contactSyncProvider = Provider.family.autoDispose<Contact, int>(
  (ref, id) => ref.watch(
    contactsSyncNotifierProvider.select(
      (value) => value.firstWhere(
        (element) => element.id == id,
        orElse: () => throw const EntityNotFoundException(),
      ),
    ),
  ),
);
