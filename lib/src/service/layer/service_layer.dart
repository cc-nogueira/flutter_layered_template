import 'package:riverpod/riverpod.dart';

import '../../core/layer/app_layer.dart';
import '../../domain/service/example/message_service.dart';
import '../service/example/remote_message_service.dart';

/// ServiceLayer has the responsibility to provide service implementaions.
///
/// ServiceLayer exposed implementations are also available through providers.
/// See [messageServiceProvider].
class ServiceLayer extends AppLayer {
  ServiceLayer(Ref ref) : messageService = RemoteMessageService(ref);

  final MessageService messageService;
}
