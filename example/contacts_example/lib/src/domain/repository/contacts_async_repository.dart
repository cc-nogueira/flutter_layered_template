import '../entity/contact.dart';

/// Contacts async repository interface.
abstract class ContactsAsyncRepository {
  /// Get all [Contact]s from storage sorted by name.
  Future<List<Contact>> getAll();

  /// Get a [Contact] from storage by uuid.
  ///
  /// Throws an [EntityNotFoundException] if no contact has this uuid.
  Future<Contact> getByUuid(String uuid);

  /// Removes a [Contact] by id from the repository.
  ///
  /// Throws [EntityNotFoundException] if the entity to remove is not found in storage.
  Future<void> remove(int id);

  /// Save a [Contact] in the repository and return the saved entity.
  ///
  /// If the entity id is 0 it should generate the next id, add the new entity to storage and return it.
  /// If the entity id is not 0 update the entry with that id.
  ///
  /// Returns the saved contact.
  Future<Contact> save(Contact value);
}
