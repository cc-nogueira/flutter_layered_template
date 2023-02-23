import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain_layer.dart';
import '../../../common/widget/loading_widget.dart';
import '../../../l10n/translations.dart';

/// Display a widget with [_RemoteContent] from the server.
///
/// The widget is a [Card] with a title and the remote content widget.
class WhatsHappeningWidget extends StatelessWidget {
  const WhatsHappeningWidget({super.key});

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

/// Consumer widget that watches the [otherthingNotifierProvider] to display the latest
/// content from the server.
///
/// Displays the latest content from the server and
/// a refresh button to request the [OtherthingsUseCase] to refresh server data.
class _RemoteContent extends ConsumerWidget {
  /// Const constructor.
  const _RemoteContent();

  /// Watches [otherthingNotifierProvider] and display loading, data or error states.
  ///
  /// Configures riverpod to show a new loading widget every time the server is fetching new content.
  ///
  /// Displays the latest content from the server and
  /// a refresh button to request the [OtherthingsUseCase] to refresh server data.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = Translations.of(context);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return ref.watch(whatsHappeningProvider).when(
          skipLoadingOnRefresh: false,
          loading: _loading,
          data: (data) => _showView(ref, tr, colors, textTheme, data),
          error: (error, _) => _showError(ref, tr, colors, error),
        );
  }

  /// Show a [LoadingWidget] in a 40 pixels box.
  Widget _loading() => const Padding(
        padding: EdgeInsets.symmetric(vertical: 4.0),
        child: SizedBox(width: 40, height: 40, child: LoadingWidget()),
      );

  /// Show content and refresh button.
  Widget _showView(WidgetRef ref, Translations tr, ColorScheme colors, TextTheme textTheme, WhatsHappening? data) {
    final content = Text(data?.content ?? tr.nothing_from_server_message, style: textTheme.titleMedium);
    return _contentAndRefreshButton(ref, tr, content);
  }

  /// Show servive error and refresh button.
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
    ref.read(whatsHappeningUseCaseProvider).refresh();
  }
}
