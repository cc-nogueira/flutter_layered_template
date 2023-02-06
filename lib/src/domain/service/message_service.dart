import 'dart:async';

import '../entity/contact.dart';
import '../entity/message.dart';

/// Message Service interface.
///
/// This is a required dependency for Domain Layer intial configuration when an
/// implementation of this interface will be provisioned.
///
/// Throws a ServiceException if cannot access the remote service.
abstract class MessageService {
  /// Fetch message on a remote provider.
  ///
  /// Expects an async implementaion that returns a Future object.
  Future<Message?> getMessageFor(Contact contact);
}
