import 'package:_domain_layer/domain_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/page/message_page.dart';
import '../l10n/translations.dart';
import '../routes/routes.dart';

/// Example App is this application MaterialApp.
///
/// Besides the regular constructor there is ExampleApp.error constructor to
/// handle initialization errors.
class ExampleApp extends StatelessWidget with WidgetsBindingObserver {
  const ExampleApp({super.key, required this.read}) : error = null;

  const ExampleApp.error(this.error, {super.key, required this.read});

  final Reader read;
  final _routes = const Routes();
  final Object? error;

  @override
  void didChangeLocales(List<Locale>? locales) {
    if (locales != null) {
      read(systemLocalesProvider.notifier).state = locales;
    }
  }

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
