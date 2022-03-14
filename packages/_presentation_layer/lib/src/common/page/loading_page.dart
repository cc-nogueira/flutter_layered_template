import 'package:flutter/material.dart';

/// Simple loading page.
///
/// Presents a page with title and a circular progress indicator.
class LoadingPage extends StatelessWidget {
  const LoadingPage(this.title, {Key? key}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
