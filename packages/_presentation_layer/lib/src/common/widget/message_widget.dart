import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget(this.message, {Key? key}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) => Center(
        child: Text(message, style: Theme.of(context).textTheme.headline5),
      );
}
