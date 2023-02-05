import 'package:riverpod/riverpod.dart';

import '../layer/di_layer.dart';

/// DI Layer provider
final diLayerProvider = Provider.autoDispose((ref) {
  final diLayer = DiLayer(ref);
  ref.onDispose(() {
    diLayer.dispose();
  });
  return diLayer;
});
