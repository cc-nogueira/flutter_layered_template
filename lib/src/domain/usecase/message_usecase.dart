import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../entity/contact.dart';
import '../entity/message.dart';
import '../layer/domain_layer.dart';
import '../service/message_service.dart';

part 'state/message_state.dart';
part 'message_usecase.g.dart';

@riverpod
MessageUsecase messageUsecase(MessageUsecaseRef ref) => MessageUsecase(
      messageService: domainLayer.serviceProvision.messageService,
    );

class MessageUsecase {
  const MessageUsecase({required this.messageService});

  final MessageService messageService;

  Future<Message?> getMessageFor(contact) => messageService.getMessageFor(contact);
}
