/// Service exception.
///
/// Generic exception for errors accessing a service.
class ServiceException implements Exception {
  /// Const constructor.
  const ServiceException([this.message = 'Unable to access service.']);

  /// Service message.
  final String message;

  @override
  String toString() => message;
}
