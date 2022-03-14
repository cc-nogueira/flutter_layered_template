import 'package:_domain_layer/domain_layer.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'contacts_usecase_test.mocks.dart';

extension ContactsRepositoryAsMockExtension on ContactsRepository {
  MockContactsRepository asMock() => this as MockContactsRepository;
}

@GenerateMocks([ContactsRepository, MessageService])
void main() {
  late ContactsRepository mockRepository;
  late MessageService mockService;
  late ContactsUsecase usecase;

  const newContact1 = Contact(name: 'Robert Martin', uuid: 'a1b2c3d4');
  const newContact2 = Contact(name: 'Martin Fowler', uuid: 'z9x8c7v6');
  const newContactWithSpaces =
      Contact(name: ' Trygve Reenskaug  ', uuid: 'z1m2c3n4');
  const newContactWithoutSpaces =
      Contact(name: 'Trygve Reenskaug', uuid: 'z1m2c3n4');

  final contact1 = newContact1.copyWith(id: 1);
  final contact2 = newContact2.copyWith(id: 2);
  final contactWithoutSpaces = newContactWithoutSpaces.copyWith(id: 3);

  setUp(() {
    mockRepository = MockContactsRepository();
    mockService = MockMessageService();
    usecase = ContactsUsecase(
      repository: mockRepository,
      messageService: mockService,
    );
  });

  group('get', () {
    test('should return a contact by id when it does exist in storage', () {
      when(mockRepository.asMock().get(any)).thenReturn(contact1);

      final contact = usecase.get(contact1.id);

      expect(contact, contact1);
      verify(mockRepository.get(contact1.id));
      verifyNoMoreInteractions(mockRepository);
    });

    test(
        'should pass repository\'s EntityNotFoundException when id is not found in storage',
        () {
      when(mockRepository.asMock().get(any))
          .thenThrow(const EntityNotFoundException());

      expect(
        () => usecase.get(contact1.id),
        throwsA(isA<EntityNotFoundException>()),
      );
      verify(mockRepository.get(contact1.id));
      verifyNoMoreInteractions(mockRepository);
      verifyNoMoreInteractions(mockService);
    });
  });

  group('getAll', () {
    test('should return an empty list when the repository is empty', () {
      when(mockRepository.getAll()).thenReturn([]);

      final contacts = usecase.getAll();

      expect(contacts, isEmpty);
      verify(mockRepository.getAll());
      verifyNoMoreInteractions(mockRepository);
      verifyNoMoreInteractions(mockService);
    });

    test(
        'should return an ordered list of contacts by name when the repository is not empty',
        () {
      when(mockRepository.getAll()).thenReturn([contact1, contact2]);

      final contacts = usecase.getAll();

      expect(contacts, [contact2, contact1]);
      verify(mockRepository.getAll());
      verifyNoMoreInteractions(mockRepository);
      verifyNoMoreInteractions(mockService);
    });
  });

  group('save', () {
    test(
        'should add a new contact to storage delegating id generation to the repository',
        () {
      when(mockRepository.asMock().save(any)).thenReturn(contact1);

      final savedContact = usecase.save(newContact1);

      expect(savedContact, contact1);
      verify(mockRepository.save(newContact1));
      verifyNoMoreInteractions(mockRepository);
      verifyNoMoreInteractions(mockService);
    });

    test('should update a contact in storage when id is not zero', () {
      when(mockRepository.asMock().save(any)).thenReturn(contact1);

      final savedContact = usecase.save(contact1);

      expect(savedContact, contact1);
      verify(mockRepository.save(contact1));
      verifyNoMoreInteractions(mockRepository);
      verifyNoMoreInteractions(mockService);
    });

    test('should trim contact\'s content before saving', () {
      when(mockRepository.asMock().save(any)).thenReturn(contactWithoutSpaces);

      final savedContact = usecase.save(newContactWithSpaces);

      expect(savedContact, contactWithoutSpaces);
      verify(mockRepository.save(newContactWithoutSpaces));
      verifyNoMoreInteractions(mockRepository);
      verifyNoMoreInteractions(mockService);
    });

    test(
        'should throw a ValidationException before saving if contact\'s name is empty after trim',
        () {
      const emptyNameContact = Contact(name: '   ');

      expect(
        () => usecase.save(emptyNameContact),
        throwsA(isA<ValidationException>()),
      );
      verifyNoMoreInteractions(mockRepository);
      verifyNoMoreInteractions(mockService);
    });

    test(
        'should pass repository\'s EntityNotFoundException when trying to updated a contact not found in storage',
        () {
      when(mockRepository.asMock().save(any))
          .thenThrow(const EntityNotFoundException());

      expect(
        () => usecase.save(contact1),
        throwsA(isA<EntityNotFoundException>()),
      );
      verify(mockRepository.save(contact1));
      verifyNoMoreInteractions(mockRepository);
      verifyNoMoreInteractions(mockService);
    });
  });

  group('remove', () {
    test('should remove a contact from repository when its id exists', () {
      when(mockRepository.asMock().remove(any)).thenAnswer((_) {});

      usecase.remove(contact1.id);

      verify(mockRepository.remove(contact1.id));
      verifyNoMoreInteractions(mockRepository);
      verifyNoMoreInteractions(mockService);
    });

    test(
        'should pass repository\'s EntityNotFoundException when id is not found in repository',
        () {
      when(mockRepository.asMock().remove(any))
          .thenThrow(const EntityNotFoundException());

      expect(
        () => usecase.remove(contact1.id),
        throwsA(isA<EntityNotFoundException>()),
      );

      verify(mockRepository.remove(contact1.id));
      verifyNoMoreInteractions(mockRepository);
      verifyNoMoreInteractions(mockService);
    });
  });

  group('validate', () {
    test('should validate OK when contact has  name', () {
      usecase.validate(contact1);
      usecase.validate(contact2);
      usecase.validate(newContact2);

      verifyNoMoreInteractions(mockRepository);
      verifyNoMoreInteractions(mockService);
    });

    test('should validate OK when contact has spaces in name', () {
      usecase.validate(newContactWithSpaces);

      verifyNoMoreInteractions(mockRepository);
      verifyNoMoreInteractions(mockService);
    });

    test('should throw ValidationException when name is empty', () {
      const emptyNameContact = Contact(name: '   ');
      expect(
        () => usecase.validate(emptyNameContact),
        throwsA(isA<ValidationException>()),
      );
      verifyNoMoreInteractions(mockRepository);
      verifyNoMoreInteractions(mockService);
    });
  });
}
