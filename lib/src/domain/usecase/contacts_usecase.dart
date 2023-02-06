import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../entity/contact.dart';
import '../exception/entity_not_found_exception.dart';
import '../exception/validation_exception.dart';
import '../layer/domain_layer.dart';
import '../repository/contacts_repository.dart';

part 'state/contact_state.dart';
part 'state/contacts_state.dart';
part 'contacts_usecase.g.dart';

@riverpod
ContactsUsecase contactsUsecase(ContactsUsecaseRef ref) => ContactsUsecase(
      repository: domainLayer.dataProvision.contactsRepositoryBuilder(),
    );

/// Usecase with Contacts business rules.
///
/// It provides an API to access and update [Contact] entities.
class ContactsUsecase {
  /// Constructor.
  ContactsUsecase({required this.repository});

  final ContactsRepository repository;
  final _uuid = const Uuid();

  /// Returns a single contact from storage by id.
  ///
  /// Expects that the repository throws an [EntityNotFoundException] when id is not found.
  Contact get(int id) {
    return repository.get(id);
  }

  /// Returns all contacts from storage.
  ///
  /// Expects the repository to return the list sorted by name.
  List<Contact> getAll() {
    return repository.getAll();
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
    return repository.save(adjusted);
  }

  /// Removes an entity by id from the repository.
  ///
  /// Expects that the repository throws an [EntityNotFoundException] if id is not found.
  void remove(int id) {
    repository.remove(id);
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
    var adjusted = contact.uuid.isEmpty ? contact.copyWith(uuid: _uuid.v4()) : contact;

    final adjustedName = contact.name.trim();
    if (contact.name != adjustedName) {
      adjusted = adjusted.copyWith(name: adjustedName);
    }

    return adjusted;
  }

  Stream<Contact> _watch(int id) {
    return repository.watch(id);
  }

  /// Internal for the [ContactsState].
  ///
  /// Return a repository watch on all contacts.
  Stream<void> _watchAll() {
    return repository.watchAll();
  }
}
