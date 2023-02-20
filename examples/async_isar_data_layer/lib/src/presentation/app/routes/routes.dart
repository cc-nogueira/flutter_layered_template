import 'package:go_router/go_router.dart';

import '../../feature/contacts/contact_page.dart';
import '../../feature/contacts/contacts_page.dart';
import '../../feature/home/home_page.dart';

/// Route names and path.
///
/// Only root routes may start with '/'.
/// Navigation will use context.goNamed for direct navigation.
class Routes {
  static const home = '/';
  static const contacts = 'contacts';
  static const viewContact = 'viewContact';
}

GoRouter get goRouter {
  return GoRouter(
    routes: [
      GoRoute(name: Routes.home, path: Routes.home, builder: (context, state) => const HomePage(), routes: [
        GoRoute(
          name: Routes.contacts,
          path: Routes.contacts,
          builder: (context, state) => const ContactsPage(),
          routes: [
            GoRoute(
              name: Routes.viewContact,
              path: '${Routes.viewContact}/:id',
              builder: (context, state) => ContactPage(id: int.parse(state.params['id']!)),
            ),
          ],
        ),
      ]),
    ],
  );
}
