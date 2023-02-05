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
class ExampleApp extends ConsumerWidget {
  const ExampleApp({super.key, this.error});

  final Object? error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(systemLocalesProvider.notifier);
    return _ExampleApp(systemLocalesController: controller, error: error);
  }
}

class _ExampleApp extends StatelessWidget with WidgetsBindingObserver {
  const _ExampleApp({required this.systemLocalesController, this.error});

  final StateController<List<Locale>> systemLocalesController;
  final Object? error;
  final _routes = const Routes();

  @override
  void didChangeLocales(List<Locale>? locales) {
    if (locales != null) {
      systemLocalesController.state = locales;
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
