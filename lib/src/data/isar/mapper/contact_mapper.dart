import '../../../domain_layer.dart';
import '../model/contact_model.dart';
import 'entity_mapper.dart';

class ContactMapper extends EntityMapper<Contact, ContactModel> {
  const ContactMapper();

  @override
  Contact mapEntity(ContactModel model) {
    return Contact(
      id: model.id,
      uuid: model.uuid,
      name: model.name,
    );
  }

  @override
  ContactModel mapModel(Contact entity) {
    return ContactModel()
      ..id = entity.id
      ..uuid = entity.uuid
      ..name = entity.name;
  }
}
