import 'package:flutter/material.dart';

import '../common/page/message_page.dart';
import '../feature/contacts/page/contacts_page.dart';
import '../feature/contacts/page/view_contact_page.dart';
import '../feature/home/home_page.dart';

/// Routes management class.
///
/// Uses static const variables to enumerate available routes and implements
/// onGenerateRoute callback used for named routes navigation.
class Routes {
  const Routes();

  static const home = '/';
  static const contacts = '/contacts';
  static const viewContact = '/viewContact';

  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return _route((_) => const HomePage());
      case contacts:
        return _route((_) => const ContactsPage());
      case viewContact:
        return _routeWithArg<int>(
          arg: settings.arguments,
          builder: (_, arg) => ViewContactPage(id: arg),
        );
      default:
        return _route(
          (_) => ErrorMessagePage('Unknown route "${settings.name}"'),
        );
    }
  }

  Route _route(Widget Function(BuildContext context) builder) =>
      MaterialPageRoute(builder: builder);

  // ignore: unused_element
  Route _routeWithArg<T>({
    required Object? arg,
    required Widget Function(BuildContext, T) builder,
  }) =>
      MaterialPageRoute(
        builder: (context) =>
            arg is T ? builder(context, arg) : const ErrorMessagePage('Illegal argument for route'),
      );
}
