import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain/entity/otherthing.dart';
import '../../../../domain/usecase/otherthings_use_case.dart';
import '../../../common/widget/loading_widget.dart';
import '../../../l10n/translations.dart';

class OtherthingWidget extends StatelessWidget {
  const OtherthingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = Translations.of(context);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${tr.from_server_title}:',
                    style: textTheme.titleMedium?.copyWith(color: colors.tertiary, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  const _RemoteContent(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RemoteContent extends ConsumerWidget {
  const _RemoteContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = Translations.of(context);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return ref.watch(otherthingNotifierProvider).when(
          skipLoadingOnRefresh: false,
          loading: _loading,
          data: (data) => _showView(ref, tr, colors, textTheme, data),
          error: (error, _) => _showError(ref, tr, colors, error),
        );
  }

  Widget _loading() => const SizedBox(width: 40, height: 40, child: LoadingWidget());

  Widget _showView(WidgetRef ref, Translations tr, ColorScheme colors, TextTheme textTheme, Otherthing? data) {
    final content = Text(data?.content ?? tr.nothing_from_server_message, style: textTheme.titleMedium);
    return _contentAndRefreshButton(ref, tr, content);
  }

  Widget _showError(WidgetRef ref, Translations tr, ColorScheme colors, Object error) {
    final content = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error, color: colors.error),
        const SizedBox(width: 10),
        Text(error.toString()),
      ],
    );
    return _contentAndRefreshButton(ref, tr, content);
  }

  /// Create a line with server content and a refresh button.
  Widget _contentAndRefreshButton(WidgetRef ref, Translations tr, Widget message) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: message),
        OutlinedButton(onPressed: () => _refresh(ref), child: Text(tr.refresh_title))
      ],
    );
  }

  /// Invoke [OtherthingsUseCase.refresh].
  void _refresh(WidgetRef ref) {
    ref.read(otherthingsUseCaseProvider).refresh();
  }
}
