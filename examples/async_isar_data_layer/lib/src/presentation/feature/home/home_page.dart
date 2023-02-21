import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/routes.dart';
import '../../l10n/translations.dart';

/// Project landing page.
///
/// Shows a page with main navigation cards.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = Translations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(tr.home_page_title)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            _contactsPageCard(context, tr),
          ],
        ),
      ),
    );
  }

  /// Contacts page card.
  Card _contactsPageCard(BuildContext context, Translations tr) => Card(
        color: Theme.of(context).colorScheme.background.withOpacity(0.5),
        child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.people)),
          title: Text(tr.contacts_title),
          onTap: () => context.goNamed(Routes.contacts),
        ),
      );
}
