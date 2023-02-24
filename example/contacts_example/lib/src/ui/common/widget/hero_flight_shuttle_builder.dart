import 'package:flutter/material.dart';

/// Function to provide a Hero container to be used during the flight animation.
///
/// This container ensures the contenxt won't be trimmed during flight by wrapping the hero content
/// inside a FittedBox.
Widget heroFittedWidthFlightShuttleBuilder(
  BuildContext _,
  Animation<double> __,
  HeroFlightDirection ___,
  BuildContext ____,
  BuildContext toContext,
) =>
    FittedBox(fit: BoxFit.fitWidth, child: toContext.widget);

/// Function to provide a Hero container to be used during the flight animation.
///
/// This container ensures the contenxt won't be trimmed during flight by wrapping the hero content
/// inside a FittedBox.
Widget heroFittedHeightFlightShuttleBuilder(
  BuildContext _,
  Animation<double> __,
  HeroFlightDirection ___,
  BuildContext ____,
  BuildContext toContext,
) =>
    FittedBox(fit: BoxFit.fitHeight, child: toContext.widget);

/// Function to control title display during the flight animation.
///
/// This function changes mid flight from source to destination widgets.
Widget heroTitleFlightShuttleBuilder(
  BuildContext _,
  Animation<double> animation,
  HeroFlightDirection __,
  BuildContext fromContext,
  BuildContext toContext,
) =>
    animation.value < 0.5 ? fromContext.widget : toContext.widget;

HeroFlightShuttleBuilder heroDefaultStyleFlightShuttleBuilder(TextStyle style) =>
    (BuildContext _, Animation<double> __, HeroFlightDirection ___, BuildContext ____, BuildContext toContext) =>
        DefaultTextStyle(style: style, child: toContext.widget);
