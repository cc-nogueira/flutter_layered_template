import 'dart:async';
import 'dart:convert';

import 'package:_domain_layer/domain_layer.dart';

import 'package:faker/faker.dart';
import 'package:riverpod/riverpod.dart';

import '../mapper/message_mapper.dart';
import '../model/message_model.dart';

/// Fake implementation class for a Remote Message service.
///
/// Simulates a remote invokation with delayed response and fake data.
///
/// Throws a ServiceException if cannot access the remote service.
class RemoteMessageService implements MessageService {
  RemoteMessageService(Reader reader) : mapper = MessageMapper(reader);

  final MessageMapper mapper;
  int invocationCount = 0;

  @override
  Future<Message?> getMessageFor(Contact receiver) async {
    if (receiver.uuid.isEmpty) {
      return null;
    }

    final response = await _invokeRemoteServer(receiver);
    final model = MessageModel.fromJson(response);

    if (model.statusCode == 200) {
      return mapper.mapEntity(model, receiver: receiver);
    }
    if (model.statusCode == 204) {
      return null;
    }
    throw const ServiceException();
  }

  Future<Map<String, dynamic>> _invokeRemoteServer(Contact receiver) async {
    ++invocationCount;
    try {
      final response = await _fakeHttpCall(receiver);
      final map = json.decode(response);
      return map as Map<String, dynamic>;
    } catch (_) {
      throw const ServiceException();
    }
  }

  Future<String> _fakeHttpCall(Contact receiver) async {
    const duration = Duration(seconds: 1);
    await Future.delayed(duration);
    if (invocationCount % 3 == 0) {
      return '{"statusCode": 204}';
    }
    if (invocationCount % 7 == 0) {
      throw TimeoutException(null, duration);
    }
    return '{"statusCode": 200, '
        '"sender": {"uuid": "${faker.guid.guid()}", "name": "${faker.person.name()}"}, '
        '"receiver": {"uuid": "${receiver.uuid}", "name": "${receiver.name}"}, '
        '"message": {"title": "${faker.sport.name()}", "text": "${faker.lorem.sentences(3).join('\\n')}"} '
        '}';
  }
}
