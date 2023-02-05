import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/di/provider/providers.dart';
import 'src/presentation/app/example_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ProviderScope(
      child: Consumer(
        builder: (_, ref, __) => ref.watch(appProvider).when(
              loading: () => const Center(child: CircularProgressIndicator()),
              data: (app) => app,
              error: (error, _) => ExampleApp(error: error),
            ),
      ),
    ),
  );
}

/// Provides the configured application.
///
/// Async initializes all layers through DI Layer init method.
final appProvider = FutureProvider.autoDispose<Widget>((ref) async {
  final diLayer = ref.watch(diLayerProvider);
  await diLayer.init();

  return const ExampleApp();
});
