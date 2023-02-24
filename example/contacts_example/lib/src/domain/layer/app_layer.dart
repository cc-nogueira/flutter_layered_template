import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'domain_layer.dart';

/// Application Layer Class.
///
/// Each layer of the application will have one instance of [AppLayer].
/// These are the basic inter-relations between layers:
///
/// - DomainLayer is the central layer visible to all other layers.
///   It defines types used by the whole application including:
///     - Entities (immutable state modeling objects).
///     - Exceptions (domain exceptions).
///     - Repository interfaces to be provisioned by the DataLayer (optional).
///     - Service interfaces to be provisioned by the ServiceLayer (optional).
///     - Use cases defining business rules. These are the common gateway API to
///       access repositories, services and change internal app state.
///       Use cases will often expose state [Notifier]s that are observed by the UILayer.
///
/// - DataLayer is a satelite layer to the DomainLayer.
///   It is visible only to the outer layer.
///   It's types are not visible to DomainLayer (use cases). Instead runtime implementations of Domain repositories
///   will be provisioned to the domain layer on app initialization (orchestrated by the outer layer, main.dart).
///
/// - ServiceLayer is analogous to the DataLayer, provisoning Service interface implementations.
///
/// - UILayer will present and watch state exposed by the DomainLayer.
///   It is visible only to the outer layer.
///   All user actions are captured by the UI layer and acted on usecases potentially affecting domain state,
///   persisted state and external services.
///
/// - OuterLayer is contained in main.dart. This is the only scope that have access to all layers and is responsible to:
///     - await async initialization of all layers.
///     - orchestrate that all [ProvisioningLayer]s provision the domain layer with required implementations.
///     - instantiate and open the Material App.
///     - dispose all layers when the app finishes.
///
/// In this layered architecture UILayer, DataLayer and ServiceLayer should know nothing about each other.
/// All inter-layer relations must be mediated by domain types and by domain interfaces implementations provisioned
/// to domain layer at app initialization.
class AppLayer {
  /// Const constructor.
  const AppLayer();

  /// Async initialization.
  ///
  /// API is defined for async initialization for layers that may depend on async loading. The DataLayer
  /// is a common candidate for using async initialization of storage.
  ///
  /// Application start up will wait on the init of each layer in onion order, from the most internal
  /// towards external layers.
  Future<void> init(Ref ref) async {}

  /// Layer disposing.
  ///
  /// Occurs at application exit. Available to release resources that are kept open for the whole
  /// execution of the application.
  void dispose() {}
}

/// Base class for layers that will provision runtime implementations to [DomainLayer].
///
/// There may be any number of provisioning layers, common examples are:
///   - DataLayer that provision repository implementations.
///   - ServiceLayer that provision service implementations.
abstract class ProvisioningLayer extends AppLayer {
  /// Const constructor.
  const ProvisioningLayer();

  /// Provision the domain layer with interface implementations.
  void provision(DomainLayer domainLayer);
}
