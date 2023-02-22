import 'dart:convert';
import 'dart:math';

import 'package:faker/faker.dart';

import '../../domain_layer.dart';
import '../mapper/otherthing_mapper.dart';
import '../model/otherthing_model.dart';

/// [SomeService] implementation.
///
/// API receives and returns domain entities.
/// Converts internally to remote models.
class SomeRemoteService implements SomeService {
  ///  constructor.
  SomeRemoteService();

  final OtherthingMapper _mapper = const OtherthingMapper();

  final random = Random();

  /// Get something from the remote server.
  ///
  /// Resolves to null if the remote service responds with no content.
  /// May throw a ServiceException.
  @override
  Future<Otherthing?> getSomething() async {
    final json = await _invokeService();
    final model = OtherthingModel.fromJson(json);
    if (model.text.isEmpty) {
      return null;
    }
    return _mapper.mapEntity(model);
  }

  /// Invoke the service and convert the reponse to JSON.
  ///
  /// May throw a ServiceException.
  Future<Map<String, dynamic>> _invokeService() async {
    final rand = random.nextInt(6);
    if (rand == 0) {
      return Future.delayed(const Duration(seconds: 1)).then((_) => throw const ServiceException());
    }
    final content = rand < 3 ? '' : faker.conference.name();

    final response = await Future.delayed(const Duration(seconds: 1)).then(
      (_) => '{"text": "$content"}',
      onError: (error) => throw ServiceException(error.toString()),
    );
    return jsonDecode(response);
  }
}
