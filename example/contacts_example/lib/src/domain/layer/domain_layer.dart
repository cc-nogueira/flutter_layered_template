import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/contacts_async_repository.dart';
import '../repository/contacts_sync_repository.dart';
import 'app_layer.dart';

/// [DomainLayer] singleton provider.
final domainLayerProvider = Provider((ref) => DomainLayer());

/// Domain layer is the central layer visible to all other layers.
///
/// - DomainLayer is the central layer visible to all other layers.
///   It defines types used by the whole application including:
///     - Entities (immutable state modeling objects).
///     - Exceptions (domain exceptions).
///     - Repository interfaces to be provisioned by the DataLayer (optional).
///     - Service interfaces to be provisioned by the ServiceLayer (optional).
///     - Use cases defining business rules. These are the common gateway API to
///       access repositories, services and change internal app state.
///       Use cases will often expose state [Notifier]s that are observed by the PresentationLayer.
///
/// This layer must be provisioned by [ProvisioningLayer]s with runtime implementations of required interfaces.
/// This is coordinated by the outer layer in main.dart.
class DomainLayer extends AppLayer {
  /// Runtime provision [ContactsSyncRepository] implemention.
  late final Provider<ContactsSyncRepository> contactsSyncRepositoryProvider;

  /// Runtime provision [ContactsAsyncRepository] implemention.
  late final Provider<ContactsAsyncRepository> contactsAsyncRepositoryProvider;

  /// Validate the initialization of all expected provisions.
  ///
  /// Here we try to read all late fields that need to be provisioned by some [ProvisioningLayer].
  ///
  /// It may look ugly to catch internal LateError to validate proper field initialization,
  /// but it is more elegant then having to code setters and getters for nullable fields.
  bool validateProvisioning() {
    try {
      contactsSyncRepositoryProvider;
      contactsAsyncRepositoryProvider;
    } on Error {
      // We use Error because LateError is an internal type.
      return false;
    }
    return true;
  }
}
