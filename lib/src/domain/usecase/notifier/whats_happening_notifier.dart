part of '../whats_happening_use_case.dart';

/// Persitent [WhatsHappeingNotifier] provider (keepAlive: true)
final whatsHappeningProvider =
    AsyncNotifierProvider<WhatsHappeningNotifier, WhatsHappening?>(WhatsHappeningNotifier.new);

/// [WhatsHappening] Future notifier and provider.
///
/// It is initialized with data loaded through the use case.
/// The use case is responsible for invalidating this notifier
/// when the user request a service refresh.
///
/// The singleton instance is kept by the persistent (keepAlive) provider.
class WhatsHappeningNotifier extends AsyncNotifier<WhatsHappening?> {
  @override
  FutureOr<WhatsHappening?> build() {
    return ref.read(whatsHappeningUseCaseProvider)._getWhatsHappening();
  }
}
