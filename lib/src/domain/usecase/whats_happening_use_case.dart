import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/whats_happening.dart';
import '../layer/domain_layer.dart';
import '../service/whats_happening_service.dart';
import 'notifier/async_guard.dart';

part 'notifier/whats_happening_notifier.dart';

/// This use case [AsyncGuard] provider.
final whatsHappeningAsynGuardProvider = NotifierProvider<AsyncGuard, bool>(AsyncGuard.new);

/// [WhatsHappeningUseCase] singleton provider.
///
/// This provider is an auto dispose provider (keepAlive: false).
/// The state is kept in a [WhatsHappeningNotifier] with a persistent provider.
final whatsHappeningUseCaseProvider = Provider.autoDispose((ref) => WhatsHappeningUseCase(
      ref: ref,
      whatsHappeningService: ref.read(
        ref.read(domainLayerProvider).whatsHappeningServiceProvider,
      ),
    ));

/// Use case with [WhatsHappening]s business rules.
///
/// It provides an API to access [WhatsHappening] services.
/// This a stateless class that may be instantiated on demand by the provider.
///
/// The state is kept in a [WhatsHappeningNotifier] with a persistent provider.
///
/// This is an use case with asynchronous API, as is common in Services APIs.
class WhatsHappeningUseCase {
  /// Const constructor.
  const WhatsHappeningUseCase({required this.ref, required this.whatsHappeningService});

  /// Riverpod ref.
  final Ref ref;

  /// Provisioned [WhatsHappeningService] implementation.
  final WhatsHappeningService whatsHappeningService;

  /// Refresh [WhatsHappening] data by invalidating the [WhatsHappeningNotifier].
  ///
  /// Data fetch is lazy.
  /// It will be fetched when the notifier is observed next or if it is being watched.
  void refresh() {
    ref.invalidate(whatsHappeningProvider);
  }

  /// Protected - Load [WhatsHappening] from the service.
  ///
  /// Invoke the server in a async guarded execution.
  /// Async returns [WhatsHappening] or null from the service implementation.
  ///
  /// Used by [WhatsHappeningNotifier.build] method.
  Future<WhatsHappening?> _getWhatsHappening() {
    return whatsHappeningService.getWhatsHappening();
  }

  /// Handy getter for this use case [AsyncGuard.asyncGuardedExecution] function.
  ///
  /// This is not currently used, there are no modifying actions that would be guarded to
  /// prevent a competing action to be triggered by the user while the first action is executing async.
  ///
  /// Check example/contacts_example class ContactsAsyncUseCase to see the use of AsyncGuardedExecution.
  // ignore: unused_element
  AsyncGuardedExecution get _asyncGuardedExecution =>
      ref.read(whatsHappeningAsynGuardProvider.notifier).asyncGuardedExecution;
}
