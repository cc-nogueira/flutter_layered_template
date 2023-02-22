import 'package:isar/isar.dart';

import '../../../domain_layer.dart';
import '../mapper/contact_mapper.dart';
import '../model/contact_model.dart';

/// [Isar] implementation of [ContactsRepository].
///
/// API receives and returns domain [Contact] entities.
/// Converts internally to [ContactModel] storage models.
class IsarContactsRepository implements ContactsRepository {
  /// Const constructor.
  const IsarContactsRepository(this._isar);

  /// Private reference to initialized Isar instance.
  ///
  /// This dependency is injected for [DataLayer] provisioning.
  final Isar _isar;

  /// Internal mapper for Entity/Model conversions.
  final _mapper = const ContactMapper();

  @override
  List<Contact> getAll() {
    final all = _mapper
        .mapEntities(
          _isar.contactModels.where().isPersonalityEqualToAnyName(true).sortByName().findAllSync(),
        )
        .toList();
    all.addAll(_mapper.mapEntities(
      _isar.contactModels.where().isPersonalityEqualToAnyName(false).sortByName().findAllSync(),
    ));
    return all;
  }

  @override
  Contact getByUuid(String uuid) {
    final found = _isar.contactModels.where().uuidEqualTo(uuid).findFirstSync();
    if (found == null) {
      throw const EntityNotFoundException();
    }
    return _mapper.mapEntity(found);
  }

  @override
  void remove(int id) {
    final success = _isar.writeTxnSync(() => _isar.contactModels.deleteSync(id));
    if (!success) {
      throw const EntityNotFoundException();
    }
  }

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
