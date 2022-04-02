import 'package:_core_layer/core_layer.dart';
import 'package:_domain_layer/domain_layer.dart';

import 'package:riverpod/riverpod.dart';

import '../service/example/remote_message_service.dart';

/// ServiceLayer has the responsibility to provide service implementaions.
///
/// ServiceLayer exposed implementations are also available through providers.
/// See [messageServiceProvider].
class ServiceLayer extends AppLayer {
  ServiceLayer(Reader read) : messageService = RemoteMessageService(read);

  final MessageService messageService;
}
