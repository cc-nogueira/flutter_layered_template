import '../entity/entity.dart';
import '../exception/entity_not_found_exception.dart';
import '../repository/entity_notifier_repository.dart';

/// Usecase with common Entity business rules.
///
/// This class must be injected with an [EntityNotifierRepository].
///
/// It provides an API to access and update [Entity]s mainly by its notifier API.
/// See providers.
abstract class EntityNotifierUsecase<T extends Entity> {
  EntityNotifierUsecase({required EntityNotifierRepository<T> repository})
      : _repository = repository;

  final EntityNotifierRepository<T> _repository;

  /// Returns a single entity from storage by id.
  ///
  /// Expects that the repository throws a EntityNotFoundException when id is not
  /// found.
  T get(int id) => _repository.get(id);

  /// Returns all entities from storage.
  ///
  /// The returned list is sorted using [_compare] function that is subclass
  /// responsibility.
  List<T> getAll() {
    final list = _repository.getAll();
    sort(list);
    return list;
  }

  /// Sort list of entities.
  ///
  /// Uses subclass responsibility [_compare] function.
  /// May be redifined for custom or no sort implementations.
  void sort(List<T> list) => list.sort(compare);

  /// Compare two entities for sorting.
  ///
  /// Sublass responsibility.
  int compare(T a, T b);

  /// Removes an entity by id.
  ///
  /// Removes an entity with the given id from the repository.
  ///
  /// Pass on the [EntityNotFoundException] thrown by the repositoty if the
  /// entity to remove is not found in storage.
  void remove(int id) => _repository.remove(id);

  /// Save an entity in the repository and return the saved entity.
  ///
  /// Call validate before saving. It is subclass responsibility
  /// to implement validate that would throw a VaidationException if contact does not pass validation.
  ///
  /// If contact's id is 0 the repository will be responsible to generate
  /// a unique id, persist and return this new entity with its generated id.
  ///
  /// If contact's id is not 0 the repository should update the entity with
  /// the given id.
  ///
  /// If the entity to update is not found in storage the repository must throw
  /// an [EntityNotFoundException].
  T save(T entity) {
    validate(entity);
    final adjusted = adjust(entity);
    return _repository.save(adjusted);
  }

  /// Validate contact's content.
  ///
  /// Throws a validation exception if contact's name is empty or if any email
  /// is filled but invalid.
  void validate(T entity);

  /// Adjust contact's contents.
  ///
  /// Calls _adjustName, _adjustPhones and _adjustEmails.
  T adjust(T entity);
}
