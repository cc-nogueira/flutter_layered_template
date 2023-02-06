part of '../message_usecase.dart';

@riverpod
class MessageState extends _$MessageState {
  @override
  FutureOr<Message?> build(Contact contact) {
    return ref.read(messageUsecaseProvider).getMessageFor(contact);
  }
}
