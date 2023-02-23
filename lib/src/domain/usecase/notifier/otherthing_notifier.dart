part of '../otherthings_use_case.dart';

/// Otherthing Future notifier and provider.
///
/// It is initialized with data loaded through the use case.
/// The use case is responsible for invalidating this notifier
/// when the user request a service refresh.
///
/// The singleton instance is kept by the generated persistent (keepAlive) provider.
@Riverpod(keepAlive: true)
class OtherthingNotifier extends _$OtherthingNotifier {
  @override
  FutureOr<Otherthing?> build() {
    return ref.read(otherthingsUseCaseProvider)._getSomething();
  }
}
