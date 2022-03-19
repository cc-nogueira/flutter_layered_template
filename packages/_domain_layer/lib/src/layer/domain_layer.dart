import 'package:_core_layer/core_layer.dart';
import 'package:riverpod/riverpod.dart';

import '../entity/contact.dart';
import '../repository/contacts_repository.dart';
import '../service/message_service.dart';
import '../usecase/contacts_usecase.dart';

/// Function definition for Domain Layer dependencies
typedef DomainConfiguration = void Function({
  required ContactsRepository contactsRepository,
  required MessageService messageService,
});

/// DomainLayer has the responsibility to provide domain usecases.
///
/// To fullfill this responsibility DomainLayer requires its configuration to be
/// invoked before any usecase is accessed. Configuration is usually done during
/// DILayer's init() method.
///
/// DomainLayer configuration is also available through [domainConfigurationProvider].
///
/// Domains usecases are available through usecase providers:
///   - [contactsUsecaseProvider]
class DomainLayer extends AppLayer {
  late final ContactsUsecase contactsUsecase;
  late final StateNotifier<List<Contact>> contactsRepositoryNotifier;

  void configure({
    required ContactsRepository contactsRepository,
    required MessageService messageService,
  }) {
    contactsUsecase = ContactsUsecase(
      repository: contactsRepository,
      messageService: messageService,
    );
    contactsRepositoryNotifier = contactsRepository;
  }
}
