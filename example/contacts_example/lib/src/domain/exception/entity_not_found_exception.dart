/// EntityNotFound exception.
///
/// Domain exception for entities not found in storage.
class EntityNotFoundException implements Exception {
  /// Const constructor.
  const EntityNotFoundException([this.message = 'Entity not found in storage']);

  /// Exception message.
  final String message;
}
