import 'package:go_router/go_router.dart';

import '../../feature/things/edit_thing_page.dart';
import '../../feature/things/things_page.dart';

/// Route names and path.
///
/// Only root routes may start with '/'.
/// Navigation will use context.goNamed for direct navigation.
class Routes {
  static const things = '/';
  static const editThing = 'editThing';
}

/// [GoRouter] final instance (singleton).
final goRouter = GoRouter(
  routes: [
    GoRoute(
      name: Routes.things,
      path: Routes.things,
      builder: (context, state) => ThingsPage(),
      routes: [
        GoRoute(
          name: Routes.editThing,
          path: '${Routes.editThing}/:id',
          builder: (context, state) => EditThingPage(id: int.parse(state.params['id']!)),
        ),
      ],
    ),
  ],
);
