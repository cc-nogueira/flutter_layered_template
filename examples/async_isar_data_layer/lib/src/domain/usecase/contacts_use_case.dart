import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../entity/contact.dart';
import '../exception/entity_not_found_exception.dart';
import '../exception/validation_exception.dart';
import '../layer/domain_layer.dart';
import '../repository/contacts_repository.dart';

part 'notifier/contacts_notifier.dart';
part 'notifier/contacts_guard_notifier.dart';

part 'contacts_use_case.g.dart';

final uuidProvider = Provider((ref) => const Uuid());

final contactsUseCaseProvider = Provider((ref) => ContactsUseCase(
      ref: ref,
      repository: ref.read(ref.read(domainLayerProvider).contactsRepositoryProvider),
      uuid: ref.read(uuidProvider),
    ));

/// Use case with Contacts business rules.
///
/// It provides an API to access and update [Contact] entities.
class ContactsUseCase {
  /// Const constructor.
  const ContactsUseCase({required this.ref, required this.uuid, required this.repository});

  /// Riverpod ref.
  final Ref ref;

  /// Provisioned [ContactsRepository] implementation.
  final ContactsRepository repository;

  /// [Uuid] generator.
  final Uuid uuid;

  /// Get a Contact from repository by uuid.
  ///
  /// Expects repository to throw an [EntityNotFoundException] if no contact has this uuid.
  Future<Contact> getByUuid(String uuid, {required Future<Contact> Function() orElse}) {
    try {
      return repository.getByUuid(uuid);
    } on Exception {
      return orElse();
    }
  }

  /// Save a [Contact] in the repository and return the saved entity.
  ///
  /// Call [validate] before saving.
  /// Adjust the contents (trim contacts name) before saving.
  ///
  /// If contact's id is null the repository will be responsible to generate
  /// a unique id, persist and return this new entity with its generated id.
  ///
  /// If contact's id is not null the repository should update the entity with the given id.
  Future<Contact> save(Contact value) async {
    validate(value);
    final adjusted = _adjust(value);
    return _processingGuard(() => repository.save(adjusted));
  }

  /// Removes an entity by id from the repository.
  ///
  /// Expects that the repository throws an [EntityNotFoundException] if id is not found.
  Future<void> remove(int id) async {
    _processingGuard(() => repository.remove(id));
  }

  /// Validate contact's content.
  ///
  /// Throws a validation exception if contact's name is empty.
  /// Throws a validation exception if the contact has a personality id and has changed it's
  /// name or about info. Personalities are not editable, but for their avatar color.
  void validate(Contact contact) {
    if (contact.name.trim().isEmpty) {
      throw const ValidationException('Contact\'s name should not be empty');
    }
    if (contact.id != null) {
      final personIndex = personalities.indexWhere((each) => each.id == contact.id);
      if (personIndex != -1) {
        final person = personalities[personIndex];
        if (contact.name != person.name || contact.about != person.about || contact.uuid != person.uuid) {
          throw const ValidationException('A personality uuid, name and about info cannot be altered');
        }
      }
    }
  }

  /// Adjust contact's contents.
  ///
  /// Generates contact's uuid when it is empty.
  /// Trim contacts name if necessary.
  Contact _adjust(Contact contact) {
    var adjusted = contact.uuid.isEmpty ? contact.copyWith(uuid: uuid.v4()) : contact;

    final adjustedName = contact.name.trim();
    if (contact.name != adjustedName) {
      adjusted = adjusted.copyWith(name: adjustedName);
    }

    final adjustedAbout = contact.about.trim();
    if (contact.about != adjustedAbout) {
      adjusted = adjusted.copyWith(about: adjustedAbout);
    }

    return adjusted;
  }

  Future<Contact?> missingPersonality() async {
    final contacts = await ref.read(contactsNotifierProvider.future);
    final found = personalities.indexWhere((personality) {
      return contacts.indexWhere((contact) => contact.id == personality.id) == -1;
    });
    return found == -1 ? null : personalities[found];
  }

  /// Private - Load all contacts from repository.
  ///
  /// It is expected it returns the list sorted by name.
  /// This action will also initialize the storage repository on its very first invocation.
  ///
  /// Used by [ContactsState.build] method.
  Future<List<Contact>> _loadContacts() {
    return repository.getAll();
  }

  Future<T> _processingGuard<T>(Future<T> Function() callback) async {
    /// First signal processing start
    ref.read(contactsGuardNotifierProvider.notifier)._startProcessing();
    try {
      /// Execute the guarded callback
      final answer = await callback();

      /// Refresh provider to prefetch state
      // ignore: unused_result
      await ref.refresh(contactsNotifierProvider.future);

      /// Answer callback
      return answer;
    } finally {
      /// Last signal processing finished.
      ref.read(contactsGuardNotifierProvider.notifier)._finishedProcessing();
    }
  }
}
