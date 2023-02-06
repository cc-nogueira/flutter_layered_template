import 'package:isar/isar.dart';

/// Abstract persistence model super class.
///
/// Defines just the required Isar persistence key.
abstract class IsarModel {
  /// Isar key field.
  /// This field should null for new models (not persisted), and should never be numbered by
  /// the application. It is sole Isar responsibilitiy to define objects ids.
  Id? get id;
}
