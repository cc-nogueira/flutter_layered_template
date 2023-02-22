import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../entity/contact.dart';
import '../exception/entity_not_found_exception.dart';
import '../exception/validation_exception.dart';
import '../layer/domain_layer.dart';
import '../repository/contacts_repository.dart';

part 'notifier/contacts_notifier.dart';

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
  ContactsUseCase({required this.ref, required this.uuid, required this.repository});

  /// Riverpod ref.
  final Ref ref;

  /// Provisioned [ContactsRepository] implementation.
  final ContactsRepository repository;

  /// [Uuid] generator.
  final Uuid uuid;

  /// A random generator
  final random = Random(DateTime.now().millisecond);

  /// Random create a contact that may be a personality.
  ///
  /// Returns a new Contact.
  /// Random choose between a Personality and a fake contact.
  /// The change of being a personality is one in three.
  ///
  /// If there are no missing personalities then always return a fake contact.
  Contact createContact() {
    final randPreferPersonality = random.nextInt(3) == 1;
    final contact = randPreferPersonality ? _missingPersonality() ?? _fakeContact() : _fakeContact();
    return save(contact);
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
  Contact save(Contact value) {
    validate(value);
    final adjusted = _adjust(value);
    final saved = repository.save(adjusted);
    ref.invalidate(contactsNotifierProvider);
    return saved;
  }

  /// Removes an entity by id from the repository.
  ///
  /// Expects that the repository throws an [EntityNotFoundException] if id is not found.
  void remove(int id) {
    repository.remove(id);
    ref.invalidate(contactsNotifierProvider);
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
  /// Trim contacts name and about if necessary.
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

  /// Finds a random personality missing in contacts provider.
  ///
  /// Return null if all personlities are already included in contacts.
  Contact? _missingPersonality() {
    final existing = ref.read(contactsNotifierProvider).where((each) => each.isPersonality).toList();
    final missingPersonalities = [
      for (final personality in personalities)
        if (existing.indexWhere((each) => each.uuid == personality.uuid) == -1) personality,
    ];
    if (missingPersonalities.isNotEmpty) {
      final rand = random.nextInt(missingPersonalities.length);
      return missingPersonalities[rand];
    }
    return null;
  }

  Contact _fakeContact() {
    return Contact(
      name: faker.person.name(),
      about: faker.lorem.sentences(4).join(),
    );
  }

  /// Private - Load all contacts from repository.
  ///
  /// It is expected it returns the list sorted by personality then by name.
  /// This action will also initialize the storage repository on its very first invocation.
  ///
  /// Used by [ContactsState.build] method.
  List<Contact> _loadContacts() {
    return repository.getAll();
  }
}
