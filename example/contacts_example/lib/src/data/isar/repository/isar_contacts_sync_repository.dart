import 'package:isar/isar.dart';

import '../../../domain_layer.dart';
import '../mapper/contact_mapper.dart';
import '../model/contact_model.dart';

/// [Isar] implementation of [ContactsSyncRepository].
///
/// API receives and returns domain [Contact] entities.
/// Converts internally to [ContactModel] storage models.
///
/// This is the implementation of the synchronous repository example.
class IsarContactsSyncRepository implements ContactsSyncRepository {
  /// Const constructor.
  const IsarContactsSyncRepository(this._isar);

  /// Private reference to initialized Isar instance.
  ///
  /// This dependency is injected for [DataLayer] when provisioning the [DomainLayer].
  final Isar _isar;

  /// Internal mapper for Entity/Model conversions.
  final _mapper = const ContactMapper();

  /// Get all [Contact]s from storage sorted by personality then by name.
  @override
  List<Contact> getAll() {
    return [
      ..._mapper.mapEntities(
        _isar.contactModels.where().isPersonalityEqualToAnyName(true).sortByName().findAllSync(),
      ),
      ..._mapper.mapEntities(
        _isar.contactModels.where().isPersonalityEqualToAnyName(false).sortByName().findAllSync(),
      ),
    ];
  }

  /// Get a [Contact] from storage by uuid.
  ///
  /// Throws an [EntityNotFoundException] if no contact has this uuid.
  @override
  Contact getByUuid(String uuid) {
    final found = _isar.contactModels.where().uuidEqualTo(uuid).findFirstSync();
    if (found == null) {
      throw const EntityNotFoundException();
    }
    return _mapper.mapEntity(found);
  }

  /// Removes a [Contact] by id from the repository.
  ///
  /// Throws [EntityNotFoundException] if the entity to remove is not found in storage.
  @override
  void remove(int id) {
    final success = _isar.writeTxnSync(() => _isar.contactModels.deleteSync(id));
    if (!success) {
      throw const EntityNotFoundException();
    }
  }

  /// Save a [Contact] in the repository and return the saved entity.
  ///
  /// If the entity id is 0 it should generate the next id, add the new entity to storage and return it.
  /// If the entity id is not 0 update/create an entry with that id.
  ///
  /// Returns the saved contact.
  @override
  Contact save(Contact value) {
    final model = _mapper.mapModel(value);
    final int id = _isar.writeTxnSync(() => _isar.contactModels.putSync(model));
    if (value.id == null) {
      return value.copyWith(id: id);
    }
    return value;
  }
}
