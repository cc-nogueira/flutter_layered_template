import 'package:flutter/material.dart';

/// Simple message page.
///
/// Presents a page with title and a centralized message.
class MessagePage extends StatelessWidget {
  const MessagePage({
    Key? key,
    required this.title,
    required this.message,
  }) : super(key: key);

  factory MessagePage.error(Object error) =>
      MessagePage(title: 'Error', message: error.toString());

  factory MessagePage.errorBuilder(Object error, StackTrace? stackTrace) =>
      MessagePage.error(error);

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(message, style: Theme.of(context).textTheme.headline5),
      ),
    );
  }
}
