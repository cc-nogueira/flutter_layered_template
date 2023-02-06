part of '../contacts_usecase.dart';

@riverpod
class ContactsState extends _$ContactsState {
  late Stream<void> storageWatch;

  @override
  List<Contact> build() {
    final usecase = ref.read(contactsUsecaseProvider);
    storageWatch = usecase._watchAll();
    storageWatch.listen(__refresh);

    return usecase.getAll();
  }

  void __refresh(void event) {
    state = ref.read(contactsUsecaseProvider).getAll();
  }
}
