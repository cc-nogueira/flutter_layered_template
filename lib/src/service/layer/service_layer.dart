import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/layer/app_layer.dart';
import '../../domain/layer/domain_layer.dart';
import '../service/example/remote_message_service.dart';

final serviceLayer = ServiceLayer();

/// ServiceLayer has the responsibility to provide service implementaions.
///
/// ServiceLayer exposed implementations are also available through providers.
/// See [messageServiceProvider].
class ServiceLayer extends AppLayer {
  /// Constructor.
  ServiceLayer();

  late final ServiceLayerProvision provision;

  @override
  Future<void> init(Ref ref) async {
    provision = ServiceLayerProvision(messageServiceBuilder: () => ref.read(remoteMessageServiceProvider));
  }
}
