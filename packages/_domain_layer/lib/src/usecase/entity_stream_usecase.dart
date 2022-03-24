import 'dart:async';

import '../entity/entity.dart';
import '../repository/entity_stream_repository.dart';
import 'entity_usecase.dart';

/// Extendd EntityUsecase with Stream API.
///
/// This class must be injected with an [EntityStreamRepository].
/// See providers.
abstract class EntityStreamUsecase<T extends Entity> extends EntityUsecase<T> {
  const EntityStreamUsecase({required EntityStreamRepository<T> repository})
      : _repository = repository,
        super(repository: repository);

  final EntityStreamRepository<T> _repository;

  /// Returns a stream of a single entity, for its live state in storage.
  ///
  /// Expects that the repository throws a EntityNotFoundException when id is not
  /// found.
  Stream<T> watch(int id) => _repository.watch(id);

  /// Returns all entities stream from storage.
  ///
  /// Each fired list will be ordered using subclass reponsibility [_compare].
  Stream<List<T>> watchAll() => _repository.watchAll().transform(
        StreamTransformer.fromHandlers(
          handleData: (data, sink) {
            final dataList = data.toList(growable: false);
            sort(dataList);
            sink.add(List.unmodifiable(dataList));
          },
        ),
      );
}
