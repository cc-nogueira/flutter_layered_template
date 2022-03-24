import '../entity/entity.dart';

/// Interface for an entity repository basic API.
///
/// This API does not define state change notifications.
/// Subclasses are expected, difining StateNotifiers or StreamNotifiers APIs.
abstract class EntityRepository<T extends Entity> {
  /// Returns the number of entities in the repository.
  ///
  /// May count only up to limit if adequate.
  /// Count all if limit is set to default value of zero.
  int count({int limit = 0});

  /// Return an entity by id.
  ///
  /// Throws an [EntityNotFoundException] if no entity is found with given id
  T get(int id);

  /// Return all entities from storage.
  ///
  /// The result list has no defined order.
  List<T> getAll();

  /// Save an entity in storage and return the saved entity.
  ///
  /// If the entity id is 0 it should generate the next id, add the new entity
  /// to storage and return it.
  ///
  /// If the entity id is not 0 update an existint entry with that id.
  ///
  /// Throws an [EntityNotFoundException] if the entity to update is not found
  /// in storage.
  T save(T user);

  /// Removes an entity by id.
  ///
  /// Removes an entity with the given id from the repository.
  ///
  /// Throws [EntityNotFoundException] if the entity to remove is not found in
  /// storage.
  void remove(int id);
}
