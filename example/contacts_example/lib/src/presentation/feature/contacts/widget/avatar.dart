import 'package:flutter/material.dart';

import '../../../../core/utils/string_utils.dart';
import '../../../../domain_layer.dart';

/// Avatar widget.
///
/// Display a CircleAvatar in a Hero widget with contact's uuid tag.
/// This way the Avatar is animated between page transitions.
///
/// The avatar has the background color defined in a optional contact property.
/// The foreground colors is either black or white, calculated from the background color.
class Avatar extends StatelessWidget {
  /// Const constructor.
  const Avatar(this.contact, {super.key, this.radius, this.textStyle});

  /// Default background color when the contact does not define a avatar color.
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
    return Hero(
      tag: contact.uuid,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backColor,
        child: Text(contact.name.cut(max: 2), style: style),
      ),
    );
  }

  /// Background color from the contact property or null.
  Color? _backgroundColor() => contact.avatarColor == null ? null : Color(contact.avatarColor!);

  /// Foreground color from the background color.
  ///
  /// Either black or white depending on background luninance.
  Color? _foregroundColor(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }
}
