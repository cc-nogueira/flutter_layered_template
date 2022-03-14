import 'package:_core_layer/core_layer.dart';
import 'package:_domain_layer/domain_layer.dart';

import 'package:riverpod/riverpod.dart';

import '../service/remote_message_service.dart';

/// ServiceLayer has the responsibility to provide service implementaions.
///
/// ServiceLayer exposed implementations are also available through providers.
/// See [messageServiceProvider].
class ServiceLayer extends AppLayer {
  ServiceLayer(Reader reader) : messageService = RemoteMessageService(reader);

  final MessageService messageService;
}
