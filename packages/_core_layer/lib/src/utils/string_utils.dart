import 'dart:math';

extension StringUtils on String {
  String cut({required int max}) {
    if (isEmpty || max < 1) return '';
    final cut = min(length, max);
    return substring(0, cut);
  }
}
