part of '../contacts_use_case.dart';

@Riverpod(keepAlive: true)
class ContactsState extends _$ContactsState {
  @override
  List<Contact> build() {
    return ref.read(contactsUseCaseProvider)._loadContacts();
  }

  /// State setter is private. Use [ContactsUseCase] API.
  @override
  @protected
  set state(List<Contact> value) {
    super.state = value;
  }

  /// Update the list of contacts in this state notifier.
  void update(List<Contact> list) {
    state = list;
  }
}

@riverpod
Contact contactState(ContactStateRef ref, int id) {
  return ref.watch(contactsStateProvider.select(
    (value) => value.firstWhere(
      (element) => element.id == id,
      orElse: () => throw const EntityNotFoundException(),
    ),
  ));
}
