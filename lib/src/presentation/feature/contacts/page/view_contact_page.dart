import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/string_utils.dart';
import '../../../../domain_layer.dart';
import '../../../l10n/translations.dart';
import '../widget/message_widget.dart';

class ViewContactPage extends ConsumerWidget {
  const ViewContactPage({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = Translations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(tr.title_contact_page)),
      body: _contactDetails(context, ref),
    );
  }

  Widget _contactDetails(BuildContext context, WidgetRef ref) {
    final contact = ref.watch(contactStateProvider(id));
    return RefreshIndicator(
      onRefresh: () async => _refresh(ref, contact),
      child: ListView(
        children: [
          _avatar(context, contact.name),
          _name(context, contact.name),
          const Divider(thickness: 2),
          _messageForContact(context, ref, contact),
        ],
      ),
    );
  }

  Widget _avatar(BuildContext context, String name) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: CircleAvatar(
            radius: 40.0,
            child: Text(
              name.cut(max: 2),
              style: Theme.of(context).textTheme.headlineMedium,
            )),
      );

  Widget _name(BuildContext context, String name) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(name, style: Theme.of(context).textTheme.headlineSmall),
      );

  Widget _messageForContact(BuildContext context, WidgetRef ref, Contact contact) => MessageWidget(
        contact,
        onRefresh: () => _refresh(ref, contact),
      );

  void _refresh(WidgetRef ref, Contact contact) {
    ref.invalidate(messageStateProvider(contact));
  }
}
