import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'src/data_layer.dart';
import 'src/domain_layer.dart';
import 'src/presentation_layer.dart';
import 'src/service_layer.dart';

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
/// Async initializes all layers.
/// Provision the DomainLayer with runtime implementations.
/// Register a dispose callback.
final _appProvider = FutureProvider((ref) async {
  final layers = await _initLayers(ref);
  ref.onDispose(() => _disposeLayers(layers));
  return const App();
});

/// Initialize all layers.
///
/// Async initializes each layers (inner to outer order).
/// Provision the [DomainLayer] with runtime implementations.
///
/// Asserts the domain layer is fully provisioned.
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
    if (layer is ProvisioningLayer) {
      layer.provision(domainLayer);
    }
  }

  assert(domainLayer.validateProvisioning(), "Domain Layer wasn't fully provisioned.");

  return layers;
}

/// Dispose all layers in reverse order.
void _disposeLayers(List<AppLayer> layers) {
  for (final layer in layers.reversed) {
    layer.dispose();
  }
}
