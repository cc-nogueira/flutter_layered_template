/// Application Layer Class
///
/// Each layer of the application will have one instance of [AppLayer] to manage
/// the interaction between layers. Its basic responsibility is to provide an API to initialize
/// a layer at application startup and to dispose resources just before runtime exit.
///
/// On a broader perspective subclasses will expose its initialization requirements and
/// public features for its specific layer.
///
/// For example: DomainLayer will expose its initialization requirements in terms of required
/// implementations of known interfaces it need to  setup its usecase. DomainLayer will also expose
/// public configured use case objects for layers that depend on it.
///
/// This base AppLayer class defines the basic API for asynchronous initialization and layer disposal
/// with empty implementations. It is responsibility of subclasses, for specific Layers to redefine
/// these methods and define its richer API.
class AppLayer {
  const AppLayer();

  /// Async initialization.
  ///
  /// API is defined for async initialization for layers that depend on async loading. The DataLayer
  /// is a common candidate for using async initialization when its database will be configured.
  ///
  /// Application start up will wait on the init of each layer in onion order, from the most internal
  /// towards external layers.
  Future<void> init() async {}

  /// Layer disposing.
  ///
  /// Occurs at application exit. Available to release resources that are kept open for the whole
  /// execution of the application.
  void dispose() {}
}
