import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Function type for building a runtime provision.
///
/// Runtime provisions are implementations of domain interfaces.
typedef ProvisionBuilder<T> = T Function();

/// Application Layer Class.
///
/// Each layer of the application will have one instance of [AppLayer].
/// These are the basic interalations between layers:
///
/// - DomainLayer is the central layer accessible to all other layers.
///   It defines types used by the whole application including:
///     - Entities (immutable state modeling objects).
///     - Exceptions (domain exceptions).
///     - Resitory interfaces to be provisioned by the DataLayer (optional).
///     - Service interfaces to be provisioned by the ServiceLayer (optional).
///     - Use cases defining business rules. These are the common gateway API to
///       access repositories, services and change internal app state.
///       Use cases will often expose StateNotifiers that are observed by the PresentationLayer.
///
/// - DataLayer is a satelite layer to the DomainLayer.
///   It's types are not visible to DomainLayer (use cases). Instead runtime implementations of Domain repositories
///   will be provisioned to the domain layer on app initialization (by the outer layer, main.dart).
///
/// - ServiceLayer is analogous to the DataLayer, provisoning Service interface implementations.
///
/// - PresentationLayer will present and watch state exposed by the DomainLayer.
///   All user action are captured by the presentation layer and acted on usecases potentially affecting domain state,
///   persisted state and external services.
///
/// - OuterLayer is contained in main.dart. This is the only scope that have access to all layers and is responsible to:
///     - await async initialization of all layers.
///     - provision the domain layer with required implementations.
///     - instantiate and open the MaterialApp.
///     - dispose all layers when the app finishes.
///
/// In this layered architecture PresentationLayer, DataLayer and ServiceLayer should not know anything about each
/// other. All inter layer relations must be mediated by domain types and implementations of domain interfaces
/// provisioned to domain use cases.
class AppLayer {
  /// Const constructor.
  const AppLayer();

  /// Async initialization.
  ///
  /// API is defined for async initialization for layers that depend on async loading. The DataLayer
  /// is a common candidate for using async initialization when its database will be configured.
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
