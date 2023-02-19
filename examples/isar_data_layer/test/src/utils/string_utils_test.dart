import 'package:flutter_layered_template_isar_persistence/src/core/utils/string_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const empty = '';
  const notTrimmed = ' not trimmed ';
  const singleLetter = 'x';
  const singleUpperLetter = 'X';
  const oneWord = 'word';
  const oneWordCapitalized = 'Word';
  const oneWordAllUpper = 'WORD';
  const fraseWithSingleLetterFirst = 'a frase with a single letter first';
  const fraseWithSingleLetterCapitalized = 'A frase with a single letter first';
  const frase = 'flutter and smalltalk! Java and javascript. What a comparisson?!';
  const fraseCapitalized = 'Flutter and smalltalk! Java and javascript. What a comparisson?!';

  group('String utils capitalize', () {
    test('capitalize an empty string', () {
      expect(empty.capitalized, empty);
    });

    test('capitalize should not trim before execution', () {
      expect(notTrimmed.capitalized, notTrimmed);
    });

    test('single letter should capitalize', () {
      expect(singleLetter.capitalized, singleUpperLetter);
    });

    test('one word should capitalize', () {
      expect(oneWord.capitalized, oneWordCapitalized);
      expect(oneWordCapitalized.capitalized, oneWordCapitalized);
    });

    test('should not turn any letter to lowercase', () {
      expect(oneWordAllUpper.capitalized, oneWordAllUpper);
    });

    test('should capitalize when first word is just one letter', () {
      expect(fraseWithSingleLetterFirst.capitalized, fraseWithSingleLetterCapitalized);
      expect(fraseWithSingleLetterCapitalized.capitalized, fraseWithSingleLetterCapitalized);
    });

    test('should capitalize frases', () {
      expect(frase.capitalized, fraseCapitalized);
      expect(fraseCapitalized.capitalized, fraseCapitalized);
    });
  });
}
