import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/things_repository.dart';
import '../service/whats_happening_service.dart';
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
///       Use cases will often expose state [Notifier]s that are observed by the UILayer.
///
/// This layer must be provisioned by [ProvisioningLayer]s with runtime implementations of required interfaces.
/// This is coordinated by the outer layer in main.dart.
class DomainLayer extends AppLayer {
  /// Runtime provision of [ThingsRepository] implemention.
  late final Provider<ThingsRepository> thingsRepositoryProvider;

  /// Runtime provision of [WhatsHappeningService] implemention.
  late final Provider<WhatsHappeningService> whatsHappeningServiceProvider;

  /// Validate the initialization of all expected provisions.
  ///
  /// Here we try to read all late fields that need to be provisioned by some [ProvisioningLayer].
  ///
  /// It may look ugly to catch internal LateError to validate proper field initialization,
  /// but it is more elegant then having to code setters and getters for nullable fields.
  bool validateProvisioning() {
    try {
      thingsRepositoryProvider;
      whatsHappeningServiceProvider;
    } on Error {
      // We use Error because LateError is an internal type.
      return false;
    }
    return true;
  }
}
