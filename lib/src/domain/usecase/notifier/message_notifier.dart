part of '../message_use_case.dart';

@riverpod
class MessageNotifier extends _$MessageNotifier {
  @override
  FutureOr<Message?> build(Contact contact) {
    return ref.read(messageUseCaseProvider)._getMessageFor(contact);
  }
}
