import 'dart:math';

/// String extensions.
///
/// Provide utility implementatino for String.
extension StringUtils on String {
  /// Cut a string to a max length.
  ///
  /// Returns a String with a maximum number of characters.
  String cut({required int max}) {
    if (isEmpty || max < 1) return '';
    final cut = min(length, max);
    return substring(0, cut);
  }

  /// Capitalize a String.
  ///
  /// This method does not trim before turning the first letter for capital case.
  /// Returns a string capitalized on its first letter.
  String get capitalized => length > 0 ? '${this[0].toUpperCase()}${substring(1)}' : '';
}
