import '../repository/contacts_repository.dart';
import '../service/message_service.dart';
import 'app_layer.dart';

final domainLayer = DomainLayer();

class DomainLayer extends AppLayer {
  /// Runtime provision of Repository interfaces.
  late final DataLayerProvision dataProvision;

  /// Runtime provision of Service interfaces.
  late final ServiceLayerProvision serviceProvision;

  /// Runtime provisioning of interface implementations.
  ///
  /// This method must be calles only once, usually from main.dart.
  void provisioning({required DataLayerProvision dataProvision, required ServiceLayerProvision serviceProvision}) {
    this.dataProvision = dataProvision;
    this.serviceProvision = serviceProvision;
  }
}

/// Data Layer provisions.
///
/// Define the domain interfaces that need to be implemented in the data layer.
class DataLayerProvision {
  const DataLayerProvision({required this.contactsRepositoryBuilder});

  final ProvisionBuilder<ContactsRepository> contactsRepositoryBuilder;
}

/// Service Layer provisions.
///
/// Define the domain interfaces that need to be implemented in the service layer.
class ServiceLayerProvision {
  const ServiceLayerProvision({required this.messageServiceBuilder});

  final ProvisionBuilder<MessageService> messageServiceBuilder;
}
