import '../../../domain_layer.dart';
import '../model/thing_model.dart';

/// Map [Thing] entities to/from Isar [ThingModel] objects.
class ThingMapper extends EntityMapper<Thing, ThingModel> {
  /// Const constructor.
  const ThingMapper();

  @override
  Thing mapEntity(ThingModel model) {
    return Thing(
      id: model.id,
      name: model.name,
    );
  }

  @override
  ThingModel mapModel(Thing entity) {
    return ThingModel()
      ..id = entity.id
      ..name = entity.name;
  }
}
