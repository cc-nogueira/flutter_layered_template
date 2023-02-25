import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../domain.dart';
import '../../../app/route/routes.dart';
import '../../../l10n/translations.dart';
import 'thing_avatar.dart';

/// Consumer widget that watches [thingsNotifierProvider] to show the list of stored [Thing]s.
class ThingsListView extends ConsumerWidget {
  /// Const constructor.
  const ThingsListView({super.key});

  /// Show a list of [Thing] cards.
  ///
  /// If the observed list is empty shows a "nothing stored" message.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = Translations.of(context);
    final things = ref.watch(thingsProvider);
    return things.isEmpty ? _noThingStoredMessage(context, tr) : _thingsList(context, ref, tr, things);
  }

  /// When there is nothing stored.
  Widget _noThingStoredMessage(BuildContext context, Translations tr) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 32.0),
      child: Text(tr.nothing_stored_message, style: Theme.of(context).textTheme.headlineSmall),
    );
  }

  /// An expanded list of [Thing] tiles.
  Widget _thingsList(BuildContext context, WidgetRef ref, Translations tr, List<Thing> things) {
    final colors = Theme.of(context).colorScheme;
    return Expanded(
      child: ListView.builder(
        itemCount: things.length,
        itemBuilder: (context, index) => _tile(context, ref, colors, things[index]),
      ),
    );
  }

  /// Build a [Thing] tile with Avatar, Name and Delete button.
  Widget _tile(BuildContext context, WidgetRef ref, ColorScheme colors, Thing thing) {
    return Card(
      child: ListTile(
        leading: ThingAvatar(thing),
        title: Text(thing.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: Icon(Icons.edit, color: colors.primary), onPressed: () => _editThing(context, thing)),
            IconButton(icon: Icon(Icons.delete, color: colors.error), onPressed: () => _remove(ref, thing)),
          ],
        ),
      ),
    );
  }

  /// Handler to navigate to edition page.
  void _editThing(BuildContext context, Thing thing) {
    context.goNamed(Routes.editThing, params: {'id': thing.id.toString()});
  }

  /// Handler to remove a contact invoking [ThingsUseCase.remove].
  void _remove(WidgetRef ref, Thing contact) => ref.read(thingsUseCaseProvider).remove(contact.id!);
}
