import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain_layer.dart';
import '../../common/page/loading_page.dart';
import '../../common/page/message_page.dart';
import '../../common/widget/save_scaffold.dart';
import '../../l10n/translations.dart';
import 'widget/avatar_editor.dart';
import 'widget/contact_name_and_about_editor.dart';

/// Page for editing a contact in local scope.
///
/// See [_EditContactPage].
class EditContactPage extends ConsumerWidget {
  /// Const constructor.
  const EditContactPage({super.key, required this.id});

  /// [Contact.id] page parameter.
  final int id;

  /// Build the page with an internal widget [_EditContactPage].
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = Translations.of(context);
    return ref.watch(contactProvider(id)).when(
          loading: () => LoadingPage(tr.contact_title),
          data: (contact) => _EditContactPage(tr, contact),
          error: ErrorMessagePage.errorBuilder,
        );
  }
}

/// Page for editing a contact in local scope.
///
/// The page will display a AppBar save when button when the contact is modified.
///
/// It uses the [SaveScaffold] component to build the [WillPopScope] guard and a [AppBar]
/// with a save button.
class _EditContactPage extends ConsumerWidget {
  /// Constructor
  _EditContactPage(this.tr, this.original) : _editionProvider = StateProvider((ref) => original);

  /// Translations
  final Translations tr;

  /// Original contact
  final Contact original;

  /// Provider for the contact being edited.
  final StateProvider<Contact> _editionProvider;

  /// Provider that informs if the edited contact is different from the original.
  late final Provider<bool> _modifiedProvider = Provider(
    (ref) => ref.watch(_editionProvider.select((value) => value != original)),
  );

  /// Form key.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SaveScaffold(
      modifiedProvider: _modifiedProvider,
      willPopMessage: tr.contact_altered_message,
      saveButtonText: tr.save_title,
      validateAndSave: () => _validateAndSave(ref),
      title: Text(tr.contact_title),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            AvatarEditor(_editionProvider),
            const Divider(thickness: 2),
            ContactNameAndAboutEditor(_editionProvider),
          ],
        ),
      ),
    );
  }

  /// Validate the form and call the save action.
  ///
  /// This is used by the app bar save button and the [WillPopScope] dialog.
  /// Note that use case save action is async, but since this method does not use the
  /// saved return value it returns the result of having invoked the save action.
  bool _validateAndSave(WidgetRef ref) {
    if (_validate()) {
      final useCase = ref.read(contactsUseCaseProvider);
      useCase.save(ref.read(_editionProvider));
      return true;
    }
    return false;
  }

  /// Validate the form.
  bool _validate() {
    final form = _formKey.currentState;
    form?.save();
    return form?.validate() ?? false;
  }
}
