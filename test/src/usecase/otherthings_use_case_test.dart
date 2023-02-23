import 'package:flutter_layered_template/src/domain/entity/otherthing.dart';
import 'package:flutter_layered_template/src/domain/exception/service_exception.dart';
import 'package:flutter_layered_template/src/domain/layer/domain_layer.dart';
import 'package:flutter_layered_template/src/domain/service/some_service.dart';
import 'package:flutter_layered_template/src/domain/usecase/otherthings_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'otherthings_use_case_test.mocks.dart';

@GenerateMocks([SomeService])
void main() {
  late ProviderContainer container;

  late SomeService mockService;

  const otherThing1 = Otherthing(content: 'one other thing');

  setUp(() {
    mockService = MockSomeService();

    container = ProviderContainer(overrides: [
      domainLayerProvider.overrideWithValue(DomainLayer()..someServiceProvider = Provider((_) => mockService)),
    ]);
  });

  group('otherthing from remote service', () {
    test('should resolve to null when service has no context', () async {
      when(mockService.getSomething()).thenAnswer((_) => Future.value(null));

      final other = await container.read(otherthingNotifierProvider.future);

      expect(other, null);
      verify(mockService.getSomething());
      verifyNoMoreInteractions(mockService);
    });

    test('should return service response when there is content', () async {
      when(mockService.getSomething()).thenAnswer((_) => Future.value(otherThing1));

      final other = await container.read(otherthingNotifierProvider.future);

      expect(other, otherThing1);
      verify(mockService.getSomething());
      verifyNoMoreInteractions(mockService);
    });

    test('should pass service exception when it occurs', () async {
      when(mockService.getSomething()).thenAnswer((_) => throw const ServiceException('Oh no!'));

      expect(
        () async => await container.read(otherthingNotifierProvider.future),
        throwsA(isA<ServiceException>()),
      );

      verify(mockService.getSomething());
      verifyNoMoreInteractions(mockService);
    });
  });
}
