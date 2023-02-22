import 'package:go_router/go_router.dart';

import '../../feature/contacts/async/contacts_async_page.dart';
import '../../feature/contacts/async/edit_contact_async_page.dart';
import '../../feature/contacts/async/view_contact_async_page.dart';
import '../../feature/contacts/sync/contacts_sync_page.dart';
import '../../feature/contacts/sync/edit_contact_sync_page.dart';
import '../../feature/contacts/sync/view_contact_sync_page.dart';
import '../../feature/home/home_page.dart';

/// Route names and path.
///
/// Only root routes may start with '/'.
/// Navigation will use context.goNamed for direct navigation.
class Routes {
  static const home = '/';
  static const contactsSync = 'contactsSync';
  static const viewContactSync = 'viewContactSync';
  static const editContactSync = 'editContactSync';
  static const contactsAsync = 'contactsAsync';
  static const viewContactAsync = 'viewContactAsync';
  static const editContactAsync = 'editContactAsync';
}

final goRouter = GoRouter(
  routes: [
    GoRoute(name: Routes.home, path: Routes.home, builder: (context, state) => const HomePage(), routes: [
      GoRoute(
        name: Routes.contactsSync,
        path: Routes.contactsSync,
        builder: (context, state) => const ContactsSyncPage(),
        routes: [
          GoRoute(
            name: Routes.viewContactSync,
            path: '${Routes.viewContactSync}/:id',
            builder: (context, state) => ViewContactSyncPage(id: int.parse(state.params['id']!)),
            routes: [
              GoRoute(
                name: Routes.editContactSync,
                path: Routes.editContactSync,
                builder: (context, state) => EditContactSyncPage(id: int.parse(state.params['id']!)),
              )
            ],
          ),
        ],
      ),
      GoRoute(
        name: Routes.contactsAsync,
        path: Routes.contactsAsync,
        builder: (context, state) => const ContactsAsyncPage(),
        routes: [
          GoRoute(
            name: Routes.viewContactAsync,
            path: '${Routes.viewContactAsync}/:id',
            builder: (context, state) => ViewContactAsyncPage(id: int.parse(state.params['id']!)),
            routes: [
              GoRoute(
                name: Routes.editContactAsync,
                path: Routes.editContactAsync,
                builder: (context, state) => EditContactAsyncPage(id: int.parse(state.params['id']!)),
              )
            ],
          ),
        ],
      ),
    ]),
  ],
);
