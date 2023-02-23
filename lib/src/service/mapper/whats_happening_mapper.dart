import '../../domain_layer.dart';
import '../model/whats_happening_model.dart';

/// Map [Otherthing] entities to/from Isar [WhatsHappeningModel] objects.
class OtherthingMapper extends EntityMapper<WhatsHappening, WhatsHappeningModel> {
  /// Const constructor.
  const OtherthingMapper();

  /// Convert model to entity.
  @override
  WhatsHappening mapEntity(model) {
    return WhatsHappening(content: model.text);
  }

  /// Convert entity to model.
  @override
  WhatsHappeningModel mapModel(WhatsHappening entity) {
    return WhatsHappeningModel(text: entity.content);
  }
}
