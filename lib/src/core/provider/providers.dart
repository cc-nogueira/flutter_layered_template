import 'package:riverpod/riverpod.dart';

import '../layer/app_layer.dart';

/// Core Layer provider
final coreLayerProvider = Provider((_) => const AppLayer());
