import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entity/contact.dart';
import '../../../domain/entity/message.dart';
import '../../../domain/usecase/contacts_usecase.dart';
import '../../model/example/message_model.dart';

/// MessageMapper converts [MessageModel] to [Message] entity.
///
/// This is a one-way only conversion. Only from Model to Entity.
class MessageMapper {
  /// Constructor reveives a Riverpod Reader.
  MessageMapper(Ref ref) : personMapper = PersonMapper(ref);

  /// Person helper mapper
  final PersonMapper personMapper;

  /// Maps a Message service Model to a [Message] domain Entity.
  Message mapEntity(MessageModel model, {Contact? receiver}) => Message(
        sender: personMapper.mapEntity(model.sender),
        receiver: personMapper.mapEntity(
          model.receiver,
          possibleMatch: receiver,
        ),
        title: model.message.title,
        text: model.message.text,
      );
}

/// PersonMapper converts [PersonModel] to [Contact] entity.
///
/// This is a one-way only conversion. Only from Model to Entity.
class PersonMapper {
  /// Constructor reveives a Riverpod Reader.
  const PersonMapper(this.ref);

  /// Internal - Riverpod Reader.
  final Ref ref;

  /// Maps a Person service Model to a [Contact] domain Entity.
  ///
  /// Tries to match the person to an existing contact by uuid.
  /// Maps a new entity if no match is found.
  Contact mapEntity(PersonModel model, {Contact? possibleMatch}) {
    if (model.uuid == possibleMatch?.uuid) {
      return possibleMatch!;
    }
    return ref.read(contactsUsecaseProvider).getByUuid(
          model.uuid,
          orElse: () => Contact(uuid: model.uuid, name: model.name),
        );
  }
}
