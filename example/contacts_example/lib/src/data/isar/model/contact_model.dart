import 'package:isar/isar.dart';

part 'contact_model.g.dart';

/// Contact model for [Isar] persistence.
@collection
class ContactModel {
  /// Model primary key.
  ///
  /// If id is null Isar will generate the next id when persisting.
  /// If id is not null Isar will update the model with this id.
  Id? id;

  /// Indexed unique uuid.
  @Index(type: IndexType.hash, unique: true)
  late String uuid;

  /// Composed index of isPersonality and name.
  @Index(composite: [CompositeIndex('name')])
  late bool isPersonality;

  late String name;
  late String about;
  int? avatarColor;
}
