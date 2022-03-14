import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../layer/di_layer.dart';

/// DI Layer provider
final diLayerProvider = Provider.autoDispose((ref) {
  final diLayer = DiLayer(ref.read);
  ref.onDispose(() {
    diLayer.dispose();
  });
  return diLayer;
});
