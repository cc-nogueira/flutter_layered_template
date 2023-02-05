import 'package:freezed_annotation/freezed_annotation.dart';

import 'contact.dart';

part 'message.freezed.dart';

@freezed
class Message with _$Message {
  const factory Message({
    required Contact sender,
    required Contact receiver,
    @Default('') String title,
    @Default('') String text,
  }) = _Message;
}
