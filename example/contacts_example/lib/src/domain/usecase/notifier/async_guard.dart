import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../exception/async_guard_violation.dart';

/// [AsyncGuard.asyncGuardedExecution] function type.
///
/// This is used by used case handy methods to provider a getter for it's [AsyncGuard] function.
typedef AsyncGuardedExecution = Future<T> Function<T>(
  Future<T> Function() callback, {
  Function()? postExecution,
  bool throwsOnGuardViolation,
});

/// A boolean notifier to mark async guarded actions in execution.
///
/// The user interface observes this provider to block user interaction in pages
/// sharing the same guard.
class AsyncGuard extends Notifier<bool> {
  /// Constructor.
  AsyncGuard();

  /// Controls how many executions are running inside the guard.
  ///
  /// Executions increase this count when entering the guard.
  /// And decrease this count when exiting.
  ///
  /// The scope is considered free when this count is zero.
  late int _guardedCount;

  /// Starts with no execution in scope.
  /// Returns false, meaning free of any guarded execution.
  @override
  bool build() {
    _guardedCount = 0;
    return _isGuarding;
  }

  /// Guard flagged execution of an async use case operation.
  ///
  /// Following the sequence:
  ///   - Try to acquire the guard with [_startAsyncGuard].
  ///   - Continues if acquired or if not throwing on guard violation (defaults to not throwing).
  ///   - Waits for the execution of the guarded callback.
  ///   - Waits for the execution of optional postExecution callback.
  ///   - Ends the async guard with [_endAsyncGuard] (in a finally clause).
  ///   - Returns the callback returned value.
  ///
  /// Throws an [AsyncGuardViolation] if cannot acquired the guard and [throwsOnGuardViolation] is true.
  /// Forwards any exception raised in callback or postExecution callback.
  Future<T> asyncGuardedExecution<T>(
    Future<T> Function() callback, {
    Function()? postExecution,
    bool throwsOnGuardViolation = false,
  }) async {
    try {
      /// Start an async guard that must be ended even if aquired returns false.
      final acquiredGuard = _startAsyncGuard();
      if (!acquiredGuard && throwsOnGuardViolation) {
        throw const AsyncGuardViolation();
      }

      /// Execute the guarded callback.
      final answer = await callback();

      /// Optional postExecution.
      if (postExecution != null) {
        final postReturn = postExecution();
        if (postReturn is Future) {
          await postReturn;
        }
      }

      /// Answer callback
      return answer;
    } finally {
      /// Finally end the guard.
      _endAsyncGuard();
    }
  }

  /// Internal - Register the entering in this guarded scope.
  ///
  /// Returns true if the guard has just started.
  /// Returns false if entering a already guarded scope.
  bool _startAsyncGuard() {
    ++_guardedCount;
    state = _isGuarding;
    return state;
  }

  /// Internal - Register the end of an async guarded operation.
  void _endAsyncGuard() {
    if (_guardedCount > 0) {
      --_guardedCount;
    }
    state = _isGuarding;
  }

  /// Internal - Getter if there are executions being guarded.
  bool get _isGuarding => _guardedCount > 0;
}
