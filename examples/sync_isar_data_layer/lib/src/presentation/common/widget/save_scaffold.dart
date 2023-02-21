import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app_bar_builder_mixin.dart';
import 'confirm_discard_changes_dialog.dart';

class SaveScaffold extends StatelessWidget with AppBarBuilderMixin {
  const SaveScaffold({
    super.key,
    required this.modified,
    required this.willPopMessage,
    required this.saveButtonText,
    required this.validateAndSave,
    required this.title,
    required this.body,
  });

  final bool modified;
  final Widget title;
  final String willPopMessage;
  final String saveButtonText;
  final bool Function() validateAndSave;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => confirmCanPop(
        context: context,
        message: willPopMessage,
        onSave: validateAndSave,
        modified: modified,
      ),
      child: Scaffold(
        appBar: appBarWithActionButton(
          title: title,
          button: _saveButton(context),
          showButton: modified,
        ),
        body: body,
      ),
    );
  }

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
