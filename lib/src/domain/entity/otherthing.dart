import 'package:freezed_annotation/freezed_annotation.dart';

part 'otherthing.freezed.dart';

/// Some other remote entity.
///
/// Immutable class with some remote properties.
@freezed
class Otherthing with _$Otherthing {
  /// Freezed factory.
  const factory Otherthing({
    required String content,
  }) = _Otherthing;
}
