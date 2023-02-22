import 'package:flutter_layered_template_contacts_example/src/domain/entity/contact.dart';
import 'package:flutter_layered_template_contacts_example/src/domain/exception/entity_not_found_exception.dart';
import 'package:flutter_layered_template_contacts_example/src/domain/exception/validation_exception.dart';
import 'package:flutter_layered_template_contacts_example/src/domain/layer/domain_layer.dart';
import 'package:flutter_layered_template_contacts_example/src/domain/repository/contacts_async_repository.dart';
import 'package:flutter_layered_template_contacts_example/src/domain/usecase/contacts_async_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'contacts_async_use_case_test.mocks.dart';

extension ContactsRepositoryAsMockExtension on ContactsAsyncRepository {
  MockContactsAsyncRepository asMock() => this as MockContactsAsyncRepository;
}

@GenerateMocks([ContactsAsyncRepository])
void main() {
  late ProviderContainer container;

  late ContactsAsyncRepository mockRepository;

  const inexistentId = 99;
  const newContact1 = Contact(name: 'John Joe', uuid: 'a1b2c3d4');
  const newContact2 = Contact(name: 'Peter Pan', uuid: 'z9x8c7v6');
  const newContactWithSpaces = Contact(name: ' Marc Merc  ', uuid: 'z1m2c3n4');
  const newContactWithoutSpaces = Contact(name: 'Marc Merc', uuid: 'z1m2c3n4');

  final contact1 = newContact1.copyWith(id: personalities.length);
  final contact2 = newContact2.copyWith(id: personalities.length + 1);
  final contactWithoutSpaces = newContactWithoutSpaces.copyWith(id: personalities.length + 2);

  setUp(() {
    mockRepository = MockContactsAsyncRepository();

    container = ProviderContainer(overrides: [
      domainLayerProvider
          .overrideWithValue(DomainLayer()..contactsAsyncRepositoryProvider = Provider((_) => mockRepository)),
    ]);
  });

  group('contactState', () {
    test('should return a contact by id when it does exist in storage', () async {
      when(mockRepository.asMock().getAll()).thenAnswer((_) => Future.value([contact1, contact2]));

      final contact = await container.read(contactAsyncProvider(contact1.id!).future);

      expect(contact, contact1);
      verify(mockRepository.getAll());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass repository\'s EntityNotFoundException when id is not found in storage', () async {
      when(mockRepository.asMock().getAll()).thenAnswer((_) => Future.value([contact1, contact2]));

      expect(
        () async => await container.read(contactAsyncProvider(inexistentId).future),
        throwsA(isA<EntityNotFoundException>()),
      );
      verify(mockRepository.getAll());
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('contactsState', () {
    test('should return an empty list when the repository is empty', () async {
      when(mockRepository.getAll()).thenAnswer((_) => Future.value([]));

      final contacts = await container.read(contactsAsyncNotifierProvider.future);

      expect(contacts, isEmpty);
      verify(mockRepository.getAll());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should delegate order to the repository, not altering values or order', () async {
      when(mockRepository.getAll()).thenAnswer((_) => Future.value([contact2, contact1]));

      final contacts = await container.read(contactsAsyncNotifierProvider.future);
      expect(contacts, [contact2, contact1]);

      verify(mockRepository.getAll());
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('save', () {
    test('should add a new contact to storage delegating id generation to the repository', () async {
      when(mockRepository.asMock().save(any)).thenAnswer((_) => Future.value(contact1));
      when(mockRepository.getAll()).thenAnswer((_) => Future.value([contact1]));

      final savedContact = await container.read(contactsAsyncUseCaseProvider).save(newContact1);
      expect(savedContact, contact1);

      verify(mockRepository.save(newContact1));
      verify(mockRepository.getAll());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should update a contact in storage when id is not zero', () async {
      when(mockRepository.asMock().save(any)).thenAnswer((_) => Future.value(contact1));
      when(mockRepository.getAll()).thenAnswer((_) => Future.value([contact1]));

      final savedContact = await container.read(contactsAsyncUseCaseProvider).save(contact1);
      expect(savedContact, contact1);

      verify(mockRepository.save(contact1));
      verify(mockRepository.getAll());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should trim contact\'s content before saving', () async {
      when(mockRepository.asMock().save(any)).thenAnswer((_) => Future.value(contactWithoutSpaces));
      when(mockRepository.getAll()).thenAnswer((_) => Future.value([contact1]));

      final savedContact = await container.read(contactsAsyncUseCaseProvider).save(newContactWithSpaces);
      expect(savedContact, contactWithoutSpaces);

      verify(mockRepository.save(newContactWithoutSpaces));
      verify(mockRepository.getAll());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should throw a ValidationException before saving if contact\'s name is empty after trim', () async {
      const emptyNameContact = Contact(name: '   ');

      expect(
        () async => await container.read(contactsAsyncUseCaseProvider).save(emptyNameContact),
        throwsA(isA<ValidationException>()),
      );

      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('remove', () {
    test('should remove a contact from repository when its id exists', () async {
      when(mockRepository.asMock().remove(any)).thenAnswer((_) async {});
      when(mockRepository.getAll()).thenAnswer((_) => Future.value([]));

      await container.read(contactsAsyncUseCaseProvider).remove(contact1.id!);

      verify(mockRepository.remove(contact1.id!));
      verify(mockRepository.getAll());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass repository\'s EntityNotFoundException when id is not found in repository', () async {
      when(mockRepository.remove(contact1.id!)).thenAnswer((_) async => throw const EntityNotFoundException());

      expect(
        container.read(contactsAsyncUseCaseProvider).remove(contact1.id!),
        throwsA(isA<EntityNotFoundException>()),
      );

      verify(mockRepository.remove(contact1.id!));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('validate', () {
    test('should validate OK when contact has  name', () {
      final contactsUseCase = container.read(contactsAsyncUseCaseProvider);
      contactsUseCase.validate(contact1);
      contactsUseCase.validate(contact2);
      contactsUseCase.validate(newContact2);

      verifyNoMoreInteractions(mockRepository);
    });

    test('should validate OK when contact has spaces in name', () {
      final contactsUseCase = container.read(contactsAsyncUseCaseProvider);
      contactsUseCase.validate(newContactWithSpaces);

      verifyNoMoreInteractions(mockRepository);
    });

    test('should throw ValidationException when name is empty', () {
      final contactsUseCase = container.read(contactsAsyncUseCaseProvider);
      const emptyNameContact = Contact(name: '   ');
      expect(
        () => contactsUseCase.validate(emptyNameContact),
        throwsA(isA<ValidationException>()),
      );

      verifyNoMoreInteractions(mockRepository);
    });
  });
}
