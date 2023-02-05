import 'package:riverpod/riverpod.dart';

import '../../domain/service/example/message_service.dart';
import '../layer/service_layer.dart';

/// Layer provider
final serviceLayerProvider = Provider((ref) => ServiceLayer(ref));

/// MessageService interface implementation provider
final messageServiceProvider =
    Provider<MessageService>((ref) => ref.watch(serviceLayerProvider.select((layer) => layer.messageService)));
