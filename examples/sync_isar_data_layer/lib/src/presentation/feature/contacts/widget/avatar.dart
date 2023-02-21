import 'package:flutter/material.dart';

import '../../../../core/utils/string_utils.dart';
import '../../../../domain_layer.dart';

class Avatar extends StatelessWidget {
  const Avatar(this.contact, {super.key, this.radius, this.textStyle});

  static Color defaultBackgroundColor(ColorScheme colors) => colors.primaryContainer;

  final Contact contact;
  final double? radius;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final backColor = _backgroundColor() ?? defaultBackgroundColor(colors);
    final foreColor = _foregroundColor(backColor);
    final style = textStyle == null ? TextStyle(color: foreColor) : textStyle?.copyWith(color: foreColor);
    return CircleAvatar(
      radius: radius,
      backgroundColor: backColor,
      child: Text(contact.name.cut(max: 2), style: style),
    );
  }

  Color? _backgroundColor() => contact.avatarColor == null ? null : Color(contact.avatarColor!);

  Color? _foregroundColor(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
}
