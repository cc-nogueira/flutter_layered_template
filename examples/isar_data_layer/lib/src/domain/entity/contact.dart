import 'package:freezed_annotation/freezed_annotation.dart';

part 'contact.freezed.dart';

/// Contact entity.
///
/// Immutable class with contact properties.
@freezed
class Contact with _$Contact {
  /// Freezed factory.
  const factory Contact({
    int? id,
    @Default('') String uuid,
    @Default('') String name,
  }) = _Contact;
}
