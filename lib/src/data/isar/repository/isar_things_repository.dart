import 'package:isar/isar.dart';

import '../../../domain.dart';
import '../mapper/thing_mapper.dart';
import '../model/thing_model.dart';

/// [Isar] implementation of [ThingsRepository].
///
/// API receives and returns domain entities ([Thing]s).
/// Converts internally to [ThingModel] storage objects.
class IsarThingsRepository implements ThingsRepository {
  /// Const constructor.
  const IsarThingsRepository(this._isar);

  /// Private reference to initialized Isar instance.
  ///
  /// This dependency is injected by [DataLayer] when provisioning the [DomainLayer].
  final Isar _isar;

  /// Internal mapper for Entity/Model conversions.
  final _mapper = const ThingMapper();

  /// Get all entities from storage sorted by name.
  @override
  List<Thing> getAll() {
    return _mapper.mapEntities(_isar.thingModels.where().sortByName().findAllSync());
  }

  /// Removes a [Thing] by id from the repository.
  ///
  /// Throws [EntityNotFoundException] if the entity to remove is not found in storage.
  @override
  void remove(int id) {
    final success = _isar.writeTxnSync(() => _isar.thingModels.deleteSync(id));
    if (!success) {
      throw const EntityNotFoundException();
    }
  }

  /// Save a [Thing] in the repository and return the saved entity.
  ///
  /// If the entity id is 0 it should generate the next id, add the new entity to storage and return it.
  /// If the entity id is not 0 update the entry with that id.
  ///
  /// Returns the saved entity.
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
