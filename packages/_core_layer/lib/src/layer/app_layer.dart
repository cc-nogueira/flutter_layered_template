/// Application Layer Class
///
/// Some layers will subclass AppLayer to implement theis responsibilities.
/// For example: DomainLayer will know how to setup its usecases when configured
/// with required interface implementations.
class AppLayer {
  const AppLayer();
  Future<void> init() async {}
  void dispose() {}
}
