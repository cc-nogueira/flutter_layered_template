import '../entity/contact.dart';

/// Contacts Repository interface.
abstract class ContactsRepository {
  /// Get a [Contact] from storage by id.
  ///
  /// Throws an [EntityNotFoundException] if no contact is found with id
  Contact get(int id);

  /// Get all [Contact]s from storage sorted by name.
  List<Contact> getAll();

  /// Get a [Contact] from storage by uuid.
  ///
  /// Throws an [EntityNotFoundException] if no contact has this uuid.
  Contact getByUuid(String uuid);

  /// Watch changes to a single [Contact].
  Stream<Contact> watch(int id);

  /// Watch storage changes.
  Stream<void> watchAll();

  /// Save a [Contact] in the repository and return the saved entity.
  ///
  /// If the entity id is 0 it should generate the next id, add the new entity to storage and return it.
  /// If the entity id is not 0 update the entry with that id.
  ///
  /// Returns the saved contact.
  Contact save(Contact value);

  /// Save a list of [Contact]s in storage and return the corresponding saved list.
  ///
  /// For each entity:
  ///   - If the entity id is 0 it should generate the next id, add the new
  ///     entity to storage and return it.
  ///
  ///   - If the entity id is not 0 update an existint entry with that id.
  ///
  /// Returns a list with all saved contacts.
  List<Contact> saveAll(List<Contact> list);

  /// Removes a [Contact] by id from the repository.
  ///
  /// Throws [EntityNotFoundException] if the entity to remove is not found in storage.
  void remove(int id);
}
