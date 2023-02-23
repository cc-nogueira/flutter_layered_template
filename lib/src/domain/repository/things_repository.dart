import '../entity/thing.dart';

/// Things repository interface.
///
/// This is a required dependency for Domain Layer initial configuration when an
/// implementation of this interface will be provisioned.
abstract class ThingsRepository {
  /// Get all entities from storage sorted by name.
  List<Thing> getAll();

  /// Removes a [Thing] by id from the repository.
  ///
  /// Throws [EntityNotFoundException] if the entity to remove is not found in storage.
  void remove(int id);

  /// Save a [Thing] in the repository and return the saved entity.
  ///
  /// If the entity id is 0 it should generate the next id, add the new entity to storage and return it.
  /// If the entity id is not 0 update the entry with that id.
  ///
  /// Returns the saved entity.
  Thing save(Thing value);
}
