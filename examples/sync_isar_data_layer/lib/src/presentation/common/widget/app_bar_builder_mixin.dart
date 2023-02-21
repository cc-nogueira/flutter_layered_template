import 'package:flutter/material.dart';

mixin AppBarBuilderMixin {
  /// Returns an [AppBar] with an widget set on [AppBar.actions] attribute.
  ///
  /// Has convenient flags to show this action widget or not.
  /// And to set padding right value (default to 20.0).
  AppBar appBarWithActionButton(
      {Widget? title, required Widget? button, double? paddingRight = 20.0, bool showButton = true}) {
    return AppBar(
      title: title,
      actions: button == null || !showButton ? null : [_paddingRight(paddingRight, child: button)],
    );
  }

  /// Internal function to create optional padding.
  Widget _paddingRight(double? paddingRight, {required Widget child}) {
    if (paddingRight == null || paddingRight == 0) {
      return child;
    }
    return Padding(
      padding: EdgeInsets.only(right: paddingRight),
      child: child,
    );
  }
}
