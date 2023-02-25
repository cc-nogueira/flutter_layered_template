
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain.dart';

class ThingAvatar extends StatelessWidget {
  const ThingAvatar(this.thing, {super.key, this.style});

  final Thing thing;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'thingAvatar_${thing.id!}',
      child: CircleAvatar(
        child: Text(thing.name.cut(max: 2), style: style),
      ),
    );
  }
}

class ThingAvatarWatch extends ConsumerWidget {
  /// Const constructor.
  const ThingAvatarWatch(this.thingProvider, {super.key, this.style});

  final ProviderBase<Thing> thingProvider;
  final TextStyle? style;

  /// Will only rebuild if the avatar text changes!
  ///
  /// Watches the first two letters and reads the whole [Thing].
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(thingProvider.select((value) => value.name.cut(max: 2)));
    final thing = ref.read(thingProvider);
    return ThingAvatar(thing, style: style);
  }
}
