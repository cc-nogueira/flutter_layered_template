import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../mixin/app_bar_builder_mixin.dart';
import 'confirm_discard_changes_dialog.dart';

/// Builds a Scaffold in a [WillPopScope] with a [appBarWithActionButton].
///
/// The WillPopScope contains a hook to check the [modifiedProvider] and ask save confirmation if that is true.
/// The app bar contains a save button that is rendered by watching the [modifiedProvider].
class SaveScaffold extends ConsumerWidget with AppBarBuilderMixin {
  /// Const constructor.
  const SaveScaffold({
    super.key,
    required this.modifiedProvider,
    required this.willPopMessage,
    required this.saveButtonText,
    required this.validateAndSave,
    required this.title,
    required this.body,
  });

  /// Provider to flag when the body is modified.
  final Provider<bool> modifiedProvider;

  /// App bar title
  final Widget title;

  /// Message for the [WillPopScope] confimation popup.
  final String willPopMessage;

  /// Text for the app bar save button.
  final String saveButtonText;

  /// Callback to validate and save the body.
  ///
  /// This callback is invoked when the user activates the save action in the button or confirmation dialog.
  final bool Function() validateAndSave;

  /// Body of the [Scaffold].
  final Widget body;

  /// Builds a Scaffold in a [WillPopScope] with a [appBarWithActionButton].
  ///
  /// The WillPopScope contains a hook to check the [modifiedProvider] and ask save confirmation if that is true.
  /// The app bar contains a save button that is rendered by watching the [modifiedProvider].
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () => confirmCanPop(
        context: context,
        message: willPopMessage,
        onSave: validateAndSave,
        modified: ref.read(modifiedProvider),
      ),
      child: Scaffold(
        appBar: appBarWithActionButton(
          title: title,
          button: _saveButton(context),
          showButton: ref.watch(modifiedProvider),
        ),
        body: body,
      ),
    );
  }

  /// AppBar save button.
  ///
  /// Invoke [validateAndSave] callback and pop the context on success.
  Widget _saveButton(BuildContext context) {
    return FilledButton(
      onPressed: () {
        if (validateAndSave()) {
          GoRouter.of(context).pop();
        }
      },
      child: Text(saveButtonText),
    );
  }
}
