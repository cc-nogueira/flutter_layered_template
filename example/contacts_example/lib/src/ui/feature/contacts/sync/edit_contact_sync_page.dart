import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain.dart';
import '../edit_contact_page.dart';

/// Page for editing a contact in local scope.
///
/// See [EditContactPage].
class EditContactSyncPage extends ConsumerWidget {
  /// Const constructor.
  const EditContactSyncPage({super.key, required this.id});

  /// [Contact.id] page parameter.
  final int id;

  /// Build the page with an internal widget [_EditContactPage].
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contact = ref.watch(contactSyncProvider(id));
    return EditContactPage(original: contact);
  }
}
