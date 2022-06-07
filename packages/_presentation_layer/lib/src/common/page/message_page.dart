import 'package:flutter/material.dart';

import '../../l10n/translations.dart';
import '../widget/message_widget.dart';

/// Simple message page.
///
/// Presents a scaffold page with title and a centralized message.
class MessagePage extends StatelessWidget {
  /// Const constructor with title and message.
  const MessagePage({super.key, required this.title, required this.message});

  /// Page title.
  final String title;

  /// Page message.
  final String message;

  /// Build a scaffold with given title and a MessageWidget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: MessageWidget(message),
    );
  }
}

/// Simple error message page.
///
/// Presents a scaffold page with title and a centralized error message.
class ErrorMessagePage extends StatelessWidget {
  /// Const constructor with an Error object.
  const ErrorMessagePage(this.error, {super.key});

  /// Factory helper constructor for AsyncValue error callback.
  factory ErrorMessagePage.errorBuilder(Object error, StackTrace? stackTrace) =>
      ErrorMessagePage(error);

  /// Error object.
  final Object error;

  /// Returns a MessagePage with translated Error page title showing the given
  /// error as the message content.
  @override
  Widget build(BuildContext context) {
    return MessagePage(
      title: Translations.of(context)!.title_error_page,
      message: error.toString(),
    );
  }
}
