import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../entity/thing.dart';
import '../exception/entity_not_found_exception.dart';
import '../exception/validation_exception.dart';
import '../layer/domain_layer.dart';
import '../repository/things_repository.dart';

part 'notifier/things_notifier.dart';
part 'things_use_case.g.dart';

/// [ThingsUseCase] singleton provider.
///
/// This provider is an auto dispose provider (keepAlive: false).
/// The state is kept in a [ThingsNotifier] with a persistent provider.
final thingsUseCaseProvider = Provider.autoDispose((ref) => ThingsUseCase(
      ref: ref,
      repository: ref.read(ref.read(domainLayerProvider).thingsRepositoryProvider),
    ));

/// Use case with [Thing]s business rules.
///
/// It provides an API to access and update [Thing] entities.
/// This a stateless class that may be instantiated on demand by the provider.
///
/// The state is kept in a [ThingsNotifier] with a persistent provider.
///
/// This is an use case for a synchronous API.
/// If the [ThingsRepository] had an async API this use case would need to be adapted to
/// a matching async API.
class ThingsUseCase {
  /// Const constructor.
  const ThingsUseCase({required this.ref, required this.repository});

  /// Riverpod ref to access [thingsNotifierProvider].
  final Ref ref;

  /// Provisioned [ThingsRepository] implementation.
  final ThingsRepository repository;

  /// Save a [Thing] in the repository and return the saved entity.
  ///
  /// Call [validate] before saving.
  /// Adjust the contents (trim name) before saving.
  ///
  /// If thing's id is null the repository will be responsible to generate
  /// a unique id, persist and return this new entity with its generated id.
  ///
  /// If thing's id is not null the repository should update/insert the entity with the given id.
  ///
  /// After saving [thingsNotifierProvider] is invalidated to be ready to get fresh updated data.
  Thing save(Thing value) {
    validate(value);
    final adjusted = _adjust(value);
    final saved = repository.save(adjusted);
    ref.invalidate(thingsNotifierProvider);
    return saved;
  }

  /// Removes an entity by id from the repository.
  ///
  /// Expects that the repository throws an [EntityNotFoundException] if id is not found.
  ///
  /// After removing [thingsNotifierProvider] is invalidated to be ready to get fresh updated data.
  void remove(int id) {
    repository.remove(id);
    ref.invalidate(thingsNotifierProvider);
  }

  /// Validate a thing's content.
  ///
  /// Throws a validation exception if name is empty.
  void validate(Thing value) {
    if (value.name.trim().isEmpty) {
      throw const ValidationException('Thing\'s name should not be empty');
    }
  }

  /// Adjust things's contents.
  ///
  /// Trim name if necessary.
  Thing _adjust(Thing value) {
    var adjusted = value;
    final adjustedName = value.name.trim();
    if (value.name != adjustedName) {
      adjusted = adjusted.copyWith(name: adjustedName);
    }
    return adjusted;
  }

  /// Protected - Load all things from repository.
  ///
  /// It is expected that the repository returns the list sorted by name.
  ///
  /// Used by [ThingsNotifier.build] method.
  List<Thing> _loadThings() {
    return repository.getAll();
  }
}
