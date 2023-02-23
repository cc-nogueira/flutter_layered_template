import '../../domain_layer.dart';
import '../model/otherthing_model.dart';

/// Map [Otherthing] entities to/from Isar [OtherthingModel] objects.
class OtherthingMapper extends EntityMapper<Otherthing, OtherthingModel> {
  /// Const constructor.
  const OtherthingMapper();

  /// Convert model to entity.
  @override
  Otherthing mapEntity(model) {
    return Otherthing(content: model.text);
  }

  /// Convert entity to model.
  @override
  OtherthingModel mapModel(Otherthing entity) {
    return OtherthingModel(text: entity.content);
  }
}
