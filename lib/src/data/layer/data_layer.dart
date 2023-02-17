import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../domain_layer.dart';
import '../isar/model/contact_model.dart';
import '../isar/repository/isar_contacts_repository.dart';

/// [DataLayer] singleton provider.
final dataLayerProvider = Provider((ref) => DataLayer());

/// Data Layer provisioning data repository implementations.
///
/// This is a satelite layer to the DomainLayer, it's types are not visible to DomainLayer (use cases).
/// Instead runtime implementations of Domain repositories will be provisioned to the domain layer on
/// app initialization (by the outer layer, main.dart).
///
/// Initializes the [Isar] instance and injects it into provision builders.
/// Provides the [DataLayerProvision] that enables runtime provisioning of interface implementations.
class DataLayer extends AppLayer {
  /// Internal Isar reference.
  ///
  /// Opened in [init]. Closed in [dispose].
  late final Isar _isar;

  /// Implementations provisioned by the data layer
  late final DataLayerProvision provision;

  /// Initialize the ISAR container.
  ///
  /// Configures the instance [DataLayerProvision] that enables runtime provisioning of interface implementations.
  @override
  Future<void> init(Ref ref) async {
    _isar = await Isar.open([
      ContactModelSchema,
    ]);

    provision = DataLayerProvision(contactsRepositoryBuilder: () => IsarContactsRepository(_isar));
  }

  /// Close the Isar instance.
  @override
  void dispose() {
    _isar.close();
    super.dispose();
  }
}
