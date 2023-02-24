import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common/page/message_page.dart';
import '../l10n/locale_notifier.dart';
import '../l10n/translations.dart';
import 'route/routes.dart';
import 'theme/themes.dart';

/// This is the MaterialApp builder.
///
/// The constructor may recieve an initialization error to display just an [ErrorMessagePage].
class App extends ConsumerWidget {
  /// Constructor.
  ///
  /// May recieve an initialization error to display just an [ErrorMessagePage].
  const App({super.key, this.error});

  /// Error object to be describe a possible initialization error.
  final Object? error;

  /// Build the application starting with [Routes.things];
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return error == null ? _app(ref) : _errorApp(ref);
  }

  /// The [MaterialApp].
  Widget _app(WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      localizationsDelegates: Translations.localizationsDelegates,
      supportedLocales: Translations.supportedLocales,
      locale: locale,
      onGenerateTitle: (context) => Translations.of(context).things_title,
      routerConfig: goRouter,
    );
  }

  /// A [MaterialApp] just to show an [ErrorMessagePage].
  Widget _errorApp(WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Themes.lightTheme,
      darkTheme: Themes.darkTheme,
      localizationsDelegates: Translations.localizationsDelegates,
      supportedLocales: Translations.supportedLocales,
      locale: locale,
      onGenerateTitle: (context) => Translations.of(context).things_title,
      home: ErrorMessagePage(error!),
    );
  }
}
