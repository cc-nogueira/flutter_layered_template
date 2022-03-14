import 'package:freezed_annotation/freezed_annotation.dart';

import 'entity.dart';

part 'contact.freezed.dart';

/// Contact domain entity.
///
/// Immutable class with contact properties.
@freezed
class Contact with _$Contact implements Entity {
  const factory Contact({
    @Default(0) int id,
    @Default('') String uuid,
    @Default('') String name,
  }) = _Contact;
}
