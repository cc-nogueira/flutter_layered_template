/// AsyncGuardViolation exception.
///
/// Domain exception for use case async guard violation.
/// Use cases may throw on overlapped operations on the same resource.
class AsyncGuardViolation implements Exception {
  /// Const constructor.
  const AsyncGuardViolation();
}
