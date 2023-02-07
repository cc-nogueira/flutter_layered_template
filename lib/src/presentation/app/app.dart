import 'package:flutter/material.dart';

import '../common/page/message_page.dart';
import '../l10n/translations.dart';
import 'routes/routes.dart';

/// This is the MaterialApp.
///
/// The constructor may recieve an initialization error to display just an [ErrorMessagePage].
class App extends StatelessWidget {
  /// Constructor.
  ///
  /// May recieve an initialization error to display just an [ErrorMessagePage].
  const App({super.key, this.error});

  /// Error object to be describe a possible initialization error.
  final Object? error;

  /// Internal [Routes] object with the application static route names and generateRoute handler.
  final _routes = const Routes();

  /// Build the application starting with [Routes.home];
  @override
  Widget build(BuildContext context) => error == null ? _app : _errorApp;

  /// The MaterialApp
  Widget get _app => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        localizationsDelegates: Translations.localizationsDelegates,
        supportedLocales: Translations.supportedLocales,
        onGenerateTitle: (context) => Translations.of(context)!.title_home_page,
        onGenerateRoute: _routes.onGenerateRoute,
        initialRoute: Routes.home,
      );

  /// A MaterialApp just to show an [ErrorMessagePage].
  Widget get _errorApp => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        localizationsDelegates: Translations.localizationsDelegates,
        supportedLocales: Translations.supportedLocales,
        onGenerateTitle: (context) => Translations.of(context)!.title_home_page,
        home: ErrorMessagePage(error!),
      );
}
