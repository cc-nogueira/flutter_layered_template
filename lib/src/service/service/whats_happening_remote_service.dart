import 'dart:convert';
import 'dart:math';

import 'package:faker/faker.dart';

import '../../domain_layer.dart';
import '../mapper/whats_happening_mapper.dart';
import '../model/whats_happening_model.dart';

/// [WhatsHappeningService] implementation.
///
/// API receives and returns domain entities.
/// Converts internally to service models.
class SomeRemoteService implements WhatsHappeningService {
  /// Constructor.
  SomeRemoteService();

  /// Internal mapper for Entity/Model conversions.
  final OtherthingMapper _mapper = const OtherthingMapper();

  /// Random generator for fake response construction.
  final random = Random();

  /// Fetch something from the remote server.
  ///
  /// Resolves to null if the remote service responds with no content.
  /// May throw a [ServiceException].
  @override
  Future<WhatsHappening?> getWhatsHappening() async {
    final json = await _invokeService();
    final model = WhatsHappeningModel.fromJson(json);
    if (model.text.isEmpty) {
      return null;
    }
    return _mapper.mapEntity(model);
  }

  /// Invoke the service and convert the response to a JSON map.
  ///
  /// Randomly generate three types of answer:
  ///   - [ServiceException] (chance of 1 in 6).
  ///   - Empty content (chance of 2 in 6).
  ///   - Content with fake conference name (chance of 3 in 6).
  ///
  /// May throw a [ServiceException].
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
