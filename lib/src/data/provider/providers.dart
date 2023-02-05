import 'package:riverpod/riverpod.dart';

import '../layer/data_layer.dart';

/// Data Layer provider
final dataLayerProvider = Provider((_) => const DataLayer());

/// ContactsRepository interface implementation provider
final contactsRepositoryProvider =
    Provider(((ref) => ref.watch(dataLayerProvider).contactsRepository));
