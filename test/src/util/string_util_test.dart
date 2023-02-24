import 'package:flutter_layered_template/src/domain/util/string_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const emptyString = '';
  const oneLetterString = 'a';
  const oneLetterCapString = 'A';
  const twoLettersString = 'ab';
  const twoLettersCapString = 'Ab';
  const twoLettersSpaceFirstString = ' a';
  const twoLettersSpaceFirstCapString = ' a';
  const twoLettersSpaceLastString = 'a ';
  const twoLettersSpaceLastCapString = 'A ';
  const manyWordsString = 'aBc def Ghi';
  const manyWordsCapString = 'ABc def Ghi';
  const manyWordsSpaceFirstString = ' abc DeF ghi';
  const manyWordsSpaceFirstCapString = ' abc DeF ghi';

  group('cut a string', () {
    test('when cutting and empty string it should return empty', () {
      expect(emptyString.cut(max: 2), '');
    });

    test('when cutting zero length it should return empty', () {
      expect(emptyString.cut(max: 0), '');
      expect(twoLettersSpaceFirstString.cut(max: 0), '');
      expect(twoLettersSpaceLastString.cut(max: 0), '');
      expect(manyWordsSpaceFirstString.cut(max: 0), '');
    });

    test('when cutting more then length it should keep the original content', () {
      expect(oneLetterString.cut(max: 2), oneLetterString);
      expect(oneLetterString.cut(max: 9), oneLetterString);
      expect(twoLettersSpaceFirstString.cut(max: 9), twoLettersSpaceFirstString);
    });

    test('when cutting the length it should keep the original content', () {
      expect(emptyString.cut(max: 0), emptyString);
      expect(oneLetterString.cut(max: 1), oneLetterString);
      expect(twoLettersString.cut(max: 2), twoLettersString);
      expect(twoLettersSpaceFirstString.cut(max: 2), twoLettersSpaceFirstString);
      expect(twoLettersSpaceLastString.cut(max: 2), twoLettersSpaceLastString);
      expect(manyWordsString.cut(max: manyWordsString.length), manyWordsString);
      expect(manyWordsSpaceFirstString.cut(max: manyWordsSpaceFirstString.length), manyWordsSpaceFirstString);
    });

    test('when cutting it should return the required start of the string', () {
      expect(twoLettersString.cut(max: 1), twoLettersString[0]);
      expect(twoLettersSpaceFirstString.cut(max: 1), ' ');
      expect(twoLettersSpaceLastString.cut(max: 1), twoLettersSpaceLastString[0]);
      expect(manyWordsString.cut(max: 3), manyWordsString.substring(0, 3));
      expect(manyWordsSpaceFirstString.cut(max: 5), manyWordsSpaceFirstString.substring(0, 5));
    });
  });

  group('Capitalize strings', () {
    test('when capitalize a empty string should return empty', () {
      expect(emptyString.capitalized, emptyString);
    });

    test('when capitalized the first letter must be converted to upper case', () {
      expect(oneLetterString.capitalized, oneLetterCapString);
      expect(twoLettersString.capitalized, twoLettersCapString);
      expect(twoLettersSpaceFirstString.capitalized, twoLettersSpaceFirstCapString);
      expect(twoLettersSpaceLastString.capitalized, twoLettersSpaceLastCapString);
      expect(manyWordsString.capitalized, manyWordsCapString);
      expect(manyWordsSpaceFirstString.capitalized, manyWordsSpaceFirstCapString);
    });

    test('when capitalized an already capitalized string it should not change', () {
      expect(oneLetterCapString.capitalized, oneLetterCapString);
      expect(twoLettersCapString.capitalized, twoLettersCapString);
      expect(twoLettersSpaceFirstCapString.capitalized, twoLettersSpaceFirstCapString);
      expect(twoLettersSpaceLastCapString.capitalized, twoLettersSpaceLastCapString);
      expect(manyWordsCapString.capitalized, manyWordsCapString);
      expect(manyWordsSpaceFirstCapString.capitalized, manyWordsSpaceFirstCapString);
    });
  });
}
