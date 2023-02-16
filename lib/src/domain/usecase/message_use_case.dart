import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../entity/contact.dart';
import '../entity/message.dart';
import '../layer/domain_layer.dart';
import '../service/message_service.dart';

part 'state/message_state.dart';
part 'message_use_case.g.dart';

@riverpod
MessageUseCase messageUseCase(MessageUseCaseRef ref) => MessageUseCase(
      messageService: domainLayer.serviceProvision.messageServiceBuilder(),
    );

class MessageUseCase {
  const MessageUseCase({required this.messageService});

  final MessageService messageService;

  Future<Message?> getMessageFor(contact) => messageService.getMessageFor(contact);
}
