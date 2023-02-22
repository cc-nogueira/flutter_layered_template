part of '../things_use_case.dart';

/// All [Thing]s notifier and provider.
///
/// It is initialized with things loaded through the use case.
/// The use case will invalidate this notifier when there are changes in storage.
///
/// This generates a persistent (keepAlive) provider.
@Riverpod(keepAlive: true)
class ThingsNotifier extends _$ThingsNotifier {
  @override
  List<Thing> build() {
    return ref.read(thingsUseCaseProvider)._loadThings();
  }
}

/// A [Thing] provider by id.
///
/// This is an autodispose family provider.
final thingProvider = Provider.family.autoDispose<Thing, int>(
  (ref, id) => ref.watch(
    thingsNotifierProvider.select(
      (value) => value.firstWhere(
        (element) => element.id == id,
        orElse: () => throw const EntityNotFoundException(),
      ),
    ),
  ),
);
