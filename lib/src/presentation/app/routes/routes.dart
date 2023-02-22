import 'package:go_router/go_router.dart';

import '../../feature/things/things_page.dart';

/// Route names and path.
///
/// Only root routes may start with '/'.
/// Navigation will use context.goNamed for direct navigation.
class Routes {
  static const things = '/';
}

final goRouter = GoRouter(
  routes: [
    GoRoute(
      name: Routes.things,
      path: Routes.things,
      builder: (context, state) => ThingsPage(),
    ),
  ],
);
