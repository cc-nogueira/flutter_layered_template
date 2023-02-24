import 'package:freezed_annotation/freezed_annotation.dart';

part 'whats_happening.freezed.dart';

/// Whats happening entity.
///
/// Immutable class with whats happening.
@freezed
class WhatsHappening with _$WhatsHappening {
  /// Freezed factory.
  const factory WhatsHappening({
    required String content,
    @Default('') String blah,
  }) = _WhatsHappening;
}
