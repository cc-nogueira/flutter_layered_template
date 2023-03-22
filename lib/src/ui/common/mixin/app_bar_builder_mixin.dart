import 'package:flutter/material.dart';

/// Mixin for [AppBar] with action button building.
mixin AppBarBuilderMixin {
  /// Returns an [AppBar] with an widget set on [AppBar.actions] attribute.
  ///
  /// Has convenient flags to show this action widget or not.
  /// And to set padding right value (default to 20.0).
  AppBar appBarWithActionButton(
      {required bool showButton, required Widget? button, Widget? title, double paddingRight = 20.0}) {
    return AppBar(
      title: title,
      actions: button == null || !showButton ? null : [_paddingRight(paddingRight, child: button)],
    );
  }

  /// Internal function to create optional padding.
  Widget _paddingRight(double paddingRight, {required Widget child}) {
    if (paddingRight == 0) {
      return child;
    }
    return Padding(
      padding: EdgeInsets.only(right: paddingRight),
      child: child,
    );
  }
}
