import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/string_utils.dart';
import '../../../../domain/entity/contact.dart';
import '../../../../domain/usecase/contacts_usecase.dart';
import '../../../l10n/translations.dart';
import '../widget/message_widget.dart';

class ViewContactPage extends ConsumerWidget {
  const ViewContactPage({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contact = ref.watch(contactStateProvider(id));
    return _ViewContactPage(contact);
  }
}

class _ViewContactPage extends StatelessWidget {
  const _ViewContactPage(this.contact);

  final Contact contact;

  @override
  Widget build(BuildContext context) {
    final tr = Translations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(tr.title_contact_page)),
      body: _contactDetails(context),
    );
  }

  Widget _contactDetails(BuildContext context) {
    return ListView(
      children: [
        _avatar(context),
        _name(context),
        const Divider(thickness: 2),
        _messageForContact(context),
      ],
    );
  }

  Widget _avatar(BuildContext context) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: CircleAvatar(
            radius: 40.0,
            child: Text(
              contact.name.cut(max: 2),
              style: Theme.of(context).textTheme.headlineMedium,
            )),
      );

  Widget _name(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(contact.name, style: Theme.of(context).textTheme.headlineSmall),
      );

  Widget _messageForContact(BuildContext context) => MessageWidget(contact);
}
