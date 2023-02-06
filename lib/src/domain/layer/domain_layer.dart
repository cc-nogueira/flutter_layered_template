import '../repository/contacts_repository.dart';
import '../service/message_service.dart';
import 'app_layer.dart';

final domainLayer = DomainLayer();

class DomainLayer extends AppLayer {
  late final DataLayerProvision dataProvision;
  late final ServiceLayerProvision serviceProvision;

  void provisioning({required DataLayerProvision dataProvision, required ServiceLayerProvision serviceProvision}) {
    this.dataProvision = dataProvision;
    this.serviceProvision = serviceProvision;
  }
}

typedef ProvisionBuilder<T> = T Function();

class DataLayerProvision {
  const DataLayerProvision({required this.contactsRepositoryBuilder});

  final ProvisionBuilder<ContactsRepository> contactsRepositoryBuilder;
}

class ServiceLayerProvision {
  ServiceLayerProvision({required this.messageServiceBuilder});

  final ProvisionBuilder<MessageService> messageServiceBuilder;
}
