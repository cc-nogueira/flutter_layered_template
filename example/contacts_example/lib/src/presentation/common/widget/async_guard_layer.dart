import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/translations.dart';
import 'loading_widget.dart';

class AsyncGuardLayer extends ConsumerWidget {
  /// Const constructor.
  const AsyncGuardLayer({super.key, required this.asyncGuardProvider, required this.child});

  final ProviderBase<bool> asyncGuardProvider;
  final Widget child;

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
      )),
    );
  }
}
