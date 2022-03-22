import 'package:_domain_layer/domain_layer.dart';
import 'package:_service_layer/_test.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:riverpod/riverpod.dart';

import 'remote_message_service_test.mocks.dart';

extension ContactsUsecaseAsMockExtension on ContactsUsecase {
  MockContactsUsecase asMock() => this as MockContactsUsecase;
}

@GenerateMocks([ContactsUsecase])
void main() {
  late ContactsUsecase mockUsecase;
  late RemoteMessageService service;

  setUp(() {
    mockUsecase = MockContactsUsecase();

    final container = ProviderContainer(
        overrides: [contactsUsecaseProvider.overrideWithValue(mockUsecase)]);
    addTearDown(container.dispose);

    service = RemoteMessageService(container.read);
  });

  const contact = Contact(id: 11, uuid: 'a1b2c3d4', name: 'Will Smith');

  group('getMessageFor', () {
    test('should return non message for a contact with fake data', () async {
      when(mockUsecase.asMock().getByUuid(any, orElse: anyNamed('orElse')))
          .thenAnswer((args) {
        final orElse =
            args.namedArguments[const Symbol('orElse')] as Contact Function();
        return orElse();
      });

      final message = await service.getMessageFor(contact);

      expect(message, isNotNull);
      expect(message!.receiver, contact);
      expect(message.sender.uuid, isNotEmpty);
      expect(message.sender.name, isNotEmpty);
      expect(message.title, isNotEmpty);
      expect(message.text, isNotEmpty);

      verify(mockUsecase.asMock().getByUuid(any, orElse: anyNamed('orElse')));
      verifyNoMoreInteractions(mockUsecase);
    });
  });
}
