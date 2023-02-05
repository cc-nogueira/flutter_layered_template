import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/layer/app_layer.dart';

/// Presentation Layer provider
final presentationLayerProvider = Provider((_) => const AppLayer());
