import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';

import '../../domain/layer/app_layer.dart';
import '../../domain/layer/domain_provisioning.dart';
import '../isar/model/contact_model.dart';
import '../isar/repository/isar_contacts_repository.dart';

final dataLayer = DataLayer();

/// DataLayer has the responsibility to provide repository implementaions.
class DataLayer extends AppLayer {
  /// Constructor.
  DataLayer();

  /// Implementations provisioned by the data layer
  late final DataLayerProvision provision;

  /// Initialize the ISAR container.
  ///
  /// Configures the [DataLayer.internal] module.
  /// Enable runtime provisioning of interface implementations.
  @override
  Future<void> init(Ref ref) async {
    final isar = await Isar.open([
      ContactModelSchema,
    ]);

    provision = DataLayerProvision(contactsRepository: IsarContactsRepository(isar));
  }
}
