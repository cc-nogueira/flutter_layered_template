import 'package:flutter_layered_template_isar_persistence/src/domain/entity/contact.dart';
import 'package:flutter_layered_template_isar_persistence/src/domain/exception/entity_not_found_exception.dart';
import 'package:flutter_layered_template_isar_persistence/src/domain/exception/validation_exception.dart';
import 'package:flutter_layered_template_isar_persistence/src/domain/repository/contacts_repository.dart';
import 'package:flutter_layered_template_isar_persistence/src/domain/usecase/contacts_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'contacts_usecase_test.mocks.dart';

extension ContactsRepositoryAsMockExtension on ContactsRepository {
  MockContactsRepository asMock() => this as MockContactsRepository;
}

@GenerateMocks([ContactsRepository])
void main() {
  late ProviderContainer container;

  late ContactsRepository mockRepository;

  const inexistentId = 99;
  const newContact1 = Contact(name: 'Robert Martin', uuid: 'a1b2c3d4');
  const newContact2 = Contact(name: 'Martin Fowler', uuid: 'z9x8c7v6');
  const newContactWithSpaces = Contact(name: ' Trygve Reenskaug  ', uuid: 'z1m2c3n4');
  const newContactWithoutSpaces = Contact(name: 'Trygve Reenskaug', uuid: 'z1m2c3n4');

  final contact1 = newContact1.copyWith(id: 1);
  final contact2 = newContact2.copyWith(id: 2);
  final contactWithoutSpaces = newContactWithoutSpaces.copyWith(id: 3);

  setUp(() {
    mockRepository = MockContactsRepository();

    container = ProviderContainer(overrides: [
      contactsUseCaseProvider
          .overrideWith((ref) => ContactsUseCase(ref: ref, uuid: ref.read(uuidProvider), repository: mockRepository)),
    ]);
  });

  group('contactProvider', () {
    test('should return a contact by id when it does exist in storage', () {
      when(mockRepository.asMock().getAll()).thenReturn([contact1, contact2]);

      final contact = container.read(contactProvider(contact1.id!));

      expect(contact, contact1);
      verify(mockRepository.getAll());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass repository\'s EntityNotFoundException when id is not found in storage', () {
      when(mockRepository.asMock().getAll()).thenReturn([contact1, contact2]);

      expect(
        () => container.read(contactProvider(inexistentId)),
        throwsA(isA<EntityNotFoundException>()),
      );
      verify(mockRepository.getAll());
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('contactsProvider', () {
    test('should return an empty list when the repository is empty', () {
      when(mockRepository.getAll()).thenReturn([]);

      final contacts = container.read(contactsNotifierProvider);

      expect(contacts, isEmpty);
      verify(mockRepository.getAll());
      verifyNoMoreInteractions(mockRepository);
    });

    test('should delgate order to the repository, not altering values or order', () {
      when(mockRepository.getAll()).thenReturn([contact2, contact1]);

      final contacts = container.read(contactsNotifierProvider);
      expect(contacts, [contact2, contact1]);

      verify(mockRepository.getAll());
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('save', () {
    test('should add a new contact to storage delegating id generation to the repository', () {
      when(mockRepository.asMock().save(any)).thenReturn(contact1);

      final savedContact = container.read(contactsUseCaseProvider).save(newContact1);
      expect(savedContact, contact1);

      verify(mockRepository.save(newContact1));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should update a contact in storage when id is not zero', () {
      when(mockRepository.asMock().save(any)).thenReturn(contact1);

      final savedContact = container.read(contactsUseCaseProvider).save(contact1);
      expect(savedContact, contact1);

      verify(mockRepository.save(contact1));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should trim contact\'s content before saving', () {
      when(mockRepository.asMock().save(any)).thenReturn(contactWithoutSpaces);

      final savedContact = container.read(contactsUseCaseProvider).save(newContactWithSpaces);
      expect(savedContact, contactWithoutSpaces);

      verify(mockRepository.save(newContactWithoutSpaces));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should throw a ValidationException before saving if contact\'s name is empty after trim', () {
      const emptyNameContact = Contact(name: '   ');

      expect(
        () => container.read(contactsUseCaseProvider).save(emptyNameContact),
        throwsA(isA<ValidationException>()),
      );

      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass repository\'s EntityNotFoundException when trying to updated a contact not found in storage', () {
      when(mockRepository.asMock().save(any)).thenThrow(const EntityNotFoundException());

      expect(
        () => container.read(contactsUseCaseProvider).save(contact1),
        throwsA(isA<EntityNotFoundException>()),
      );

      verify(mockRepository.save(contact1));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('remove', () {
    test('should remove a contact from repository when its id exists', () {
      when(mockRepository.asMock().remove(any)).thenAnswer((_) {});

      container.read(contactsUseCaseProvider).remove(contact1.id!);

      verify(mockRepository.remove(contact1.id!));
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass repository\'s EntityNotFoundException when id is not found in repository', () {
      when(mockRepository.asMock().remove(any)).thenThrow(const EntityNotFoundException());

      expect(
        () => container.read(contactsUseCaseProvider).remove(contact1.id!),
        throwsA(isA<EntityNotFoundException>()),
      );

      verify(mockRepository.remove(contact1.id!));
      verifyNoMoreInteractions(mockRepository);
    });
  });

  group('validate', () {
    test('should validate OK when contact has  name', () {
      final contactsUseCase = container.read(contactsUseCaseProvider);
      contactsUseCase.validate(contact1);
      contactsUseCase.validate(contact2);
      contactsUseCase.validate(newContact2);

      verifyNoMoreInteractions(mockRepository);
    });

    test('should validate OK when contact has spaces in name', () {
      final contactsUseCase = container.read(contactsUseCaseProvider);
      contactsUseCase.validate(newContactWithSpaces);

      verifyNoMoreInteractions(mockRepository);
    });

    test('should throw ValidationException when name is empty', () {
      final contactsUseCase = container.read(contactsUseCaseProvider);
      const emptyNameContact = Contact(name: '   ');
      expect(
        () => contactsUseCase.validate(emptyNameContact),
        throwsA(isA<ValidationException>()),
      );

      verifyNoMoreInteractions(mockRepository);
    });
  });
}
