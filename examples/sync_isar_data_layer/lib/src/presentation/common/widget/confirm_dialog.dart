import 'package:flutter/material.dart';

import '../../l10n/translations.dart';

/// Shows a dialog that has three return values:
///
/// TRUE for CANCEL button.
/// FALSE for OK button.
/// NULL for dialog dismiss.
Future<bool?> showConfirmDialog({required BuildContext context, required String message}) async {
  return showDialog<bool>(
    context: context,
    builder: (_) => ConfirmDialog(message: message),
  );
}

/// Shows a confirm dialog with a message and two buttons.
///
/// The dialog closes returning one of three values:
///
/// false for CANCEL button.
/// true for CONFIRM button.
/// NULL for dialog dismiss.
class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final tr = Translations.of(context);
    return AlertDialog(
      title: Text(tr.confirm_title),
      content: content(context, tr),
      actions: actions(context, tr),
    );
  }

  Widget content(BuildContext context, Translations tr) {
    return Text(message);
  }

  List<Widget> actions(BuildContext context, Translations tr) {
    return [
      FilledButton.tonal(
        onPressed: () => Navigator.pop(context, false),
        child: Text(tr.cancel_title),
      ),
      OutlinedButton(
        onPressed: () => Navigator.pop(context, true),
        child: Text(tr.confirm_title),
      ),
    ];
  }
}
