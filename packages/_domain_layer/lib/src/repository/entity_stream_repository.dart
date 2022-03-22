import '../entity/entity.dart';
import 'entity_repository.dart';

/// Generic interface of a StateNotifier for List<Enttity>.
///
/// State update notifications are triggered by StateNotifier superclass.
/// An instance of this class may be watched by StateNotifierProvider.
abstract class EntityStreamRepository<T extends Entity>
    implements EntityRepository<T> {
  /// Return a stream for a single entity.
  ///
  /// It is a stream of the current state of a specific entity selected by id.
  Stream<T> watch(int id);

  /// Return a stream of lists for all entities in storage.
  ///
  /// It is a stream of the current storage state.
  Stream<List<T>> watchAll();
}
