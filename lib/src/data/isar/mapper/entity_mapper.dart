import '../../../domain_layer.dart';
import '../model/isar_model.dart';

/// Mapper API to convert domain entities to persistence models and vice-versa.
abstract class EntityMapper<E extends Entity, M extends IsarModel> {
  /// Const constructor.
  const EntityMapper();

  /// Convert model to entity.
  E mapEntity(M model);

  /// Convert entity to model.
  M mapModel(E entity);

  /// Convert many models to a list of entities.
  List<E> mapEntities(Iterable<M> models) => List.unmodifiable(models.map((model) => mapEntity(model)));

  /// Convert many entities to a list of models.
  List<M> mapModels(Iterable<E> entities) => List.unmodifiable(entities.map((e) => mapModel(e)));
}
