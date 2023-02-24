import 'package:flutter_layered_template_contacts_example/src/domain/entity/contact.dart';
import 'package:flutter_layered_template_contacts_example/src/domain/exception/entity_not_found_exception.dart';
import 'package:flutter_layered_template_contacts_example/src/domain/exception/validation_exception.dart';
import 'package:flutter_layered_template_contacts_example/src/domain/layer/domain_layer.dart';
import 'package:flutter_layered_template_contacts_example/src/domain/repository/contacts_sync_repository.dart';
import 'package:flutter_layered_template_contacts_example/src/domain/usecase/contacts_sync_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'contacts_sync_use_case_test.mocks.dart';

extension ContactsRepositoryAsMockExtension on ContactsSyncRepository {
  MockContactsSyncRepository asMock() => this as MockContactsSyncRepository;
}

@GenerateMocks([ContactsSyncRepository])
void main() {
  late ProviderContainer container;

  late ContactsSyncRepository mockRepository;

  const inexistentId = 99;
  const newContact1 = Contact(name: 'John Joe', uuid: 'a1b2c3d4');
  const newContact2 = Contact(name: 'Peter Pan', uuid: 'z9x8c7v6');
  const newContactWithSpaces = Contact(name: ' Marc Merc  ', uuid: 'z1m2c3n4');
  const newContactWithoutSpaces = Contact(name: 'Marc Merc', uuid: 'z1m2c3n4');

  final contact1 = newContact1.copyWith(id: personalities.length);
  final contact2 = newContact2.copyWith(id: personalities.length + 1);
  final contactWithoutSpaces = newContactWithoutSpaces.copyWith(id: personalities.length + 2);

  setUp(() {
    mockRepository = MockContactsSyncRepository();

    container = ProviderContainer(overrides: [
      domainLayerProvider
          .overrideWithValue(DomainLayer()..contactsSyncRepositoryProvider = Provider((_) => mockRepository)),
    ]);
  });

  group('contactState', () {
    test('should return a contact by id when it does exist in storage', () {
      when(mockRepository.asMock().getAll()).thenReturn([contact1, contact2]);

      final contact = container.read(contactSyncProvider(contact1.id!));

      expect(contact, contact1);
      verify(mockRepository.getAll());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass repository\'s EntityNotFoundException when id is not found in storage', () {
      when(mockRepository.asMock().getAll()).thenReturn([contact1, contact2]);

      expect(
        () => container.read(contactSyncProvider(inexistentId)),
        throwsA(isA<EntityNotFoundException>()),
      );
      verify(mockRepository.getAll());
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('contactsState', () {
    test('should return an empty list when the repository is empty', () {
      when(mockRepository.getAll()).thenReturn([]);

      final contacts = container.read(contactsSyncProvider);

      expect(contacts, isEmpty);
      verify(mockRepository.getAll());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should delegate order to the repository, not altering values or order', () {
      when(mockRepository.getAll()).thenReturn([contact2, contact1]);

      final contacts = container.read(contactsSyncProvider);
      expect(contacts, [contact2, contact1]);

      verify(mockRepository.getAll());
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('save', () {
    test('should add a new contact to storage delegating id generation to the repository', () {
      when(mockRepository.asMock().save(any)).thenReturn(contact1);

      final savedContact = container.read(contactsSyncUseCaseProvider).save(newContact1);
      expect(savedContact, contact1);

      verify(mockRepository.save(newContact1));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should update a contact in storage when id is not zero', () {
      when(mockRepository.asMock().save(any)).thenReturn(contact1);

      final savedContact = container.read(contactsSyncUseCaseProvider).save(contact1);
      expect(savedContact, contact1);

      verify(mockRepository.save(contact1));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should trim contact\'s content before saving', () {
      when(mockRepository.asMock().save(any)).thenReturn(contactWithoutSpaces);

      final savedContact = container.read(contactsSyncUseCaseProvider).save(newContactWithSpaces);
      expect(savedContact, contactWithoutSpaces);

      verify(mockRepository.save(newContactWithoutSpaces));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should throw a ValidationException before saving if contact\'s name is empty after trim', () {
      const emptyNameContact = Contact(name: '   ');

      expect(
        () => container.read(contactsSyncUseCaseProvider).save(emptyNameContact),
        throwsA(isA<ValidationException>()),
      );

      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('remove', () {
    test('should remove a contact from repository when its id exists', () {
      when(mockRepository.asMock().remove(any)).thenAnswer((_) {});

      container.read(contactsSyncUseCaseProvider).remove(contact1.id!);

      verify(mockRepository.remove(contact1.id!));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass repository\'s EntityNotFoundException when id is not found in repository', () {
      when(mockRepository.asMock().remove(any)).thenThrow(const EntityNotFoundException());

      expect(
        () => container.read(contactsSyncUseCaseProvider).remove(contact1.id!),
        throwsA(isA<EntityNotFoundException>()),
      );

      verify(mockRepository.remove(contact1.id!));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('validate', () {
    test('should validate OK when contact has  name', () {
      final contactsUseCase = container.read(contactsSyncUseCaseProvider);
      contactsUseCase.validate(contact1);
      contactsUseCase.validate(contact2);
      contactsUseCase.validate(newContact2);

      verifyNoMoreInteractions(mockRepository);
    });

    test('should validate OK when contact has spaces in name', () {
      final contactsUseCase = container.read(contactsSyncUseCaseProvider);
      contactsUseCase.validate(newContactWithSpaces);

      verifyNoMoreInteractions(mockRepository);
    });

    test('should throw ValidationException when name is empty', () {
      final contactsUseCase = container.read(contactsSyncUseCaseProvider);
      const emptyNameContact = Contact(name: '   ');
      expect(
        () => contactsUseCase.validate(emptyNameContact),
        throwsA(isA<ValidationException>()),
      );

      verifyNoMoreInteractions(mockRepository);
    });
  });
}
