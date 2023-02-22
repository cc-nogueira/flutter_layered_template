import 'dart:core';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repository/things_repository.dart';
import '../service/some_service.dart';
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
  /// Runtime provision [ThingsRepository] implemention.
  late final Provider<ThingsRepository> thingsRepositoryProvider;

  /// Runtime provision of [SomeService] implemention.
  late final Provider<SomeService> someServiceProvider;

  /// Validate the initialization of all expected provisions.
  bool validateProvisioning() {
    try {
      thingsRepositoryProvider;
      someServiceProvider;
    } on Error {
      // LateError is an internal type.
      return false;
    }
    return true;
  }
}
