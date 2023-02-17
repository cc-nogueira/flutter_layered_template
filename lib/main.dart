import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'src/data_layer.dart';
import 'src/domain_layer.dart';
import 'src/presentation_layer.dart';
import 'src/service_layer.dart';

part 'main.g.dart';

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
  final layers = await _initLayers(ref);
  ref.onDispose(() => _disposeLayers(layers));
  return const App();
}

/// Initialize all layers.
///
/// Async initializes each layers (inner to outer order).
/// Provision the DomainLayer with runtime implementations.
///
/// Return the list of layers in inside to outside order.
Future<List<AppLayer>> _initLayers(Ref ref) async {
  final domainLayer = ref.read(domainLayerProvider);
  final dataLayer = ref.read(dataLayerProvider);
  final serviceLayer = ref.read(serviceLayerProvider);
  final presentationLayer = ref.read(presentationLayerProvider);

  final layers = [domainLayer, dataLayer, serviceLayer, presentationLayer];
  for (final layer in layers) {
    await layer.init(ref);
  }

  domainLayer.provisioning(
    dataProvision: dataLayer.provision,
    serviceProvision: serviceLayer.provision,
  );

  return layers;
}

/// Dispose all layers in reverse order.
void _disposeLayers(List<AppLayer> layers) {
  for (final layer in layers.reversed) {
    layer.dispose();
  }
}
