/// EntityNotFound exception.
///
/// Domain excetion for entities not found in storage.
class EntityNotFoundException implements Exception {
  const EntityNotFoundException([this.message = 'Entity not found in storage']);

  final String message;
}
