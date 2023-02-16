import 'package:freezed_annotation/freezed_annotation.dart';

import 'contact.dart';

part 'message.freezed.dart';

/// Message entity.
///
/// Immutable class with message properties.
@freezed
class Message with _$Message {
  /// Freezed factory.
  const factory Message({
    required Contact sender,
    required Contact receiver,
    @Default('') String title,
    @Default('') String text,
  }) = _Message;
}
