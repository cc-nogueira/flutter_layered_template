import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../domain_layer.dart';
import '../isar/model/contact_model.dart';
import '../isar/repository/isar_contacts_async_repository.dart';
import '../isar/repository/isar_contacts_sync_repository.dart';

/// [DataLayer] singleton provider.
final dataLayerProvider = Provider((ref) => DataLayer());

/// Data Layer provisioning data repository implementations.
///
/// It is a satelite layer to the DomainLayer.
/// It is visible only to the outer layer.
/// It's types are not visible to DomainLayer (use cases). Instead runtime implementations of domain repositories
/// will be provisioned to the domain layer on app initialization (orchestrated by the outer layer, main.dart).
///
/// Initializes the [Isar] instance and injects it into provision providers.
/// Do runtime provisioning of repository implementations.
class DataLayer extends ProvisioningLayer {
  /// Internal Isar reference.
  ///
  /// Opened in [init]. Closed in [dispose].
  late final Isar _isar;

  /// Initialize the ISAR container.
  @override
  Future<void> init(Ref ref) async {
    _isar = await Isar.open([
      ContactModelSchema,
    ]);
  }

  /// Provision [DomainLayer] with repository implementations.
  ///
  /// In this example we are providing both sync and async implementations.
  @override
  void provision(DomainLayer domainLayer) {
    domainLayer.contactsSyncRepositoryProvider =
        Provider<ContactsSyncRepository>((ref) => IsarContactsSyncRepository(_isar));

    domainLayer.contactsAsyncRepositoryProvider =
        Provider<ContactsAsyncRepository>((ref) => IsarContactsAsyncRepository(_isar));
  }

  /// Close the Isar instance.
  @override
  void dispose() {
    _isar.close();
    super.dispose();
  }
}
