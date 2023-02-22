part of '../otherthings_use_case.dart';

/// Otherthing Future notifier and provider.
///
/// It is initialized with data loaded through the use case.
/// The use case is responsible for invalidating or updating this notifier.
///
/// This generates a persistent (keepAlive) provider.
@Riverpod(keepAlive: true)
class OtherthingNotifier extends _$OtherthingNotifier {
  @override
  FutureOr<Otherthing?> build() {
    return ref.read(otherthingsUseCaseProvider)._getSomething();
  }
}
