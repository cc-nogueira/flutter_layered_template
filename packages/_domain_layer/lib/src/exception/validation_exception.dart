/// Validation exception.
///
/// Exception for validation failure.
class ValidationException implements Exception {
  const ValidationException(this.message);

  final String message;
}
