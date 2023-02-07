import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain_layer.dart';
import '../service/remote_message_service.dart';

final serviceLayer = ServiceLayer();

/// ServiceLayer has the responsibility to provide service implementaions.
///
/// ServiceLayer exposed implementations are also available through providers.
/// See [messageServiceProvider].
class ServiceLayer extends AppLayer {
  /// Implementations provisioned by the service layer
  late final ServiceLayerProvision provision;

  @override
  Future<void> init(Ref ref) async {
    provision = ServiceLayerProvision(messageServiceBuilder: () => ref.read(remoteMessageServiceProvider));
  }
}
