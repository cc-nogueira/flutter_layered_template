import 'package:_di_layer/di_layer.dart';
import 'package:_presentation_layer/presentation_layer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() => runApp(
      ProviderScope(
        child: Consumer(
          builder: (_, ref, __) => ref.watch(appProvider).when(
                loading: () => const Center(child: CircularProgressIndicator()),
                data: (app) => app,
                error: (error, _) => ExampleApp.error(error),
              ),
        ),
      ),
    );

/// Provides the configured application.
///
/// Async initialzes all layers through DI Layer init method.
final appProvider = FutureProvider.autoDispose<Widget>((ref) async {
  final diLayer = ref.watch(diLayerProvider);
  await diLayer.init();
  return const ExampleApp();
});
