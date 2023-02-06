import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'system_locales_state.g.dart';

@Riverpod(keepAlive: true)
class SystemLocalesState extends _$SystemLocalesState with WidgetsBindingObserver {
  @override
  List<Locale> build() {
    WidgetsBinding.instance.addObserver(this);
    return WidgetsBinding.instance.platformDispatcher.locales;
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    if (locales != null) {
      state = locales;
    }
  }
}
