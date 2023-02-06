part of '../contacts_usecase.dart';

@riverpod
class ContactState extends _$ContactState {
  late Stream<Contact> contactWatch;

  @override
  Contact build(int id) {
    final usecase = ref.read(contactsUsecaseProvider);
    contactWatch = usecase._watch(id);
    contactWatch.listen(__refresh);

    return usecase.get(id);
  }

  void __refresh(Contact? updated) {
    if (updated != null) {
      state = updated;
    }
  }
}
