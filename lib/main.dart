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
final appProvider = FutureProvider.autoDispose<Widget>((Ref ref) async {
  await _initLayers(ref);

  return const ExampleApp();
});

Future<void> _initLayers(Ref ref) async {
  await domainLayer.init(ref);
  await dataLayer.init(ref);
  await serviceLayer.init(ref);
  await presentationLayer.init(ref);

  domainLayer.provisioning(dataProvision: dataLayer.provision, serviceProvision: serviceLayer.provision);
}
