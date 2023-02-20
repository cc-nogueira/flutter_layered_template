import '../../../domain_layer.dart';
import '../model/contact_model.dart';
import 'entity_mapper.dart';

/// Map [Contact] entities to/from Isar [ContactModel] objects.
class ContactMapper extends EntityMapper<Contact, ContactModel> {
  /// Const constructor.
  const ContactMapper();

  @override
  Contact mapEntity(ContactModel model) {
    return Contact(
      id: model.id,
      uuid: model.uuid,
      name: model.name,
      about: model.about,
    );
  }

  @override
  ContactModel mapModel(Contact entity) {
    return ContactModel()
      ..id = entity.id
      ..uuid = entity.uuid
      ..name = entity.name
      ..about = entity.about;
  }
}
