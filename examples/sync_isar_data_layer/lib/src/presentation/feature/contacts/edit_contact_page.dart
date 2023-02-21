import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain_layer.dart';
import '../../common/widget/app_bar_builder_mixin.dart';
import '../../common/widget/save_guard_scaffold.dart';
import '../../l10n/translations.dart';
import 'widget/avatar_editor.dart';
import 'widget/contact_name_and_about_editor.dart';

class EditContactPage extends ConsumerWidget {
  /// Const constructor.
  const EditContactPage({super.key, required this.id});

  /// [Contact.id]
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contact = ref.watch(contactProvider(id));
    return _EditContactPage(contact);
  }
}

class _EditContactPage extends ConsumerWidget with AppBarBuilderMixin {
  _EditContactPage(this.original) : editionProvider = StateProvider((ref) => original);

  final Contact original;
  final StateProvider<Contact> editionProvider;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = Translations.of(context);
    final modified = ref.watch(editionProvider.select((value) => value != original));
    return SaveGuardScaffold(
      modified: modified,
      willPopMessage: tr.contact_altered_message,
      saveButtonText: tr.save_title,
      validateAndSave: () => _validateAndSave(ref),
      title: Text(tr.contact_title),
      body: Form(
        key: _formKey,
        child: ListView(
          children: [
            AvatarEditor(editionProvider),
            const Divider(thickness: 2),
            ContactNameAndAboutEditor(editionProvider),
          ],
        ),
      ),
    );
  }

  /// Validate the form (if any) and call the save action.
  ///
  /// This is used by the app bar save button and the [WillPopScope] dialog.
  bool _validateAndSave(WidgetRef ref) {
    if (_validate()) {
      final useCase = ref.read(contactsUseCaseProvider);
      useCase.save(ref.read(editionProvider));
      return true;
    }
    return false;
  }

  /// Validate the form (if any).
  ///
  /// Returns form's validation or true if there is no form.
  bool _validate() {
    final form = _formKey.currentState;
    if (form == null) {
      return true;
    }
    form.save();
    return form.validate();
  }
}
