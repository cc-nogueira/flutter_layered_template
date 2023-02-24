import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../l10n/translations.dart';
import '../widget/save_scaffold.dart';

/// Page for editing in local scope.
///
/// The page will display a AppBar save when button when the contact is modified.
///
/// It uses the [SaveScaffold] component to build the [WillPopScope] guard and a [AppBar]
/// with a save button.
abstract class EditInLocalScopePage<T> extends ConsumerWidget {
  /// Constructor.
  EditInLocalScopePage({super.key, required this.original}) : editionProvider = StateProvider((ref) => original);

  /// Original value.
  final T original;

  /// Provider for the value being edited.
  final StateProvider<T> editionProvider;

  /// Provider that informs if the edited value is different from the original.
  late final Provider<bool> modifiedProvider = Provider(
    (ref) => ref.watch(editionProvider.select((value) => value != original)),
  );

  /// Form key.
  final _formKey = GlobalKey<FormState>();

  /// Scaffold title
  Widget title(BuildContext contex, Translations tr);

  /// Content for page's form.
  Widget formContent(BuildContext context, WidgetRef ref, Translations tr);

  /// Save handler to invoked after validation.
  ///
  /// Should return whether save was successful and the page can be popped.
  bool save(WidgetRef ref);

  /// Build the formContent inside a [SaveScaffold] in a [WillPopScope].
  ///
  /// These containers are configured for Form validation with handlers to save and discard actions.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = Translations.of(context);
    return SaveScaffold(
      modifiedProvider: modifiedProvider,
      willPopMessage: tr.save_or_discard_changes_message,
      saveButtonText: tr.save_title,
      validateAndSave: () => validateAndSave(ref),
      title: title(context, tr),
      body: Form(
        key: _formKey,
        child: formContent(context, ref, tr),
      ),
    );
  }

  /// Validate the form and call the save action.
  ///
  /// This is used by the app bar save button and the [WillPopScope] dialog.
  bool validateAndSave(WidgetRef ref) {
    if (validate()) {
      return save(ref);
    }
    return false;
  }

  /// Validate the form.
  bool validate() {
    final form = _formKey.currentState;
    form?.save();
    return form?.validate() ?? false;
  }
}
