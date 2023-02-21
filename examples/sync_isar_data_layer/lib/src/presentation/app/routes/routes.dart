import 'package:go_router/go_router.dart';

import '../../feature/contacts/contacts_page.dart';
import '../../feature/contacts/edit_contact_page.dart';
import '../../feature/contacts/view_contact_page.dart';
import '../../feature/home/home_page.dart';

/// Route names and path.
///
/// Only root routes may start with '/'.
/// Navigation will use context.goNamed for direct navigation.
class Routes {
  static const home = '/';
  static const contacts = 'contacts';
  static const viewContact = 'viewContact';
  static const editContact = 'editContact';
}

final goRouter = GoRouter(
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
            builder: (context, state) => ViewContactPage(id: int.parse(state.params['id']!)),
            routes: [
              GoRoute(
                name: Routes.editContact,
                path: Routes.editContact,
                builder: (context, state) => EditContactPage(id: int.parse(state.params['id']!)),
              )
            ],
          ),
        ],
      ),
    ]),
  ],
);
