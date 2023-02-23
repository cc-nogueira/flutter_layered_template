import 'dart:math';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain_layer.dart';
import '../../l10n/translations.dart';
import 'widget/otherthing_widget.dart';
import 'widget/things_list_view.dart';

/// Things page.
///
/// Display remote service content on top and bellow it a [ThingsListView].
/// Shows a floating button to add pseudo random things.
class ThingsPage extends ConsumerWidget {
  /// Constructor.
  ThingsPage({super.key});

  /// For random things creation.
  final random = Random();

  /// Display remote service content on top and bellow it a [ThingsListView].
  ///
  /// Shows a floating button to add pseudo random things.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tr = Translations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(tr.things_title)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            OtherthingWidget(),
            ThingsListView(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => _addSomething(ref),
      ),
    );
  }

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
