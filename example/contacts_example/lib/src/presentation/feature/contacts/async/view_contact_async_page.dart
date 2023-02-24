import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain_layer.dart';
import '../../../app/route/routes.dart';
import '../../../common/page/loading_page.dart';
import '../../../common/page/message_page.dart';
import '../../../common/widget/async_guard_layer.dart';
import '../../../l10n/translations.dart';
import '../widget/avatar.dart';

/// Display a contact and its last pending message.
///
/// [Contact] information is retrieved from [contactStateProvider] for the given id.
/// The display is composed of list with
///   - A large avatar.
///   - Contact's name.
///   - A [MessageWidget] for this contact.
class ViewContactAsyncPage extends ConsumerWidget {
  /// Const constructor.
  const ViewContactAsyncPage({super.key, required this.id});

  /// [Contact.id] page parameter.
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = Translations.of(context);
    return ref.watch(contactAsyncProvider(id)).when(
          loading: () => LoadingPage(tr.contact_title),
          data: (data) => _ContactPage(tr, data),
          error: ErrorMessagePage.errorBuilder,
        );
  }
}

class _ContactPage extends StatelessWidget {
  const _ContactPage(this.tr, this.contact);

  final Translations tr;
  final Contact contact;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: Text(tr.contact_title)),
      body: AsyncGuardLayer(
        asyncGuardProvider: contactsAsyncGuardProvider,
        child: ListView(
          children: [
            _avatar(textTheme),
            _name(colors, textTheme),
            const Divider(thickness: 2),
            _about(textTheme),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => _editContact(context), child: const Icon(Icons.edit)),
    );
  }

  /// Generate the contact avatar with the two first letters of his name.
  Widget _avatar(TextTheme textTheme) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Avatar(
          contact,
          radius: 40.0,
          textStyle: textTheme.headlineMedium,
        ),
      );

  /// Text with contact's name and personality tag.
  Widget _name(ColorScheme colors, TextTheme textTheme) {
    final name = Text(contact.name, style: textTheme.headlineSmall);
    final widget = (contact.isPersonality)
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tr.personality_title,
                style: textTheme.bodyLarge?.copyWith(color: colors.tertiary, fontWeight: FontWeight.bold),
              ),
              name,
            ],
          )
        : name;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: widget,
    );
  }

  /// About text
  Widget _about(TextTheme textTheme) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(contact.about, style: textTheme.bodyLarge),
      );

  /// Navigate contact edition page.
  void _editContact(BuildContext context) {
    context.goNamed(Routes.editContactAsync, params: {'id': contact.id.toString()});
  }
}
