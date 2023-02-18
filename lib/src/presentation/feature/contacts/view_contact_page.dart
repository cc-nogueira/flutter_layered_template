import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/utils/string_utils.dart';
import '../../../domain_layer.dart';
import '../../l10n/translations.dart';
import 'widget/message_widget.dart';

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
    final tr = Translations.of(context)!;
    final contact = ref.watch(contactProvider(id));
    return Scaffold(
      appBar: AppBar(title: Text(tr.title_contact_page)),
      body: RefreshIndicator(
        onRefresh: () async => _refresh(ref, contact),
        child: ListView(
          children: [
            _avatar(context, contact.name),
            _name(context, contact.name),
            const Divider(thickness: 2),
            _messageForContact(context, ref, contact),
          ],
        ),
      ),
    );
  }

  /// Generate the contact avatar with the two first letters of his name.
  Widget _avatar(BuildContext context, String name) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: CircleAvatar(
            radius: 40.0,
            child: Text(
              name.cut(max: 2),
              style: Theme.of(context).textTheme.headlineMedium,
            )),
      );

  /// Text with contact's name.
  Widget _name(BuildContext context, String name) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(name, style: Theme.of(context).textTheme.headlineSmall),
      );

  /// [MessageWidget] for the contact.
  Widget _messageForContact(BuildContext context, WidgetRef ref, Contact contact) => MessageWidget(
        contact,
        onRefresh: () => _refresh(ref, contact),
      );

  /// Refresh function that may invoked by the [MessageWidget] or the [RefreshIndicator] widget.
  void _refresh(WidgetRef ref, Contact contact) {
    ref.invalidate(messageProvider(contact));
  }
}
