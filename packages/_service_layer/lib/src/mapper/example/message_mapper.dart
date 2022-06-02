import 'package:_domain_layer/domain_layer.dart';

import 'package:riverpod/riverpod.dart';

import '../../model/example/message_model.dart';

/// MessageMapper converts [MessageModel] to [Message] entity.
///
/// This is a one-way only conversion. Only from Model to Entity.
class MessageMapper {
  /// Constructor reveives a Riverpod Reader.
  MessageMapper(Reader read) : personMapper = PersonMapper(read);

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
  const PersonMapper(this.read);

  /// Internal - Riverpod Reader.
  final Reader read;

  /// Maps a Person service Model to a [Contact] domain Entity.
  ///
  /// Tries to match the person to an existing contact by uuid.
  /// Maps a new entity if no match is found.
  Contact mapEntity(PersonModel model, {Contact? possibleMatch}) {
    if (model.uuid == possibleMatch?.uuid) {
      return possibleMatch!;
    }
    return read(contactsUsecaseProvider).getByUuid(
      model.uuid,
      orElse: () => Contact(uuid: model.uuid, name: model.name),
    );
  }
}
