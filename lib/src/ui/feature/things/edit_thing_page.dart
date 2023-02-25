import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain.dart';
import '../../common/page/save_page.dart';
import '../../l10n/translations.dart';
import 'widget/thing_avatar.dart';
import 'widget/thing_editor_view.dart';

class EditThingPage extends ConsumerWidget {
  /// Const constructor.
  const EditThingPage({super.key, required this.id});

  /// [Contact.id] page parameter.
  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final thing = ref.watch(thingProvider(id));
    return _EditThingPage(original: thing);
  }
}

/// Page for editing a thing in local scope.
///
/// The page will display a AppBar save when button when the contact is modified.
///
/// It uses the [SaveScaffold] component to build the [WillPopScope] guard and a [AppBar]
/// with a save button.
class _EditThingPage extends SavePage<Thing> {
  _EditThingPage({required super.original});

  @override
  Widget title(BuildContext contex, Translations tr) {
    return Text(tr.thing_title);
  }

  @override
  Widget formContent(BuildContext context, WidgetRef ref, Translations tr) {
    final textTheme = Theme.of(context).textTheme;
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          height: 100,
          child: ThingAvatarWatch(editionProvider, style: textTheme.headlineLarge),
        ),
        const Divider(),
        ThingEditor(ref.read(editionProvider.notifier), original: original),
      ],
    );
  }

  @override
  bool save(WidgetRef ref) {
    ref.read(thingsUseCaseProvider).save(ref.read(editionProvider));
    return true;
  }
}
