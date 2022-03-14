import 'package:_domain_layer/domain_layer.dart';
import 'package:_service_layer/service_layer.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Widget to display contact's message
///
/// This consumer widget fetchs this contact message from the messageProvider.
/// This is in turn makes an async call to
class MessageWidget extends ConsumerWidget {
  const MessageWidget(this.contact, {Key? key}) : super(key: key);

  final Contact contact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (contact.uuid.isEmpty) {
      return Container();
    }
    return ref.watch(messageProvider(contact)).when(
          loading: () => _MessageWidget.loading(contact),
          data: (data) => _MessageWidget(
            contact: contact,
            message: data,
            onRefresh: () => _refresh(ref),
          ),
          error: (error, _) => _MessageWidget.error(
              contact: contact, error: error, onRefresh: () => _refresh(ref)),
        );
  }

  void _refresh(WidgetRef ref) {
    ref.refresh(messageProvider(contact));
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
    Key? key,
    required this.contact,
    this.loading = false,
    this.message,
    this.error,
    required this.onRefresh,
  }) : super(key: key);

  factory _MessageWidget.loading(Contact contact) =>
      _MessageWidget(contact: contact, loading: true, onRefresh: null);

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
    if (loading) {
      return _buildLoading(context);
    }
    if (error != null) {
      return _buildError(context);
    }
    if (message == null) {
      return _buildNoMessage(context);
    }
    return _buildMessage(context);
  }

  Widget _buildLoading(BuildContext context) {
    const loading = Padding(
      padding: EdgeInsets.all(12),
      child: CircularProgressIndicator(color: Colors.grey),
    );
    return _buildCard(
      context,
      leading: const SizedBox(height: 60, width: 60, child: loading),
      subtitle: 'Loading...',
    );
  }

  Widget _buildNoMessage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCard(
          context,
          leading: _icon(),
          subtitle: 'No message!',
        ),
        _buildRefreshButton(context),
      ],
    );
  }

  Widget _buildMessage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCard(
          context,
          leading: _icon(),
          subtitle: 'From: ${message!.sender.name}',
        ),
        _buildText(context),
        _buildRefreshButton(context),
      ],
    );
  }

  Widget _buildError(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCard(
          context,
          leading: _icon(Icons.error),
          subtitle: error.toString(),
        ),
        _buildRefreshButton(context),
      ],
    );
  }

  Widget _buildCard(
    BuildContext context, {
    required Widget leading,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Card(
        child: ListTile(
          leading: leading,
          title: const Text('Pending Message:'),
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
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                ),
              ),
            ),
          ),
        ],
      );

  Widget _buildRefreshButton(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 20.0, top: 12.0),
        child:
            OutlinedButton(onPressed: onRefresh, child: const Text('Refresh')),
      );

  Widget _icon([IconData? data]) =>
      SizedBox(height: 60, width: 60, child: Icon(data ?? Icons.message));
}
