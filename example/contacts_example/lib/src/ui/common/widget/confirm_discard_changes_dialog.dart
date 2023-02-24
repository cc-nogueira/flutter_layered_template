import 'package:flutter/material.dart';

import '../../l10n/translations.dart';
import 'confirm_dialog.dart';

/// Shows the Discard or Save dialog with a message to confirm the page can pop out.
///
/// Returns TRUE if the user tap the DISCARD button.
/// Returns FALSE if the user dismiss the dialog without tapping either button.
/// Returns the result of [onSave] if the user selects the SAVE button.
Future<bool> confirmCanPop({
  required BuildContext context,
  required bool Function() onSave,
  required String message,
  required bool modified,
}) async {
  if (!modified) {
    /// pop is OK!
    return Future.value(true);
  }

  final discard = await showConfirmDiscardChangesDialog(context: context, message: message);
  if (discard == true) {
    /// tap on discard: canPop!
    return true;
  }
  if (discard == false) {
    /// tap on save: return the onSave result for canPop.
    return onSave();
  }

  /// dismissed the dialog without tapping any button: don't pop, return to dialog!
  return false;
}

/// Shows a dialog that has three return values:
///
/// TRUE for DISCARD button.
/// FALSE for SAVE button.
/// NULL for dialog dismiss.
Future<bool?> showConfirmDiscardChangesDialog({required BuildContext context, required String message}) async {
  return showDialog<bool>(
    context: context,
    builder: (_) => _ConfirmDiscardChangesDialog(message: message),
  );
}

/// Shows a dialog with a save or discard message and two buttons.
///
/// The dialog closes returning one of three values:
///
/// TRUE for DISCARD button.
/// FALSE for SAVE button.
/// NULL for dialog dismiss.
class _ConfirmDiscardChangesDialog extends ConfirmDialog {
  const _ConfirmDiscardChangesDialog({required super.message});

  /// Actions are Discard and Save buttons.
  @override
  List<Widget> actions(BuildContext context, Translations tr) {
    return [
      FilledButton.tonal(
        onPressed: () => Navigator.pop(context, true),
        child: Text(tr.discard_title),
      ),
      OutlinedButton(
        onPressed: () => Navigator.pop(context, false),
        child: Text(tr.save_title),
      ),
    ];
  }
}
