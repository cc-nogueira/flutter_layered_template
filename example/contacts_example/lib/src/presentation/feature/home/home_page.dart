import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/route/routes.dart';
import '../../l10n/translations.dart';

/// Project landing page.
///
/// Shows a page with main navigation cards.
///
/// Display navigation to both sync and async example implementations.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  /// Display navigation to both sync and async example implementations.
  @override
  Widget build(BuildContext context) {
    final tr = Translations.of(context);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(tr.home_page_title)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            _contactsSyncPageCard(context, tr, colors, textTheme),
            _contactsAsyncPageCard(context, tr, colors, textTheme),
          ],
        ),
      ),
    );
  }

  /// Contacts sync page card.
  Card _contactsSyncPageCard(BuildContext context, Translations tr, ColorScheme colors, TextTheme textTheme) {
    final color = colors.primary;
    final backColor = colors.primaryContainer;
    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundColor: backColor, child: Icon(Icons.people, color: color)),
        title: RichText(
          text: TextSpan(style: textTheme.titleMedium, children: [
            TextSpan(text: tr.contacts_title),
            TextSpan(text: ' sync ', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            const TextSpan(text: 'API'),
          ]),
        ),
        onTap: () => context.goNamed(Routes.contactsSync),
      ),
    );
  }

  /// Contacts async page card.
  Card _contactsAsyncPageCard(BuildContext context, Translations tr, ColorScheme colors, TextTheme textTheme) {
    final color = colors.error;
    final backColor = colors.errorContainer;
    return Card(
      child: ListTile(
        leading: CircleAvatar(backgroundColor: backColor, child: Icon(Icons.people, color: color)),
        title: RichText(
          text: TextSpan(style: textTheme.titleMedium, children: [
            TextSpan(text: tr.contacts_title),
            TextSpan(text: ' async ', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            const TextSpan(text: 'API'),
          ]),
        ),
        onTap: () => context.goNamed(Routes.contactsAsync),
      ),
    );
  }
}
