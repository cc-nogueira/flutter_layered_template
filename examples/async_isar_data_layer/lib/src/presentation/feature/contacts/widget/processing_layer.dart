import 'package:flutter/material.dart';

import '../../../common/widget/loading_widget.dart';
import '../../../l10n/translations.dart';

class ProcessingLayer extends StatelessWidget {
  /// Const constructor.
  const ProcessingLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final tr = Translations.of(context);
    return Container(
      color: const Color(0x80FFFFFF),
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
