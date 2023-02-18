import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../entity/contact.dart';
import '../exception/entity_not_found_exception.dart';
import '../exception/validation_exception.dart';
import '../layer/domain_layer.dart';
import '../repository/contacts_repository.dart';
import 'use_case_notifier.dart';

final uuidProvider = Provider((ref) => const Uuid());

final personalitiesProvider = Provider((ref) => [
      const Contact(id: 0, name: 'Trygve Reenskaug', uuid: 'c6d85b7c-8f77-4447-9f80-2ae4ab061f20'),
      const Contact(id: 1, name: 'Robert Martin', uuid: '6381eb68-e200-490c-a227-cb64648f2a23'),
      const Contact(id: 2, name: 'Martin Fowler', uuid: 'b7525456-ce67-4df0-8760-9c4f5d76cac7'),
      const Contact(id: 3, name: 'Gilad Bracha', uuid: '8ad5b6ca-8b37-489a-a95f-11a1f8cdd110'),
    ]);

final contactsProvider = NotifierProvider<ContactsUseCase, List<Contact>>(ContactsUseCase.new);

final contactProvider = Provider.family.autoDispose<Contact, int>(
  (ref, id) => ref.watch(
    contactsProvider.select(
      (value) => value.firstWhere(
        (element) => element.id == id,
        orElse: () => throw const EntityNotFoundException(),
      ),
    ),
  ),
);

final contactsUseCaseProvider = Provider((ref) => ref.read(contactsProvider.notifier));

/// Use case with Contacts business rules.
///
/// It provides an API to access and update [Contact] entities.
class ContactsUseCase extends UseCaseNotifier<List<Contact>> {
  /// Provisioned [ContactsRepository] implementation.
  late final ContactsRepository repository;

  /// [Uuid] generator.
  late final Uuid uuid;

  @override
  List<Contact> build() {
    final domainLayer = ref.read(domainLayerProvider);
    repository = ref.read(domainLayer.contactsRepositoryProvider);
    uuid = ref.read(uuidProvider);
    return _loadContacts();
  }

  /// Get a Contact from repository by uuid.
  ///
  /// Expects repository to throw an [EntityNotFoundException] if no contact has this uuid.
  Contact getByUuid(String uuid, {required Contact Function() orElse}) {
    try {
      return repository.getByUuid(uuid);
    } on Exception {
      return orElse();
    }
  }

  /// Save a [Contact] in the repository and return the saved entity.
  ///
  /// Call [validate] before saving.
  /// Adjust the contents (trim contacts name) before saving.
  ///
  /// If contact's id is null the repository will be responsible to generate
  /// a unique id, persist and return this new entity with its generated id.
  ///
  /// If contact's id is not null the repository should update the entity with the given id.
  Contact save(Contact value) {
    validate(value);
    final adjusted = _adjust(value);
    final saved = repository.save(adjusted);
    ref.invalidate(contactsProvider);
    return saved;
  }

  /// Removes an entity by id from the repository.
  ///
  /// Expects that the repository throws an [EntityNotFoundException] if id is not found.
  void remove(int id) {
    repository.remove(id);
    ref.invalidate(contactsProvider);
  }

  /// Validate contact's content.
  ///
  /// Throws a validation exception if contact's name is empty.
  void validate(Contact contact) {
    if (contact.name.trim().isEmpty) {
      throw const ValidationException('Contact\'s name should not be empty');
    }
  }

  /// Adjust contact's contents.
  ///
  /// Generates contact's uuid when it is empty.
  /// Trim contacts name if necessary.
  Contact _adjust(Contact contact) {
    var adjusted = contact.uuid.isEmpty ? contact.copyWith(uuid: uuid.v4()) : contact;

    final adjustedName = contact.name.trim();
    if (contact.name != adjustedName) {
      adjusted = adjusted.copyWith(name: adjustedName);
    }

    return adjusted;
  }

  List<Contact> get personalities => ref.read(personalitiesProvider);

  Contact? missingPersonality(List<Contact> contacts) {
    final candidates = personalities;
    final found = candidates.indexWhere((element) => !contacts.contains(element));
    return found == -1 ? null : candidates[found];
  }

  /// Private - Load all contacts from repository.
  ///
  /// It is expected it returns the list sorted by name.
  /// This action will also initialize the storage repository on its very first invocation.
  ///
  /// Used by [ContactsState.build] method.
  List<Contact> _loadContacts() {
    return repository.getAll();
  }
}
