import 'package:flutter_layered_template/src/domain/entity/thing.dart';
import 'package:flutter_layered_template/src/domain/exception/entity_not_found_exception.dart';
import 'package:flutter_layered_template/src/domain/exception/validation_exception.dart';
import 'package:flutter_layered_template/src/domain/layer/domain_layer.dart';
import 'package:flutter_layered_template/src/domain/repository/things_repository.dart';
import 'package:flutter_layered_template/src/domain/usecase/things_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'things_use_case_test.mocks.dart';

extension ThingsRepositoryAsMockExtension on ThingsRepository {
  MockThingsRepository asMock() => this as MockThingsRepository;
}

@GenerateMocks([ThingsRepository])
void main() {
  late ProviderContainer container;

  late ThingsRepository mockRepository;

  const newThing1 = Thing(name: 'apple');
  const newThing2 = Thing(name: 'sailing');
  const newThingWithSpaces = Thing(name: '  Motor racing  ');
  const newThingWithoutSpaces = Thing(name: 'Motor racing');

  final thing1 = newThing1.copyWith(id: 1);
  final thing2 = newThing2.copyWith(id: 2);
  final thingWithoutSpaces = newThingWithoutSpaces.copyWith(id: 3);

  setUp(() {
    mockRepository = MockThingsRepository();

    container = ProviderContainer(overrides: [
      domainLayerProvider.overrideWithValue(DomainLayer()..thingsRepositoryProvider = Provider((_) => mockRepository)),
    ]);
  });

  group('things', () {
    test('should return an empty list when the repository is empty', () {
      when(mockRepository.getAll()).thenReturn([]);

      final contacts = container.read(thingsNotifierProvider);

      expect(contacts, isEmpty);
      verify(mockRepository.getAll());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should delegate order to the repository, not altering values or order', () {
      when(mockRepository.getAll()).thenReturn([thing2, thing1]);

      final contacts = container.read(thingsNotifierProvider);
      expect(contacts, [thing2, thing1]);

      verify(mockRepository.getAll());
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('save', () {
    test('should add a new contact to storage delegating id generation to the repository', () {
      when(mockRepository.asMock().save(any)).thenReturn(thing1);

      final savedContact = container.read(thingsUseCaseProvider).save(newThing1);
      expect(savedContact, thing1);

      verify(mockRepository.save(newThing1));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should update a contact in storage when id is not zero', () {
      when(mockRepository.asMock().save(any)).thenReturn(thing1);

      final savedContact = container.read(thingsUseCaseProvider).save(thing1);
      expect(savedContact, thing1);

      verify(mockRepository.save(thing1));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should trim contact\'s content before saving', () {
      when(mockRepository.asMock().save(any)).thenReturn(thingWithoutSpaces);

      final savedContact = container.read(thingsUseCaseProvider).save(newThingWithSpaces);
      expect(savedContact, thingWithoutSpaces);

      verify(mockRepository.save(newThingWithoutSpaces));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should throw a ValidationException before saving if contact\'s name is empty after trim', () {
      const emptyNameThing = Thing(name: '   ');

      expect(
        () => container.read(thingsUseCaseProvider).save(emptyNameThing),
        throwsA(isA<ValidationException>()),
      );

      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('remove', () {
    test('should remove a contact from repository when its id exists', () {
      when(mockRepository.asMock().remove(any)).thenAnswer((_) {});

      container.read(thingsUseCaseProvider).remove(thing1.id!);

      verify(mockRepository.remove(thing1.id!));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass repository\'s EntityNotFoundException when id is not found in repository', () {
      when(mockRepository.asMock().remove(any)).thenThrow(const EntityNotFoundException());

      expect(
        () => container.read(thingsUseCaseProvider).remove(thing1.id!),
        throwsA(isA<EntityNotFoundException>()),
      );

      verify(mockRepository.remove(thing1.id!));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('validate', () {
    test('should validate OK when contact has  name', () {
      final thingsUseCase = container.read(thingsUseCaseProvider);
      thingsUseCase.validate(thing1);
      thingsUseCase.validate(thing2);
      thingsUseCase.validate(newThing1);

      verifyNoMoreInteractions(mockRepository);
    });

    test('should validate OK when contact has spaces in name', () {
      final thingsUseCase = container.read(thingsUseCaseProvider);
      thingsUseCase.validate(newThingWithSpaces);

      verifyNoMoreInteractions(mockRepository);
    });

    test('should throw ValidationException when name is empty', () {
      const emptyNameThing = Thing(name: '   ');
      final thingsUseCase = container.read(thingsUseCaseProvider);

      expect(
        () => thingsUseCase.validate(emptyNameThing),
        throwsA(isA<ValidationException>()),
      );

      verifyNoMoreInteractions(mockRepository);
    });
  });
}
