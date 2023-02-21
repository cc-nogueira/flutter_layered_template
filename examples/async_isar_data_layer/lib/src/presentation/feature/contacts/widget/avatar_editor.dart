import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain_layer.dart';
import '../../../app/theme/themes.dart';
import 'avatar.dart';

class AvatarEditor extends ConsumerWidget {
  const AvatarEditor(this.editionProvider, {super.key});

  final StateProvider<Contact> editionProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final lightColors = Themes.lightTheme.colorScheme;
    final darkColors = Themes.darkTheme.colorScheme;
    final currentColor = ref.watch(editionProvider.select((value) => value.avatarColor));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Text(
                  'Avatar:',
                  style: textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              Flexible(
                child: Avatar(
                  ref.read(editionProvider),
                  radius: 40.0,
                  textStyle: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        _colorButton(ref, null, colors, current: currentColor),
                        _colorButton(ref, lightColors.secondaryContainer, colors, current: currentColor),
                        _colorButton(ref, lightColors.tertiaryContainer, colors, current: currentColor),
                      ],
                    ),
                    const SizedBox(width: 10.0),
                    Column(
                      children: [
                        _colorButton(ref, darkColors.primaryContainer, colors, current: currentColor),
                        _colorButton(ref, darkColors.secondaryContainer, colors, current: currentColor),
                        _colorButton(ref, darkColors.tertiaryContainer, colors, current: currentColor),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _colorButton(WidgetRef ref, Color? color, ColorScheme colors, {required int? current}) {
    final isSelected = current == color?.value;
    final backColor = color ?? Avatar.defaultBackgroundColor(colors);
    final foreColor = backColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    return SizedBox(
      width: 40,
      child: MaterialButton(
        onPressed: () => _setColor(ref, color),
        color: backColor,
        child: isSelected ? Icon(Icons.check, size: 20, color: foreColor) : null,
      ),
    );
  }

  void _setColor(WidgetRef ref, Color? color) {
    ref.read(editionProvider.notifier).update((state) => state.copyWith(avatarColor: color?.value));
  }
}
