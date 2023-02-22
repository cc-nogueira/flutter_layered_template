import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/util/string_utils.dart';
import '../../../domain_layer.dart';
import '../../l10n/translations.dart';
import 'widget/otherthing_widget.dart';

/// Things page.
///
/// Display the list of [Thing]s from [thingsNotifierProvider] and a floating button
/// to add pseudo random things.
///
/// This consumer widget watches the list of things and rebuilds when the list changes.
class ThingsPage extends ConsumerWidget {
  /// Constructor.
  ThingsPage({super.key});

  /// For random things creation.
  final random = Random();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = Translations.of(context);
    final things = ref.watch(thingsNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: Text(tr.things_title)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const OtherthingWidget(),
            things.isEmpty ? _buildNoThingStoredMessage(context, tr) : _buildThingsList(context, ref, tr, things)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _addSomething(ref),
      ),
    );
  }

  /// When there is nothing stored.
  Widget _buildNoThingStoredMessage(BuildContext context, Translations tr) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 32.0),
      child: Text(tr.nothing_stored_message, style: Theme.of(context).textTheme.headlineSmall),
    );
  }

  /// List of [_ThingTile] items.
  Widget _buildThingsList(BuildContext context, WidgetRef ref, Translations tr, List<Thing> things) {
    final colors = Theme.of(context).colorScheme;
    return Expanded(
      child: ListView.builder(
        itemCount: things.length,
        itemBuilder: (context, index) => _tile(ref, colors, things[index]),
      ),
    );
  }

  /// Build a [Thing] tile with Avatar, Name and Delete button.
  Widget _tile(WidgetRef ref, ColorScheme colors, Thing thing) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(thing.name.cut(max: 2))),
        title: Text(thing.name),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: colors.error),
          onPressed: () => _remove(ref, thing),
        ),
      ),
    );
  }

  /// Handler to remove a contact invoking [ThingsUseCase.remove].
  void _remove(WidgetRef ref, Thing contact) => ref.read(thingsUseCaseProvider).remove(contact.id!);

  /// Handler to add something.
  Thing _addSomething(WidgetRef ref) => ref.read(thingsUseCaseProvider).save(_createSomething());

  /// Creates something for example purposes.
  Thing _createSomething() {
    final rand = random.nextInt(3);
    return Thing(
      name: rand == 0
          ? faker.animal.name()
          : rand == 1
              ? faker.sport.name()
              : faker.food.dish(),
    );
  }
}
