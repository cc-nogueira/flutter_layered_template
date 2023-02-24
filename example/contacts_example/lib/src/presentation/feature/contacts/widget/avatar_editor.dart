import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../domain_layer.dart';
import '../../../app/theme/themes.dart';
import '../../../l10n/translations.dart';
import 'avatar.dart';

/// Avatar editor to modify a contact avatar color.
///
/// Color changes to the local contact being edited are seen immediately
/// in the displayed centralized avatar.
class AvatarEditor extends ConsumerWidget {
  /// Const constructor.
  const AvatarEditor(this.editionProvider, {super.key});

  /// Local contact being edited provider.
  final StateProvider<Contact> editionProvider;

  /// Build the widget that looks like a row with:
  ///   'Avatar:' title
  ///   The rendered avatar.
  ///   Panel of color buttons and a theme color option (no specific color option).
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final lightColors = Themes.lightTheme.colorScheme;
    final darkColors = Themes.darkTheme.colorScheme;
    final currentColor = ref.watch(editionProvider.select((value) => value.avatarColor));
    final tr = Translations.of(context);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  _columnOfColorButtons(context, ref, current: currentColor, colors: [
                    lightColors.primaryContainer,
                    lightColors.secondaryContainer,
                    lightColors.tertiaryContainer,
                  ]),
                  const SizedBox(width: 10.0),
                  _columnOfColorButtons(context, ref, current: currentColor, colors: [
                    darkColors.primaryContainer,
                    darkColors.secondaryContainer,
                    darkColors.tertiaryContainer,
                  ]),
                ],
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Flexible(fit: FlexFit.tight, child: SizedBox(width: 20)),
            const Flexible(fit: FlexFit.tight, child: SizedBox(width: 20)),
            Flexible(
              fit: FlexFit.tight,
              child:
                  Center(child: OutlinedButton(onPressed: () => _setColor(ref, null), child: Text(tr.default_title))),
            ),
          ],
        )
      ],
    );
  }

  /// Create a column of buttons that trigger avatar color change.
  Widget _columnOfColorButtons(BuildContext context, WidgetRef ref,
      {required int? current, required List<Color> colors}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        for (final color in colors) _colorButton(ref, colorScheme, color: color, current: current),
      ],
    );
  }

  /// Create on button. Used by [_columnOfColorButtons].
  Widget _colorButton(WidgetRef ref, ColorScheme colors, {required Color color, required int? current}) {
    final isSelected = current == color.value;
    final foreColor = color.computeLuminance() > 0.5 ? Colors.black : Colors.white;
    return SizedBox(
      width: 40,
      child: MaterialButton(
        onPressed: () => _setColor(ref, color),
        color: color,
        child: isSelected ? Icon(Icons.check, size: 20, color: foreColor) : null,
      ),
    );
  }

  /// Handler to change the local contact avatar color.
  void _setColor(WidgetRef ref, Color? color) {
    ref.read(editionProvider.notifier).update((state) => state.copyWith(avatarColor: color?.value));
  }
}
