import 'package:freezed_annotation/freezed_annotation.dart';

part 'thing.freezed.dart';

/// An entity for some thing.
///
/// Immutable class with some properties.
@freezed
class Thing with _$Thing {
  /// Freezed factory.
  const factory Thing({
    int? id,
    @Default('') String name,
  }) = _Thing;
}
