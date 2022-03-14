import 'package:flutter/material.dart';

import '../../routes/routes.dart';

/// Projects landing page.
///
/// Shows a page with main navigation cards.
class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Layered Template')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            _contactsPageCard(context),
          ],
        ),
      ),
    );
  }

  Card _contactsPageCard(BuildContext context) => Card(
        color: Theme.of(context).colorScheme.background.withOpacity(0.5),
        child: ListTile(
          leading: const CircleAvatar(child: Icon(Icons.people)),
          title: const Text('Contacts'),
          onTap: () => Navigator.pushNamed(context, Routes.contacts),
        ),
      );
}
