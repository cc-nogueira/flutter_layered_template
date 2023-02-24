import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain.dart';
import '../../common/page/edit_in_local_scope_page.dart';
import '../../l10n/translations.dart';
import 'widget/avatar_editor.dart';
import 'widget/contact_name_and_about_editor.dart';

/// Page for editing a contact in local scope.
///
/// The page will display a AppBar save when button when the contact is modified.
///
/// It uses the [SaveScaffold] component to build the [WillPopScope] guard and a [AppBar]
/// with a save button.
class EditContactPage extends EditInLocalScopePage<Contact> {
  /// Constructor.
  EditContactPage({super.key, required super.original});

  @override
  Widget title(BuildContext contex, Translations tr) {
    return Text(tr.contact_title);
  }

  @override
  Widget formContent(BuildContext context, WidgetRef ref, Translations tr) {
    return ListView(
      children: [
        AvatarEditor(editionProvider),
        const Divider(thickness: 2),
        ContactNameAndAboutEditor(editionProvider, original: original),
      ],
    );
  }

  @override
  bool save(WidgetRef ref) {
    final useCase = ref.read(contactsSyncUseCaseProvider);
    useCase.save(ref.read(editionProvider));
    return true;
  }
}
