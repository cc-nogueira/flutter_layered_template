import '../../domain_layer.dart';
import '../model/otherthing_model.dart';

class OtherthingMapper extends EntityMapper<Otherthing, OtherthingModel> {
  /// Const constructor.
  const OtherthingMapper();

  @override
  Otherthing mapEntity(model) {
    return Otherthing(content: model.text);
  }

  @override
  OtherthingModel mapModel(Otherthing entity) {
    return OtherthingModel(text: entity.content);
  }
}
