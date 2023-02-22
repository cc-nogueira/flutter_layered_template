import 'package:isar/isar.dart';

import '../../../domain_layer.dart';
import '../mapper/contact_mapper.dart';
import '../model/contact_model.dart';

/// [Isar] implementation of [ContactsAsyncRepository].
///
/// API receives and returns domain [Contact] entities.
/// Converts internally to [ContactModel] storage models.
///
/// This is the implementaition of the async repository example.
///
/// We are adding a response delay just to allow the visualization of async loading intermediate state.
class IsarContactsAsyncRepository implements ContactsAsyncRepository {
  /// Const constructor.
  const IsarContactsAsyncRepository(this._isar);

  static const simulatedNetworkDelay = Duration(milliseconds: 500);

  /// Private reference to initialized Isar instance.
  ///
  /// This dependency is injected for [DataLayer] provisioning.
  final Isar _isar;

  /// Internal mapper for Entity/Model conversions.
  final _mapper = const ContactMapper();

  @override
  Future<List<Contact>> getAll() async {
    await _simulateNetworkDelay();
    return [
      ..._mapper.mapEntities(
        await _isar.contactModels.where().isPersonalityEqualToAnyName(true).sortByName().findAll(),
      ),
      ..._mapper.mapEntities(
        await _isar.contactModels.where().isPersonalityEqualToAnyName(false).sortByName().findAll(),
      ),
    ];
  }

  @override
  Future<Contact> getByUuid(String uuid) async {
    await _simulateNetworkDelay();
    return _isar.contactModels.where().uuidEqualTo(uuid).findFirst().then(
      (found) {
        if (found == null) {
          throw const EntityNotFoundException();
        }
        return _mapper.mapEntity(found);
      },
    );
  }

  @override
  Future<void> remove(int id) async {
    await _simulateNetworkDelay();
    return _isar.writeTxn(() => _isar.contactModels.delete(id)).then(
      (success) {
        if (!success) {
          throw const EntityNotFoundException();
        }
      },
    );
  }

  @override
  Future<Contact> save(Contact value) async {
    await _simulateNetworkDelay();
    final model = _mapper.mapModel(value);
    return _isar.writeTxn(() => _isar.contactModels.put(model)).then(
      (id) {
        if (value.id == null) {
          return value.copyWith(id: id);
        }
        return value;
      },
    );
  }

  Future<void> _simulateNetworkDelay() => Future.delayed(simulatedNetworkDelay);
}
