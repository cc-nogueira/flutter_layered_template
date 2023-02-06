import 'package:isar/isar.dart';

import 'isar_model.dart';

part 'contact_model.g.dart';

@collection
class ContactModel implements IsarModel {
  @override
  Id? id;

  @Index(type: IndexType.hash, unique: true)
  late String uuid;

  @Index()
  late String name;
}
