import 'dart:math';

import 'package:flutter/services.dart';

mixin TextInputKeyFormatter {
  static final _keyRegExp = RegExp(r'[_a-zA-Z]\w*');
  static final _wordRegExp = RegExp(r'\w+');

  TextInputFormatter get textInputKeyFormatter => TextInputFormatter.withFunction(_keyFormatterFunction);

  TextEditingValue _keyFormatterFunction(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final match = _keyRegExp.firstMatch(text);
    if (match == null) return oldValue;
    if (match.start == 0 && match.end == text.length) return newValue;

    final prefix = match.group(0)!;
    final leftTrim = match.start;
    final prefixEnd = leftTrim + prefix.length;
    final remain = text.substring(prefixEnd);

    final valueBuffer = StringBuffer(prefix);
    final matches = _wordRegExp.allMatches(remain);
    var moreTrim = 0;
    var prevEnd = 0;
    for (final match in matches) {
      if (prefixEnd + match.start <= newValue.selection.baseOffset) {
        moreTrim += match.start - prevEnd;
        prevEnd = match.end;
      }
      valueBuffer.write(match.group(0)!);
    }

    final newText = valueBuffer.toString();
    final baseOffset = max(
      min(newValue.selection.baseOffset - leftTrim - moreTrim, newText.length),
      0,
    );
    final newSelection = TextSelection(baseOffset: baseOffset, extentOffset: baseOffset);
    return TextEditingValue(text: newText, selection: newSelection);
  }
}

mixin TextInputPublicVariableFormatter {
  static final _publicVariableRegExp = RegExp(r'[a-zA-Z]\w*');
  static final _wordRegExp = RegExp(r'\w+');

  TextInputFormatter get textInputPublicVariableFormatter =>
      TextInputFormatter.withFunction(_publicVariableFormatterFunction);

  TextEditingValue _publicVariableFormatterFunction(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.isEmpty) return newValue;

    final match = _publicVariableRegExp.firstMatch(text);
    if (match == null) return oldValue;
    if (match.start == 0 && match.end == text.length) return newValue;

    final prefix = match.group(0)!;
    final leftTrim = match.start;
    final prefixEnd = leftTrim + prefix.length;
    final remain = text.substring(prefixEnd);

    final valueBuffer = StringBuffer(prefix);
    final matches = _wordRegExp.allMatches(remain);
    var moreTrim = 0;
    var prevEnd = 0;
    for (final match in matches) {
      if (prefixEnd + match.start <= newValue.selection.baseOffset) {
        moreTrim += match.start - prevEnd;
        prevEnd = match.end;
      }
      valueBuffer.write(match.group(0)!);
    }

    final newText = valueBuffer.toString();
    final baseOffset = max(
      min(newValue.selection.baseOffset - leftTrim - moreTrim, newText.length),
      0,
    );
    final newSelection = TextSelection(baseOffset: baseOffset, extentOffset: baseOffset);
    return TextEditingValue(text: newText, selection: newSelection);
  }
}
