import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain_layer.dart';

/// Presentation layer singleton provider.
///
/// This layer has no behaviour or state and can be just the instantiation of the basic layer.
/// Does not need to do anything in its init or dispose methods.

final presentationLayerProvider = Provider((ref) => const AppLayer());
