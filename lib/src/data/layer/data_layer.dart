import '../../core/layer/app_layer.dart';
import '../../domain/repository/example/contacts_repository.dart';
import '../repository/example/in_memory_contacts_notifier_repository.dart';

/// DataLayer has the responsibility to provide repository implementaions.
///
/// Provides all repository implementations, also accessible through providers.
class DataLayer extends AppLayer {
  const DataLayer();

  /// Uses a simple InMemory ContactsRepository implementation.
  ContactsRepository get contactsRepository => InMemoryContactsNotifierRepository();
}
