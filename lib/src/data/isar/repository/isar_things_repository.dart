import 'package:isar/isar.dart';

import '../../../domain_layer.dart';
import '../mapper/thing_mapper.dart';
import '../model/thing_model.dart';

/// [Isar] implementation of [ContactsRepository].
///
/// API receives and returns domain [Thing] entities.
/// Converts internally to [ThingModel] storage models.
class IsarThingsRepository implements ThingsRepository {
  /// Const constructor.
  const IsarThingsRepository(this._isar);

  /// Private reference to initialized Isar instance.
  ///
  /// This dependency is injected by [DataLayer] when provisioning the [DomainLayer].
  final Isar _isar;

  /// Internal mapper for Entity/Model conversions.
  final _mapper = const ThingMapper();

  @override
  List<Thing> getAll() {
    return _mapper.mapEntities(_isar.thingModels.where().sortByName().findAllSync());
  }

  @override
  void remove(int id) {
    final success = _isar.writeTxnSync(() => _isar.thingModels.deleteSync(id));
    if (!success) {
      throw const EntityNotFoundException();
    }
  }

  @override
  Thing save(Thing value) {
    final model = _mapper.mapModel(value);
    final int id = _isar.writeTxnSync(() => _isar.thingModels.putSync(model));
    if (value.id == null) {
      return value.copyWith(id: id);
    }
    return value;
  }
}
