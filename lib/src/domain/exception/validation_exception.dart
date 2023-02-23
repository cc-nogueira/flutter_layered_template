/// Validation exception.
///
/// Exception for validation failures.
class ValidationException implements Exception {
  /// Const constructor.
  const ValidationException(this.message);

  /// Validation message.
  final String message;
}
