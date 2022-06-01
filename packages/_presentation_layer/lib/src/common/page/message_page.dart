import 'package:flutter/material.dart';

import '../../l10n/translations.dart';
import '../widget/message_widget.dart';

/// Simple message page.
///
/// Presents a page with title and a centralized message.
class MessagePage extends StatelessWidget {
  const MessagePage({super.key, required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: MessageWidget(message),
    );
  }
}

/// Simple Error Message page.
///
/// Presents a page with a message for an error.
class ErrorMessagePage extends StatelessWidget {
  const ErrorMessagePage(this.error, {super.key});

  factory ErrorMessagePage.errorBuilder(Object error, StackTrace? stackTrace) =>
      ErrorMessagePage(error);

  final Object error;

  @override
  Widget build(BuildContext context) {
    return MessagePage(
      title: Translations.of(context)!.title_error_page,
      message: error.toString(),
    );
  }
}
