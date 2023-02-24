import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/translations.dart';
import 'loading_widget.dart';

/// [ConsumerWidget] that watches a [AsyncGuard] provider.
///
/// If the guard is free just display the child.
/// If the it is guarding any async execution then display the child with a guarding layer preventing interaction.
/// The guarding layer has a "processing..." message and a [LoadingWidget].
class AsyncGuardLayer extends ConsumerWidget {
  /// Const constructor.
  const AsyncGuardLayer({super.key, required this.asyncGuardProvider, required this.child});

  /// Provider for the async guarding status.
  final ProviderBase<bool> asyncGuardProvider;

  /// Child to display.
  final Widget child;

  /// If the guard is free just display the child.
  /// If the it is guarding any async execution then display the child with a guarding layer preventing interaction.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isProcessing = ref.watch(asyncGuardProvider);
    if (!isProcessing) {
      return child;
    }
    return Stack(children: [
      child,
      _guardingLayer(context),
    ]);
  }

  /// A guarding layer with a "processing..." message and a [LoadingWidget].
  Widget _guardingLayer(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tr = Translations.of(context);
    return Container(
      color: colors.surface.withOpacity(0.5),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(64.0),
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: colors.secondaryContainer.withOpacity(0.5),
            border: Border.all(color: colors.primary),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(tr.processing_title, style: textTheme.titleLarge),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: LoadingWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
