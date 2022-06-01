import 'package:_core_layer/string_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const empty = '';
  const notTrimmed = ' not trimmed ';
  const notTrimmedTitleCase = ' Not Trimmed ';
  const singleLetter = 'x';
  const singleUpperLetter = 'X';
  const oneWord = 'word';
  const oneWordCapitalized = 'Word';
  const oneWordAllUpper = 'WORD';
  const fraseWithSingleLetterFirst = 'a frase with a single letter first';
  const fraseWithSingleLetterCapitalized = 'A frase with a single letter first';
  const fraseWithSingleLetterTitleCase = 'A Frase With A Single Letter First';
  const frase = 'flutter and smalltalk! Java and javascript. What a comparisson?!';
  const fraseCapitalized = 'Flutter and smalltalk! Java and javascript. What a comparisson?!';
  const fraseInTitleCase = 'Flutter And Smalltalk! Java And Javascript. What A Comparisson?!';
  const fraseWithSpaces = ' a frase  with  strange   spacing  ';
  const fraseWithSpacesTitleCase = ' A Frase  With  Strange   Spacing  ';
  const fraseWithMarkings = 'frase with markings: this,that\n\nand some-more! OK? <yes>; ';
  const fraseWithMarkingsTitleCase = 'Frase With Markings: This,That\n\nAnd Some-More! OK? <Yes>; ';

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

  group('String utils titleCase', () {
    test('titleCase an empty string', () {
      expect(empty.titleCase, empty);
    });

    test('titleCase should not trim', () {
      expect(notTrimmed.titleCase, notTrimmedTitleCase);
    });

    test('single letter should capitalize', () {
      expect(singleLetter.titleCase, singleUpperLetter);
    });

    test('one word should capitalize', () {
      expect(oneWord.titleCase, oneWordCapitalized);
      expect(oneWordCapitalized.titleCase, oneWordCapitalized);
    });

    test('should not turn any letter to lowercase', () {
      expect(oneWordAllUpper.titleCase, oneWordAllUpper);
    });

    test('should titleCase when first word is just one letter', () {
      expect(fraseWithSingleLetterFirst.titleCase, fraseWithSingleLetterTitleCase);
      expect(fraseWithSingleLetterCapitalized.titleCase, fraseWithSingleLetterTitleCase);
      expect(fraseWithSingleLetterTitleCase.titleCase, fraseWithSingleLetterTitleCase);
    });

    test('should titleCase frases', () {
      expect(frase.titleCase, fraseInTitleCase);
      expect(fraseCapitalized.titleCase, fraseInTitleCase);
      expect(fraseInTitleCase.titleCase, fraseInTitleCase);
    });

    test('should not change spacing in frases', () {
      expect(fraseWithSpaces.titleCase, fraseWithSpacesTitleCase);
      expect(fraseWithSpacesTitleCase.titleCase, fraseWithSpacesTitleCase);
    });

    test('should not change markings in frases', () {
      expect(fraseWithMarkings.titleCase, fraseWithMarkingsTitleCase);
      expect(fraseWithMarkingsTitleCase.titleCase, fraseWithMarkingsTitleCase);
    });
  });
}
