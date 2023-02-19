import 'package:flutter_layered_template_isar_persistence/src/domain/layer/domain_layer.dart';
import 'package:flutter_layered_template_isar_persistence/src/domain/repository/contacts_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'domain_layer_test.mocks.dart';

@GenerateMocks([ContactsRepository])
void main() {
  late Provider<ContactsRepository> mockRepositoryProvider;

  setUp(() {
    mockRepositoryProvider = Provider((_) => MockContactsRepository());
  });

  test('Fully provisioned domain layer should validade true', () {
    final domain = DomainLayer()..contactsRepositoryProvider = mockRepositoryProvider;

    expect(domain.validateProvisioning(), true);
  });

  test('Missing any provisioning domain layer should validade false', () {
    final domain = DomainLayer();
    expect(domain.validateProvisioning(), false);
  });
}
