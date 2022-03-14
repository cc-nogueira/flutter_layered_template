class ValidationException implements Exception {
  const ValidationException(this.message);

  final String message;
}
