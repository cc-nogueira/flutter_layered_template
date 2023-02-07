import 'dart:async';

import 'package:isar/isar.dart';

import '../../../domain_layer.dart';
import '../mapper/contact_mapper.dart';
import '../model/contact_model.dart';

class IsarContactsRepository implements ContactsRepository {
  const IsarContactsRepository(this._isar);

  final Isar _isar;

  final _mapper = const ContactMapper();

  @override
  Contact get(int id) {
    final found = _isar.contactModels.getSync(id);
    if (found == null) {
      throw const EntityNotFoundException();
    }
    return _mapper.mapEntity(found);
  }

  @override
  List<Contact> getAll() {
    return _mapper.mapEntities(_isar.contactModels.where().sortByName().findAllSync());
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

  @override
  List<Contact> saveAll(List<Contact> list) {
    final models = _mapper.mapModels(list);
    final ids = _isar.writeTxnSync(() => _isar.contactModels.putAllSync(models));
    final updated = <Contact>[];
    for (int i = 0; i < ids.length; ++i) {
      final each = list[i];
      if (each.id == null) {
        updated.add(each.copyWith(id: ids[i]));
      } else {
        updated.add(each);
      }
    }
    return updated;
  }

  @override
  Stream<Contact> watch(int id) {
    return _isar.contactModels.watchObject(id).transform<Contact>(
      StreamTransformer.fromHandlers(
        handleData: (model, sink) {
          if (model != null) {
            sink.add(_mapper.mapEntity(model));
          }
        },
      ),
    );
  }

  @override
  Stream<void> watchAll() {
    return _isar.contactModels.watchLazy();
  }
}
