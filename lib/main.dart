import 'package:_di_layer/di_layer.dart';
import 'package:_presentation_layer/presentation_layer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ProviderScope(
      child: Consumer(
        builder: (_, ref, __) => ref.watch(appProvider(widgetsBinding)).when(
              loading: () => const Center(child: CircularProgressIndicator()),
              data: (app) => app,
              error: (error, _) => ExampleApp.error(error, read: ref.read),
            ),
      ),
    ),
  );
}

/// Provides the configured application.
///
/// Async initialzes all layers through DI Layer init method.
final appProvider =
    FutureProvider.family.autoDispose<Widget, WidgetsBinding>((ref, widgetsBinding) async {
  final diLayer = ref.watch(diLayerProvider);
  diLayer.preInitWith(widgetsBinding.platformDispatcher.locales);
  await diLayer.init();

  final app = ExampleApp(read: ref.read);
  widgetsBinding.addObserver(app);

  return app;
});
