import 'package:_core_layer/core_layer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:riverpod/riverpod.dart';

import '../entity/example/contact.dart';
import '../provider/providers.dart';
import '../repository/example/contacts_repository.dart';
import '../service/example/message_service.dart';
import '../usecase/example/contacts_usecase.dart';

/// Function definition for Domain Layer dependencies
typedef DomainConfiguration = void Function({
  required ContactsRepository contactsRepository,
  required MessageService messageService,
});

/// DomainLayer has the responsibility to provide domain usecases.
///
/// On initialization this layer registers itself as a WidgetsBindings observer listenning to
/// changes in system locales, maintainging the corresponding system locales provider up to date.
///
/// To fullfill this responsibility DomainLayer requires its configuration to be
/// invoked before any usecase is accessed. Configuration is usually done during
/// DILayer's init() method.
///
/// DomainLayer configuration is also available through [domainConfigurationProvider].
///
/// Domains usecases are available through usecase providers:
///   - [contactsUsecaseProvider]
class DomainLayer extends AppLayer with WidgetsBindingObserver {
  /// Constructor.
  ///
  /// Required a Riverpod Reader to instantite the [PreferencesUsecase].
  DomainLayer({required this.read});

  /// Internal reader
  @internal
  final Reader read;

  late final ContactsUsecase contactsUsecase;
  late final StateNotifier<List<Contact>> contactsRepositoryNotifier;

  /// Initialize the DomainLayer.
  ///
  /// Intializes the systemLocalesProvider state and register this layer object as a
  /// WidgetsBindings observer to keep this provider always up to date with system locale changes.
  @override
  Future<void> init() {
    final systemLocales = WidgetsBinding.instance.platformDispatcher.locales;
    read(systemLocalesProvider.notifier).state = systemLocales;

    WidgetsBinding.instance.addObserver(this);

    return SynchronousFuture(null);
  }

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
