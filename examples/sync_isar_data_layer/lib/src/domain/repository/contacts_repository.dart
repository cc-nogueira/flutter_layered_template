import '../entity/contact.dart';

/// Contacts Repository interface.
abstract class ContactsRepository {
  /// Get all [Contact]s from storage sorted by personality then by name.
  List<Contact> getAll();

  /// Get a [Contact] from storage by uuid.
  ///
  /// Throws an [EntityNotFoundException] if no contact has this uuid.
  Contact getByUuid(String uuid);

  /// Save a [Contact] in the repository and return the saved entity.
  ///
  /// If the entity id is 0 it should generate the next id, add the new entity to storage and return it.
  /// If the entity id is not 0 update the entry with that id.
  ///
  /// Returns the saved contact.
  Contact save(Contact value);

  /// Removes a [Contact] by id from the repository.
  ///
  /// Throws [EntityNotFoundException] if the entity to remove is not found in storage.
  void remove(int id);
}
