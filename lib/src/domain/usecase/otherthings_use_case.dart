import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../entity/otherthing.dart';
import '../layer/domain_layer.dart';
import '../service/some_service.dart';

part 'notifier/otherthing_notifier.dart';
part 'otherthings_use_case.g.dart';

/// Use case singleton provider.
final otherthingsUseCaseProvider = Provider((ref) => OtherthingsUseCase(
      ref: ref,
      someService: ref.read(
        ref.read(domainLayerProvider).someServiceProvider,
      ),
    ));

/// Use case with [Otherthing]s business rules.
///
/// It provides an API to access and update [Otherthing] entities.
class OtherthingsUseCase {
  /// Const constructor.
  const OtherthingsUseCase({required this.ref, required this.someService});

  /// Riverpod ref.
  final Ref ref;

  /// Provisioned [SomeService] implementation.
  final SomeService someService;

  /// Refresh [Otherthing] data by invalidating the [OtherthingNotifier].
  ///
  /// Data fetch is lazy.
  /// It will be fetched when the notifier is observed next or if it is being watched.
  void refresh() {
    ref.invalidate(otherthingNotifierProvider);
  }

  /// Private - Load something from the service.
  ///
  /// Used by [OtherthingNotifier.build] method.
  Future<Otherthing?> _getSomething() => someService.getSomething();
}
