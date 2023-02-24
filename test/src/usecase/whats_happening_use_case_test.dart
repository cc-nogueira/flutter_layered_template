import 'package:flutter_layered_template/src/domain/entity/whats_happening.dart';
import 'package:flutter_layered_template/src/domain/exception/service_exception.dart';
import 'package:flutter_layered_template/src/domain/layer/domain_layer.dart';
import 'package:flutter_layered_template/src/domain/service/whats_happening_service.dart';
import 'package:flutter_layered_template/src/domain/usecase/whats_happening_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'whats_happening_use_case_test.mocks.dart';

@GenerateMocks([WhatsHappeningService])
void main() {
  late ProviderContainer container;

  late WhatsHappeningService mockService;

  const whatsHappening1 = WhatsHappening(content: 'something is on');

  setUp(() {
    mockService = MockWhatsHappeningService();

    container = ProviderContainer(overrides: [
      domainLayerProvider
          .overrideWithValue(DomainLayer()..whatsHappeningServiceProvider = Provider((_) => mockService)),
    ]);
  });

  group('whats happening from remote service', () {
    test('should resolve to null when service has no context', () async {
      when(mockService.getWhatsHappening()).thenAnswer((_) => Future.value(null));

      final other = await container.read(whatsHappeningProvider.future);

      expect(other, null);
      verify(mockService.getWhatsHappening());
      verifyNoMoreInteractions(mockService);
    });

    test('should return service response when there is content', () async {
      when(mockService.getWhatsHappening()).thenAnswer((_) => Future.value(whatsHappening1));

      final other = await container.read(whatsHappeningProvider.future);

      expect(other, whatsHappening1);
      verify(mockService.getWhatsHappening());
      verifyNoMoreInteractions(mockService);
    });

    test('should pass service exception when it occurs', () async {
      when(mockService.getWhatsHappening()).thenAnswer((_) => throw const ServiceException('Oh no!'));

      expect(
        () async => await container.read(whatsHappeningProvider.future),
        throwsA(isA<ServiceException>()),
      );

      verify(mockService.getWhatsHappening());
      verifyNoMoreInteractions(mockService);
    });
  });
}
