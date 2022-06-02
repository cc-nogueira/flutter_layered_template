import 'package:_domain_layer/domain_layer.dart';
import 'package:riverpod/riverpod.dart';

import '../layer/service_layer.dart';

/// Layer provider
final serviceLayerProvider = Provider((ref) => ServiceLayer(ref.read));

/// MessageService interface implementation provider
final messageServiceProvider = Provider<MessageService>(
    (ref) => ref.watch(serviceLayerProvider.select((layer) => layer.messageService)));
