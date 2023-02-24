import 'dart:async';

import '../entity/whats_happening.dart';

/// [WhatsHappening] service interface.
///
/// This is a required dependency for Domain Layer initial configuration when an
/// implementation of this interface will be provisioned.
///
/// Services usually have an async API to better cope with network delays and errors.
///
/// Methods may throw a [ServiceException].
abstract class WhatsHappeningService {
  /// Fetch [WhatsHappening] from a remote service.
  ///
  /// Expects an async implementaion that returns a Future object.
  ///
  /// Resolves to null if the remote service responds with no content.
  /// May throw a ServiceException.
  Future<WhatsHappening?> getWhatsHappening();
}
