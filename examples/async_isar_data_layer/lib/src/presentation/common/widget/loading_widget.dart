import 'package:flutter/material.dart';

/// Loading widget.
///
/// Displays a centralized [CircularProgressIndicator].
class LoadingWidget extends StatelessWidget {
  /// Const constructor.
  const LoadingWidget({super.key});

  /// Build a centralized CircularProgressIndicator.
  @override
  Widget build(BuildContext context) => const Center(child: CircularProgressIndicator());
}
