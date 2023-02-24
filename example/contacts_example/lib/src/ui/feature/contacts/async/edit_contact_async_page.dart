import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain.dart';
import '../../../common/page/loading_page.dart';
import '../../../common/page/message_page.dart';
import '../../../l10n/translations.dart';
import '../edit_contact_page.dart';

/// Page for editing a contact in local scope.
///
/// See [_EditContactPage].
class EditContactAsyncPage extends ConsumerWidget {
  /// Const constructor.
  const EditContactAsyncPage({super.key, required this.id});

  /// [Contact.id] page parameter.
  final int id;

  /// Build the page with an internal widget [_EditContactPage].
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = Translations.of(context);

    return ref.watch(contactAsyncProvider(id)).when(
          loading: () => LoadingPage(tr.contact_title),
          data: (contact) => EditContactPage(original: contact),
          error: ErrorMessagePage.errorBuilder,
        );
  }
}
