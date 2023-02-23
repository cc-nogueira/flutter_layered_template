import 'package:isar/isar.dart';

import '../../../domain_layer.dart';
import '../mapper/contact_mapper.dart';
import '../model/contact_model.dart';

/// [Isar] implementation of [ContactsAsyncRepository].
///
/// API receives and returns domain [Contact] entities.
/// Converts internally to [ContactModel] storage models.
///
/// This is the implementation of the async repository example.
///
/// Note:
/// We are adding a response delay just to allow the visualization of async loading intermediate state.
class IsarContactsAsyncRepository implements ContactsAsyncRepository {
  /// Const constructor.
  const IsarContactsAsyncRepository(this._isar);

  /// Delay for remote API simulation.
  ///
  /// Gives the example the chance to demonstrate waiting states in the interface.
  static const simulatedNetworkDelay = Duration(milliseconds: 1000);

  /// Private reference to initialized Isar instance.
  ///
  /// This dependency is injected for [DataLayer] when provisioning the [DomainLayer].
  final Isar _isar;

  /// Internal mapper for Entity/Model conversions.
  final _mapper = const ContactMapper();

  /// Get all [Contact]s from storage sorted by personality then by name.
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

  /// Get a [Contact] from storage by uuid.
  ///
  /// Throws an [EntityNotFoundException] if no contact has this uuid.
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

  /// Removes a [Contact] by id from the repository.
  ///
  /// Throws [EntityNotFoundException] if the entity to remove is not found in storage.
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

  /// Save a [Contact] in the repository and return the saved entity.
  ///
  /// If the entity id is 0 it should generate the next id, add the new entity to storage and return it.
  /// If the entity id is not 0 update the entry with that id.
  ///
  /// Returns the saved contact.
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

  /// Delay for remote API simulation.
  Future<void> _simulateNetworkDelay() => Future.delayed(simulatedNetworkDelay);
}
