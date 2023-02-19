import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../entity/contact.dart';
import '../entity/message.dart';
import '../layer/domain_layer.dart';
import '../service/message_service.dart';

part 'notifier/message_notifier.dart';

part 'message_use_case.g.dart';

final messageUseCaseProvider =
    Provider((ref) => MessageUseCase(messageService: ref.read(ref.read(domainLayerProvider).messageServiceProvider)));

class MessageUseCase {
  const MessageUseCase({required this.messageService});

  final MessageService messageService;

  // @override
  // FutureOr<Message?> build(Contact arg) {
  //   final domainLayer = ref.read(domainLayerProvider);
  //   contact = arg;
  //   messageService = ref.read(domainLayer.messageServiceProvider);

  //   return _getMessage();
  // }

  Future<Message?> _getMessageFor(Contact contact) => messageService.getMessageFor(contact);
}
