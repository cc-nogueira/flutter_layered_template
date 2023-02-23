import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entity/whats_happening.dart';
import '../layer/domain_layer.dart';
import '../service/whats_happening_service.dart';
import 'notifier/async_guard.dart';

part 'notifier/whats_happening_notifier.dart';

/// This use case [AsyncGuard] provider.
final whatsHappeningAsynGuardProvider = NotifierProvider<AsyncGuard, bool>(AsyncGuard.new);

/// [OtherthingsUseCase] singleton provider.
///
/// This provider is an auto dispose provider (keepAlive: false).
/// The state is kept in a [OtherthingNotifier] with a persistent provider.
final whatsHappeningUseCaseProvider = Provider.autoDispose((ref) => OtherthingsUseCase(
      ref: ref,
      someService: ref.read(
        ref.read(domainLayerProvider).whatsHappeningServiceProvider,
      ),
    ));

/// Use case with [Otherthing]s business rules.
///
/// It provides an API to access [Otherthing] services.
/// This a stateless class that may be instantiated on demand by the provider.
///
/// The state is kept in a [OtherthingNotifier] with a persistent provider.
///
/// This is an use case with asynchronous API, as is common in Services APIs.
class OtherthingsUseCase {
  /// Const constructor.
  const OtherthingsUseCase({required this.ref, required this.someService});

  /// Riverpod ref.
  final Ref ref;

  /// Provisioned [WhatsHappeningService] implementation.
  final WhatsHappeningService someService;

  /// Refresh [Otherthing] data by invalidating the [OtherthingNotifier].
  ///
  /// Data fetch is lazy.
  /// It will be fetched when the notifier is observed next or if it is being watched.
  void refresh() {
    ref.invalidate(whatsHappeningProvider);
  }

  /// Protected - Load something from the service.
  ///
  /// Invoke the server in a async guarded execution.
  /// Async returns [WhatsHappening] or null from the service implementation.
  ///
  /// Used by [WhatsHappeningNotifier.build] method.
  Future<WhatsHappening?> _getWhatsHappening() {
    return someService.getWhatsHappening();
  }

  /// Handy getter for this use case [AsyncGuard.asyncGuardedExecution] function.
  AsyncExecution get _asyncGuardedExecution => ref.read(whatsHappeningAsynGuardProvider.notifier).asyncGuardedExecution;
}
