import 'package:flutter_layered_template/src/domain/layer/domain_layer.dart';
import 'package:flutter_layered_template/src/domain/repository/things_repository.dart';
import 'package:flutter_layered_template/src/domain/service/whats_happening_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'domain_layer_test.mocks.dart';

@GenerateMocks([ThingsRepository, WhatsHappeningService])
void main() {
  late Provider<ThingsRepository> mockThingsRepositoryProvider;
  late Provider<WhatsHappeningService> mockWhatsHappeningServiceProvider;

  setUp(() {
    mockThingsRepositoryProvider = Provider((_) => MockThingsRepository());
    mockWhatsHappeningServiceProvider = Provider((_) => MockWhatsHappeningService());
  });

  test('Fully provisioned domain layer should validade true', () {
    final domain = DomainLayer()
      ..thingsRepositoryProvider = mockThingsRepositoryProvider
      ..whatsHappeningServiceProvider = mockWhatsHappeningServiceProvider;

    expect(domain.validateProvisioning(), true);
  });

  test('Missing any provisioning domain layer should validade false', () {
    var domain = DomainLayer()..thingsRepositoryProvider = mockThingsRepositoryProvider;
    expect(domain.validateProvisioning(), false);

    domain = DomainLayer()..whatsHappeningServiceProvider = mockWhatsHappeningServiceProvider;
    expect(domain.validateProvisioning(), false);
  });
}
