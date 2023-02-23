import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain_layer.dart';
import '../service/whats_happening_remote_service.dart';

/// [ServiceLayer] singleton provider.
final serviceLayerProvider = Provider((ref) => ServiceLayer());

/// Service Layer provisioning service implementations.
///
/// It is a satelite layer to the DomainLayer.
/// It is visible only to the outer layer.
/// It's types are not visible to DomainLayer (use cases). Instead runtime implementations of domain services
/// will be provisioned to the domain layer on app initialization (orchestrated by the outer layer, main.dart).
class ServiceLayer extends ProvisioningLayer {
  /// Provision [DomainLayer] with service implementations.
  @override
  void provision(DomainLayer domainLayer) {
    domainLayer.whatsHappeningServiceProvider = Provider((ref) => SomeRemoteService());
  }
}
