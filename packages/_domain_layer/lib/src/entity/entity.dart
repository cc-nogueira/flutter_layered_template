/// Entity interface.
///
/// Defines the minimum API for entities that will be implemented as
/// Freezed objects in subclasses
abstract class Entity {
  /// Entity storage key
  int get id;

  /// Suports Freezed copyWith generation
  get copyWith;
}
