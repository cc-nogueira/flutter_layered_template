import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain_layer.dart';
import '../model/message_model.dart';

/// Map [MessageModel] objects to [Message] entities.
///
/// This is a one-way only conversion. Only from Model to Entity.
class MessageMapper {
  /// Constructor reveives a Riverpod Reader.
  ///
  /// Its child mapper user this Ref to access a domain use case.
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
    return ref.read(contactsUseCaseProvider).getByUuid(
          model.uuid,
          orElse: () => Contact(uuid: model.uuid, name: model.name),
        );
  }
}
