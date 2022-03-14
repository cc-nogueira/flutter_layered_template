import 'package:_domain_layer/domain_layer.dart';

import 'in_memory_notifier_repository.dart';

/// InMemory contacts repository with StateNotifier API.
///
/// All its implementation in the generic [InMemoryNotifierRepository].
///
/// This repository uses the StateNotifier API (in contrast to a Stream API).
class InMemoryContactsNotifierRepository
    extends InMemoryNotifierRepository<Contact> implements ContactsRepository {
  InMemoryContactsNotifierRepository({List<Contact> initialData = const []})
      : super(initialData: initialData);

  /// Get a Contact from storage by uuid.
  ///
  /// Throws an [EntityNotFoundException] if no contact has this uuid.
  @override
  Contact getByUuid(String uuid) {
    return state.firstWhere(
      (element) => element.uuid == uuid,
      orElse: () => throw const EntityNotFoundException(),
    );
  }
}
