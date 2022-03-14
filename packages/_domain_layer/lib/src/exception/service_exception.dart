class ServiceException implements Exception {
  const ServiceException([this.message = 'Unable to access message service.']);

  final String message;

  @override
  String toString() => message;
}
