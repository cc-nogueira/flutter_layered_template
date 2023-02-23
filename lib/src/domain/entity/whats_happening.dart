import 'package:freezed_annotation/freezed_annotation.dart';

part 'whats_happening.freezed.dart';

/// Some other remote entity.
///
/// Immutable class with some remote properties.
@freezed
class WhatsHappening with _$WhatsHappening {
  /// Freezed factory.
  const factory WhatsHappening({
    required String content,
    @Default('') String blah,
  }) = _WhatsHappening;
}
