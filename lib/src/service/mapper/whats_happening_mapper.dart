import '../../domain.dart';
import '../model/whats_happening_model.dart';

/// Map [WhatsHappening] entities to/from Isar [WhatsHappeningModel] objects.
class WhatsHappeningMapper extends EntityMapper<WhatsHappening, WhatsHappeningModel> {
  /// Const constructor.
  const WhatsHappeningMapper();

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
