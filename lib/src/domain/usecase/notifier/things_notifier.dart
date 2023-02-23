part of '../things_use_case.dart';

/// All [Thing]s notifier and provider.
///
/// It is initialized with things loaded through the use case.
/// The use case will invalidate this notifier when there are changes in storage.
/// There are no public methods to change the state it just fetches all [Thing]s when invalidated and observed.
///
/// The singleton instance is kept by the generated persistent (keepAlive) provider.
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
///
/// Get one [Thing] from the the all things provider (by id).
/// It only triggers observers when the observed [Thing] changes.
/// It will not trigger if any other thing changes, is delete or added.
///
/// Throws [EntityNotFoundException] if the id is not present in all known things.
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
