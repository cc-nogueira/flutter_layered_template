import 'package:riverpod/riverpod.dart';

import '../entity/contact.dart';
import '../entity/message.dart';
import '../exception/entity_not_found_exception.dart';
import '../layer/domain_layer.dart';

/// Domain Layer provider
final domainLayerProvider = Provider((_) => DomainLayer());

/// Function provider for dependency configuration (implementation injection)
final domainConfigurationProvider = Provider<DomainConfiguration>(
    (ref) => ref.watch(domainLayerProvider.select((layer) => layer.configure)));

/// Usecase provider
final contactsUsecaseProvider = Provider(((ref) =>
    ref.watch(domainLayerProvider.select((layer) => layer.contactsUsecase))));

/// Private provider used bellow.
final _contactsRepositoryNotifierProvider =
    StateNotifierProvider<StateNotifier<List<Contact>>, List<Contact>>((ref) =>
        ref.watch(domainLayerProvider
            .select((layer) => layer.contactsRepositoryNotifier)));

/// This providers relies on using a StateNotifier API for the
/// contacts repository. A stream API would have a StreamProvider instead.
final allContactsProvider = Provider((ref) {
  ref.watch(_contactsRepositoryNotifierProvider);
  return ref.read(contactsUsecaseProvider).getAll();
});

/// This provider does not use a Stream API for single entity updates, it
/// composes with allContactsProvider to watch for changes in a sigle entity.
final contactProvider = Provider.autoDispose.family<Contact, int>((ref, id) {
  final contacts = ref.watch(allContactsProvider);
  final contact = contacts.firstWhere(
    (element) => element.id == id,
    orElse: () => throw const EntityNotFoundException(),
  );
  return contact;
});

/// MessageProvider for a contact
final messageProvider = FutureProvider.autoDispose.family<Message?, Contact>(
  (ref, contact) => ref.watch(contactsUsecaseProvider
      .select((usecase) => usecase.getMessageFor(contact))),
);
