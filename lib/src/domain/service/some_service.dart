import 'dart:async';

import '../entity/otherthing.dart';

/// Some service interface.
///
/// This is a required dependency for Domain Layer initial configuration when an
/// implementation of this interface will be provisioned.
///
/// Throws a ServiceException if cannot access the remote service.
abstract class SomeService {
  /// Fetch [Otherthing] from a remote service.
  ///
  /// Expects an async implementaion that returns a Future object.
  ///
  /// Resolves to null if the remote service responds with no content.
  /// May throw a ServiceException.
  Future<Otherthing?> getSomething();
}
