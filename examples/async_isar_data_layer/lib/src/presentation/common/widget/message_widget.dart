import 'package:flutter/material.dart';

/// Message widget shows a centralized message.
///
/// Displays a centralized message with default headlineSmall style.
class MessageWidget extends StatelessWidget {
  /// Const constructor.
  const MessageWidget(this.message, {super.key, this.style});

  /// Message to display
  final String message;

  /// Optional text style (defaults to headlineSmall).
  final TextStyle? style;

  /// Build a centralized message with default text style.
  @override
  Widget build(BuildContext context) => Center(
        child: Text(
          message,
          style: style ?? Theme.of(context).textTheme.headlineSmall,
        ),
      );
}
