import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/contact.dart';
import '../entity/message.dart';
import '../layer/domain_layer.dart';
import '../service/message_service.dart';
import 'use_case_notifier.dart';

final messageProvider = AsyncNotifierProvider.family.autoDispose<MessageUseCase, Message?, Contact>(MessageUseCase.new);

class MessageUseCase extends UseCaseAutoDisposeFamilyAsyncNotifier<Message?, Contact> {
  late final Contact contact;
  late final MessageService messageService;

  @override
  FutureOr<Message?> build(Contact arg) {
    final domainLayer = ref.read(domainLayerProvider);
    contact = arg;
    messageService = ref.read(domainLayer.messageServiceProvider);

    return _getMessage();
  }

  Future<Message?> _getMessage() => messageService.getMessageFor(contact);
}
