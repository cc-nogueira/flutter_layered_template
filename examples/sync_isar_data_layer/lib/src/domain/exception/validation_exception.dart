/// Validation exception.
///
/// Exception for validation failure.
class ValidationException implements Exception {
  /// Const constructor.
  const ValidationException(this.message);

  final String message;
}
