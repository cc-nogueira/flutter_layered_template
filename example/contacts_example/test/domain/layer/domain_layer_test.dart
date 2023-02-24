import 'package:flutter_layered_template_contacts_example/src/domain/layer/domain_layer.dart';
import 'package:flutter_layered_template_contacts_example/src/domain/repository/contacts_async_repository.dart';
import 'package:flutter_layered_template_contacts_example/src/domain/repository/contacts_sync_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'domain_layer_test.mocks.dart';

@GenerateMocks([ContactsSyncRepository, ContactsAsyncRepository])
void main() {
  late Provider<ContactsSyncRepository> mockSyncRepositoryProvider;
  late Provider<ContactsAsyncRepository> mockAsyncRepositoryProvider;

  setUp(() {
    mockSyncRepositoryProvider = Provider((_) => MockContactsSyncRepository());
    mockAsyncRepositoryProvider = Provider((_) => MockContactsAsyncRepository());
  });

  test('Fully provisioned domain layer should validade true', () {
    final domain = DomainLayer()
      ..contactsSyncRepositoryProvider = mockSyncRepositoryProvider
      ..contactsAsyncRepositoryProvider = mockAsyncRepositoryProvider;

    expect(domain.validateProvisioning(), true);
  });

  test('Missing any provisioning domain layer should validade false', () {
    final domain = DomainLayer()..contactsSyncRepositoryProvider = mockSyncRepositoryProvider;
    expect(domain.validateProvisioning(), false);
  });
}
