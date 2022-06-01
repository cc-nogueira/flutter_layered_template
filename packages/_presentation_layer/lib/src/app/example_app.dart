import 'package:flutter/material.dart';

import '../common/page/message_page.dart';
import '../l10n/translations.dart';
import '../routes/routes.dart';

/// Example App is this application MaterialApp.
///
/// Besides the regular constructor there is ExampleApp.error constructor to
/// handle initialization errors.
class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key}) : error = null;

  const ExampleApp.error(this.error, {super.key});

  final _routes = const Routes();
  final Object? error;

  @override
  Widget build(BuildContext context) => error == null ? _app : _errorApp;

  Widget get _app => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        localizationsDelegates: Translations.localizationsDelegates,
        supportedLocales: Translations.supportedLocales,
        onGenerateTitle: (context) => Translations.of(context)!.title_home_page,
        onGenerateRoute: _routes.onGenerateRoute,
        initialRoute: Routes.home,
      );

  Widget get _errorApp => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        localizationsDelegates: Translations.localizationsDelegates,
        supportedLocales: Translations.supportedLocales,
        onGenerateTitle: (context) => Translations.of(context)!.title_home_page,
        home: ErrorMessagePage(error!),
      );
}
