import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain.dart';

/// UI layer singleton provider.
///
/// This layer has no behaviour or state and can be just the instantiation of the basic layer.
/// Does not need to do anything in its init or dispose methods.

final uiLayerProvider = Provider((ref) => const AppLayer());
