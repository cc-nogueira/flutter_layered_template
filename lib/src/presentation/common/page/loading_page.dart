import 'package:flutter/material.dart';

import '../widget/loading_widget.dart';

/// Simple loading page.
///
/// Presents a scaffold page with title and a circular progress indicator.
class LoadingPage extends StatelessWidget {
  /// Const constructor with title
  const LoadingPage(this.title, {super.key});

  /// builder helper function for AsyncValue loading callback.
  static Widget Function() builder(String title) => () => LoadingPage(title);

  /// Page title
  final String title;

  /// Build a scaffold with given title and a LoadingWidget.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const LoadingWidget(),
    );
  }
}
