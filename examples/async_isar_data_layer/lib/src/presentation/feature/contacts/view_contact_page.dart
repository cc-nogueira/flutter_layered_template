import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain_layer.dart';
import '../../app/routes/routes.dart';
import '../../common/page/loading_page.dart';
import '../../common/page/message_page.dart';
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

  /// [Contact.id] page parameter.
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = Translations.of(context);
    return ref.watch(contactProvider(id)).when(
          loading: () => LoadingPage(tr.contact_title),
          data: (data) => _ContactPage(tr, data),
          error: ErrorMessagePage.errorBuilder,
        );
  }
}

class _ContactPage extends StatelessWidget {
  const _ContactPage(this.tr, this.contact);

  final Translations tr;
  final Contact contact;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(tr.contact_title)),
      body: ListView(
        children: [
          _avatar(textTheme),
          _name(textTheme),
          const Divider(thickness: 2),
          _about(textTheme),
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _editContact(context), child: const Icon(Icons.edit)),
    );
  }

  /// Generate the contact avatar with the two first letters of his name.
  Widget _avatar(TextTheme textTheme) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Avatar(
          contact,
          radius: 40.0,
          textStyle: textTheme.headlineMedium,
        ),
      );

  /// Text with contact's name.
  Widget _name(TextTheme textTheme) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(contact.name, style: textTheme.headlineSmall),
      );

  Widget _about(TextTheme textTheme) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(contact.about, style: textTheme.bodyLarge),
      );

  void _editContact(BuildContext context) {
    context.goNamed(Routes.editContact, params: {'id': contact.id.toString()});
  }
}
