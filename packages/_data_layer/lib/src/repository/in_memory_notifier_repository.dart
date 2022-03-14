import 'dart:math';

import 'package:_domain_layer/domain_layer.dart';

import 'package:riverpod/riverpod.dart';

/// Generic implementation of a InMemory Repository with StateNotifier API.
///
/// Objects are only kept during the runtime of the application, there is no
/// real persistence.
/// It is a quick implementation that does not need data
/// mappers and uses Riverpod StateNotifier for storage and state change
/// notifications.
class InMemoryNotifierRepository<T extends Entity>
    extends StateNotifier<List<T>> implements EntityNotifierRepository<T> {
  InMemoryNotifierRepository({List<T> initialData = const []})
      : super(initialData);

  /// Return a single entity from storage.
  ///
  /// Throws an [EntityNotFoundException] if no entity is found for the given id.
  @override
  T get(int id) => state.firstWhere(
        (e) => e.id == id,
        orElse: () => throw const EntityNotFoundException(),
      );

  /// Return all entities from storage.
  @override
  List<T> getAll() => state.toList();

  /// Save an entity in storage and return the saved entity.
  ///
  /// If entity's id is 0 expect the storage to generate an unique id, add the
  /// new entity and return it.
  ///
  /// If entity's id is not 0 update the entity with that id.
  ///
  /// Throws an [EntityNotFoundException] if the entity to update is not found
  /// in storage.
  @override
  T save(T entity) => entity.id == 0 ? _add(entity) : _update(entity);

  /// Remove an entity by id.
  ///
  /// Remove an entity by id.
  ///
  /// Throws [EntityNotFoundException] if the entity to remove is not found in
  /// storage.
  @override
  void remove(int id) {
    final newState = _stateWithout(id);
    if (newState.length == state.length) {
      throw const EntityNotFoundException();
    }
    state = newState;
  }

  T _add(T entity) {
    final newEntity = entity.copyWith(id: _generateNextId());
    state = [...state, newEntity];
    return newEntity;
  }

  T _update(T entity) {
    if (_containsId(entity.id)) {
      state = [..._stateWithout(entity.id), entity];
      return entity;
    }
    throw const EntityNotFoundException();
  }

  List<T> _stateWithout(int id) => [
        for (final entity in state)
          if (entity.id != id) entity,
      ];

  bool _containsId(int id) => state.any((element) => element.id == id);

  int _generateNextId() {
    int maxId = 0;
    for (final entity in state) {
      maxId = max(maxId, entity.id);
    }
    return maxId + 1;
  }
}
