import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain_layer.dart';
import '../../app/routes/routes.dart';
import '../../l10n/translations.dart';
import 'widget/avatar.dart';

/// Display a contact and its last pending message.
///
/// [Contact] information is retrieved from [contactStateProvider] for the given id.
/// The display is composed of list with
///   - A large avatar.
///   - Contact's name.
///   - A [MessageWidget] for this contact.
class ViewContactPage extends ConsumerWidget {
  /// Const constructor.
  const ViewContactPage({super.key, required this.id});

  /// [Contact.id]
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final tr = Translations.of(context);
    final contact = ref.watch(contactProvider(id));
    return Scaffold(
      appBar: AppBar(title: Text(tr.contact_title)),
      body: ListView(
        children: [
          _avatar(textTheme, contact),
          _name(textTheme, contact),
          const Divider(thickness: 2),
          _about(textTheme, contact),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _editContact(context), child: const Icon(Icons.edit)),
    );
  }

  /// Generate the contact avatar with the two first letters of his name.
  Widget _avatar(TextTheme textTheme, Contact contact) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Avatar(
          contact,
          radius: 40.0,
          textStyle: textTheme.headlineMedium,
        ),
      );

  /// Text with contact's name.
  Widget _name(TextTheme textTheme, Contact contact) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(contact.name, style: textTheme.headlineSmall),
      );

  Widget _about(TextTheme textTheme, Contact contact) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(contact.about, style: textTheme.bodyLarge),
      );

  void _editContact(BuildContext context) {
    context.goNamed(Routes.editContact, params: {'id': id.toString()});
  }
}
