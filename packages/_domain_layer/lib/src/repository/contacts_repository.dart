import '../entity/contact.dart';
import 'entity_notifier_repository.dart';

/// Contacts Repository interface.
///
/// This repository defines a StateNotifier type of API (in contrast to a stream
/// API).
abstract class ContactsRepository extends EntityNotifierRepository<Contact> {
  /// Get a Contact from storage by uuid.
  ///
  /// Throws an [EntityNotFoundException] if no contact has this uuid.
  Contact getByUuid(String uuid);
}
