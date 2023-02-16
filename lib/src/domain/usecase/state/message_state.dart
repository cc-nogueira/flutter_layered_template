part of '../message_use_case.dart';

@riverpod
class MessageState extends _$MessageState {
  @override
  FutureOr<Message?> build(Contact contact) {
    return ref.read(messageUseCaseProvider).getMessageFor(contact);
  }
}
