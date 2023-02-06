import '../repository/contacts_repository.dart';
import '../service/message_service.dart';

class DataLayerProvision {
  const DataLayerProvision({required this.contactsRepository});

  final ContactsRepository contactsRepository;
}

class ServiceLayerProvision {
  ServiceLayerProvision({required this.messageService});

  final MessageService messageService;
}
