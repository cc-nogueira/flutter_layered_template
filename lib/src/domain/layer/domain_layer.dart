import '../repository/contacts_repository.dart';
import '../service/message_service.dart';
import 'app_layer.dart';

/// [DomainLayer] singleton.
final domainLayer = DomainLayer();

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
/// Here we define the [DataLayerProvision] and [ServiceLayerProvision] classes that must be
/// provisioned on app initialization by the outer layer, main.dart.
class DomainLayer extends AppLayer {
  /// Runtime provision of Repository interfaces.
  late final DataLayerProvision dataProvision;

  /// Runtime provision of Service interfaces.
  late final ServiceLayerProvision serviceProvision;

  /// Runtime provisioning of interface implementations.
  ///
  /// This method must be called on app initialization, usually from main.dart.
  void provisioning({required DataLayerProvision dataProvision, required ServiceLayerProvision serviceProvision}) {
    this.dataProvision = dataProvision;
    this.serviceProvision = serviceProvision;
  }
}

/// Data Layer provisions.
///
/// Define builders for repository interfaces that need to be implemented in the data layer.
class DataLayerProvision {
  /// Const constructor.
  const DataLayerProvision({required this.contactsRepositoryBuilder});

  /// [ContactsRepository] implemention provisioned by a [ProvisionBuilder].
  final ProvisionBuilder<ContactsRepository> contactsRepositoryBuilder;
}

/// Service Layer provisions.
///
/// Define the domain interfaces that need to be implemented in the service layer.
class ServiceLayerProvision {
  /// Const constructor.
  const ServiceLayerProvision({required this.messageServiceBuilder});

  /// [MessageService] implemention provisioned by a [ProvisionBuilder].
  final ProvisionBuilder<MessageService> messageServiceBuilder;
}
