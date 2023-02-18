import 'package:flutter_layered_template/src/domain/layer/domain_layer.dart';
import 'package:flutter_layered_template/src/domain/repository/contacts_repository.dart';
import 'package:flutter_layered_template/src/domain/service/message_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'domain_layer_test.mocks.dart';

@GenerateMocks([ContactsRepository, MessageService])
void main() {
  late Provider<ContactsRepository> mockRepositoryProvider;
  late Provider<MessageService> mockServiceProvider;

  setUp(() {
    mockRepositoryProvider = Provider((_) => MockContactsRepository());
    mockServiceProvider = Provider((_) => MockMessageService());
  });

  test('Fully provisioned domain layer should validade true', () {
    final domain = DomainLayer();
    domain
      ..contactsRepositoryProvider = mockRepositoryProvider
      ..messageServiceProvider = mockServiceProvider;

    expect(domain.validateProvisioning(), true);
  });

  test('Missing any provisioning domain layer should validade false', () {
    var domain = DomainLayer();
    expect(domain.validateProvisioning(), false);

    domain = DomainLayer()..contactsRepositoryProvider = mockRepositoryProvider;
    expect(domain.validateProvisioning(), false);

    domain = DomainLayer()..messageServiceProvider = mockServiceProvider;
    expect(domain.validateProvisioning(), false);

    domain = DomainLayer()
      ..contactsRepositoryProvider = mockRepositoryProvider
      ..messageServiceProvider = mockServiceProvider;

    expect(domain.validateProvisioning(), true);
  });
}
