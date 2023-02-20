import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'translations.dart';

final localeProvider = NotifierProvider<LocaleNotifier, Locale>(LocaleNotifier.new);

class LocaleNotifier extends Notifier<Locale> with WidgetsBindingObserver {
  @override
  Locale build() {
    WidgetsBinding.instance.addObserver(this);
    final locales = WidgetsBinding.instance.platformDispatcher.locales;
    return _resolve(locales);
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    if (locales != null) {
      state = _resolve(locales);
    }
  }

  Locale _resolve(List<Locale> locales) {
    for (final locale in locales) {
      if (Translations.delegate.isSupported(locale)) {
        return locale;
      }
    }
    return Translations.supportedLocales.first;
  }
}
