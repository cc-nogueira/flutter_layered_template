import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'translations.dart';

/// Persistent [LocaleNotifier] provider.
final localeProvider = NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);

/// Locale [Notifier] that observes when the device change of locales preferences.
///
/// Present the current locale resolved from device locale preferences to [Translations] supported locales.
class LocaleNotifier extends Notifier<Locale> with WidgetsBindingObserver {
  /// Initialize with the resolved locale for the current platform options.
  ///
  /// Also register this instance as observer for device change of locale preferences.
  @override
  Locale build() {
    WidgetsBinding.instance.addObserver(this);
    final locales = WidgetsBinding.instance.platformDispatcher.locales;
    return _resolve(locales);
  }

  /// Handle device change of locale preferences.
  @override
  void didChangeLocales(List<Locale>? locales) {
    if (locales != null) {
      state = _resolve(locales);
    }
  }

  /// Resolve device locale preferences to a supported [Translations] locales.
  Locale _resolve(List<Locale> locales) {
    for (final locale in locales) {
      if (Translations.delegate.isSupported(locale)) {
        return locale;
      }
    }
    return Translations.supportedLocales.first;
  }
}
