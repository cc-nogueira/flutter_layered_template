import 'package:isar/isar.dart';

part 'thing_model.g.dart';

/// Thing model for [Isar] persistence.
@collection
class ThingModel {
  /// Model primary key.

  /// If id is null Isar will generate the next id when persisting.
  /// If id is not null Isar will update the model with this id.
  Id? id;

  @Index()
  late String name;
}
