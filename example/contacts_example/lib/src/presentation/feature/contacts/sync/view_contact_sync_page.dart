import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain_layer.dart';
import '../../../app/routes/routes.dart';
import '../../../l10n/translations.dart';
import '../widget/avatar.dart';

/// Display a contact and its last pending message.
///
/// [Contact] information is retrieved from [contactSyncProvider] for the given id.
/// The display is composed of list with
///   - A large avatar.
///   - Contact's name.
///   - A [MessageWidget] for this contact.
class ViewContactSyncPage extends ConsumerWidget {
  /// Const constructor.
  const ViewContactSyncPage({super.key, required this.id});

  /// [Contact.id] page parameter.
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = Translations.of(context);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final contact = ref.watch(contactSyncProvider(id));
    return Scaffold(
      appBar: AppBar(title: Text(tr.contact_title)),
      body: ListView(
        children: [
          _avatar(textTheme, contact),
          _name(tr, colors, textTheme, contact),
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

  /// Text with contact's name and personality tag.
  Widget _name(Translations tr, ColorScheme colors, TextTheme textTheme, Contact contact) {
    final name = Text(contact.name, style: textTheme.headlineSmall);
    final widget = (contact.isPersonality)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr.personality_title,
                style: textTheme.bodyLarge?.copyWith(color: colors.tertiary, fontWeight: FontWeight.bold),
              ),
              name,
            ],
          )
        : name;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: widget,
    );
  }

  Widget _about(TextTheme textTheme, Contact contact) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(contact.about, style: textTheme.bodyLarge),
      );

  void _editContact(BuildContext context) {
    context.goNamed(Routes.editContactSync, params: {'id': id.toString()});
  }
}
