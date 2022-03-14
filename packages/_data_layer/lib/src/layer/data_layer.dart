import 'package:_core_layer/core_layer.dart';
import 'package:_domain_layer/domain_layer.dart';

import '../repository/in_memory_contacts_notifier_repository.dart';

/// DataLayer has the responsibility to provide repository implementaions.
///
/// Provides all repository implementations, also accessible through providers.
class DataLayer extends AppLayer {
  const DataLayer();

  ContactsRepository get contactsRepository =>
      InMemoryContactsNotifierRepository();
}
