import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain_layer.dart';
import '../service/remote_message_service.dart';

/// [ServiceLayer] singleton provider.
final serviceLayerProvider = Provider((ref) => ServiceLayer());

/// Service Layer provisioning service implementations.
///
/// This is a satelite layer to the DomainLayer, it's types are not visible to DomainLayer (use cases).
/// Instead runtime implementations of Domain service interfaces will be provisioned to the domain layer on
/// app initialization (by the outer layer, main.dart).
///
/// In this case provision a fake [RemoteMessageService] builder.

class ServiceLayer extends AppLayer {
  /// Implementations provisioned by the service layer
  late final ServiceLayerProvision provision;

  /// Configures the instance [ServiceLayerProvision] that enables runtime provisioning of interface implementations.
  ///
  /// Uses a persistent singleton implementation of this service that holds state.
  @override
  Future<void> init(Ref ref) async {
    provision = ServiceLayerProvision(messageServiceBuilder: () => ref.read(remoteMessageServiceProvider));
  }
}
