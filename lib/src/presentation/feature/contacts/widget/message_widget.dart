import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain_layer.dart';
import '../../../l10n/translations.dart';

/// Widget to display contact's message
///
/// This consumer widget watchs pending messages for this contact from the messageProvider.
/// Displays distinct Loading, Message and Error states from the async messageProvider.
class MessageWidget extends ConsumerWidget {
  /// Constructor.
  const MessageWidget(this.contact, {super.key, required this.onRefresh});

  /// Contact to fetch messages for.
  final Contact contact;

  /// Refresh function that will invalidate the current message in the provider.
  ///
  /// When the provider is invalidated the watch is triggered and the widget rebuilds.
  final void Function() onRefresh;

  /// Display contact's message.
  ///
  /// This consumer widget watchs pending messages for this contact from the messageProvider.
  /// Displays distinct Loading, Message and Error states from the async messageProvider.
  ///
  /// The watch is configured to redisplay the loading state when the provider is invalidated to check for a new message.
  /// See [onRefresh].
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (contact.uuid.isEmpty) {
      return Container();
    }
    return ref.watch(messageStateProvider(contact)).when(
          skipLoadingOnRefresh: false,
          loading: () => _MessageWidget.loading(contact),
          data: (data) {
            return _MessageWidget(
              contact: contact,
              message: data,
              onRefresh: onRefresh,
            );
          },
          error: (error, _) => _MessageWidget.error(contact: contact, error: error, onRefresh: onRefresh),
        );
  }
}

/// Widget to display contact's message.
///
/// Presents different views for the possible status:
///  - Loading
///  - Error
///  - No message
///  - With message
class _MessageWidget extends StatelessWidget {
  const _MessageWidget({
    required this.contact,
    this.loading = false,
    this.message,
    this.error,
    required this.onRefresh,
  });

  factory _MessageWidget.loading(Contact contact) => _MessageWidget(
        contact: contact,
        loading: true,
        onRefresh: null,
      );

  factory _MessageWidget.error({
    required Contact contact,
    required Object error,
    required void Function() onRefresh,
  }) =>
      _MessageWidget(contact: contact, error: error, onRefresh: onRefresh);

  final Contact contact;
  final bool loading;
  final Message? message;
  final Object? error;
  final void Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final tr = Translations.of(context)!;
    if (loading) {
      return _buildLoading(context, tr);
    }
    if (error != null) {
      return _buildError(context, tr);
    }
    if (message == null) {
      return _buildNoMessage(context, tr);
    }
    return _buildMessage(context, tr);
  }

  Widget _buildLoading(BuildContext context, Translations tr) {
    const loading = Padding(
      padding: EdgeInsets.all(12),
      child: CircularProgressIndicator(color: Colors.grey),
    );
    return _buildCard(
      context,
      tr,
      leading: const SizedBox(height: 60, width: 60, child: loading),
      subtitle: '${tr.message_loading}...',
    );
  }

  Widget _buildNoMessage(BuildContext context, Translations tr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCard(
          context,
          tr,
          leading: _icon(),
          subtitle: '${tr.message_no_message}!',
        ),
        _buildRefreshButton(context),
      ],
    );
  }

  Widget _buildMessage(BuildContext context, Translations tr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCard(
          context,
          tr,
          leading: _icon(),
          subtitle: '${tr.label_from}: ${message!.sender.name}',
        ),
        _buildText(context),
        _buildRefreshButton(context),
      ],
    );
  }

  Widget _buildError(BuildContext context, Translations tr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCard(
          context,
          tr,
          leading: _icon(Icons.error),
          subtitle: error.toString(),
        ),
        _buildRefreshButton(context),
      ],
    );
  }

  Widget _buildCard(
    BuildContext context,
    Translations tr, {
    required Widget leading,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        child: ListTile(
          leading: leading,
          title: Text('${tr.title_pending_message}:'),
          subtitle: Text(subtitle),
        ),
      ),
    );
  }

  Widget _buildText(BuildContext context) => Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 12.0,
                  ),
                  child: Text(
                    message!.text,
                    maxLines: null,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  Widget _buildRefreshButton(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 12.0),
        child: OutlinedButton(onPressed: onRefresh, child: const Text('Refresh')),
      );

  Widget _icon([IconData? data]) => SizedBox(height: 60, width: 60, child: Icon(data ?? Icons.message));
}
