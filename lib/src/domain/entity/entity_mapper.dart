/// Mapper API to convert domain entities to/from persistence or service models.
abstract class EntityMapper<E, M> {
  /// Const constructor.
  const EntityMapper();

  /// Convert model to entity.
  E mapEntity(M model);

  /// Convert entity to model.
  M mapModel(E entity);

  /// Convert many models to a list of entities.
  List<E> mapEntities(Iterable<M> models) => models.map((model) => mapEntity(model)).toList();

  /// Convert many entities to a list of models.
  List<M> mapModels(Iterable<E> entities) => entities.map((e) => mapModel(e)).toList();
}
