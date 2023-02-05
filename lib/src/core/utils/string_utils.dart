import 'dart:math';

final titleCaseTrimRegExp = RegExp(r'^\W+');
final titleCaseRegExp = RegExp(r'\w+\W*');

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

  /// Capitalize all words in the string.
  ///
  /// Retunrs a string with all words capitalized.
  String get titleCase {
    final buffer = StringBuffer();
    late final String trimmed;

    final trimMatch = titleCaseTrimRegExp.firstMatch(this);
    if (trimMatch != null) {
      buffer.write(trimMatch.group(0)!);
      trimmed = substring(trimMatch.end);
    } else {
      trimmed = this;
    }

    final matches = titleCaseRegExp.allMatches(trimmed);
    for (final match in matches) {
      buffer.write(match.group(0)!.capitalized);
    }

    return buffer.toString();
  }
}
