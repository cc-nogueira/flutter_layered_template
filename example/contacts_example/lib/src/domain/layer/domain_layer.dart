import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/contacts_async_repository.dart';
import '../repository/contacts_sync_repository.dart';
import 'app_layer.dart';

/// [DomainLayer] singleton provider.
final domainLayerProvider = Provider((ref) => DomainLayer());

/// Domain layer is the central layer accessible to all other layers.
///
/// It defines types used by the whole application including:
///   - Entities (immutable state modeling objects).
///   - Exceptions (domain exceptions).
///   - Resitory interfaces to be provisioned by the DataLayer (optional).
///   - Service interfaces to be provisioned by the ServiceLayer (optional).
///   - Use cases defining business rules. These are the common gateway API to
///     access repositories, services and change internal app state.
///     Use cases will often expose StateNotifiers that are observed by the PresentationLayer.
///
/// This layer must be provisioned with runtime implementations of required interfaces.
/// This is usually coordinated by the outer layer, main.dart.
class DomainLayer extends AppLayer {
  /// Runtime provision [ContactsSyncRepository] implemention.
  late final Provider<ContactsSyncRepository> contactsSyncRepositoryProvider;

  /// Runtime provision [ContactsAsyncRepository] implemention.
  late final Provider<ContactsAsyncRepository> contactsAsyncRepositoryProvider;

  /// Validate the initialization of all expected provisions.
  bool validateProvisioning() {
    try {
      contactsSyncRepositoryProvider;
      contactsAsyncRepositoryProvider;
    } on Error {
      // LateError is an internal type.
      return false;
    }
    return true;
  }
}
