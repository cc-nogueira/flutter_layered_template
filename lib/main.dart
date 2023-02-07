import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'src/data_layer.dart';
import 'src/domain_layer.dart';
import 'src/presentation_layer.dart';
import 'src/service_layer.dart';

part 'main.g.dart';

/// Application Layers.
final _layers = [
  domainLayer,
  dataLayer,
  serviceLayer,
  presentationLayer,
];

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ProviderScope(
      child: Consumer(
        builder: (_, ref, __) => ref.watch(_appProvider).when(
              loading: () => const Center(child: CircularProgressIndicator()),
              data: (app) => app,
              error: (error, _) => App(error: error),
            ),
      ),
    ),
  );
}

/// Provides the configured application.
///
/// Register dispose callback.
/// Async initializes all layers.
/// Provision the DomainLayer with runtime implementations.
@riverpod
Future<App> _app(_AppRef ref) async {
  ref.onDispose(_disposeLayers);
  await _initLayers(ref);
  return const App();
}

/// Initialize all layers.
///
/// Async initializes each layers (inner to outer order).
/// Provision the DomainLayer with runtime implementations.
Future<void> _initLayers(Ref ref) async {
  for (final layer in _layers) {
    await layer.init(ref);
  }
  domainLayer.provisioning(dataProvision: dataLayer.provision, serviceProvision: serviceLayer.provision);
}

/// Dispose all layers.
///
/// Dispose each layer (outer to inner order).
void _disposeLayers() {
  for (final layer in _layers.reversed) {
    layer.dispose();
  }
}
