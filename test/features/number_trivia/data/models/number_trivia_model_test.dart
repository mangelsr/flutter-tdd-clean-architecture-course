import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const numberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');
  test('should be a subclass of NumberTrivia entity', () {
    expect(numberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return a valid model when the JSON number is an integer', () {
      // arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));

      // act
      final result = NumberTriviaModel.fromJson(jsonMap);

      // assert
      expect(result, numberTriviaModel);
    });

    test(
        'should return a valid model when the JSON number is regarded as a double',
        () {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture('trivia_double.json'));

      // act
      final result = NumberTriviaModel.fromJson(jsonMap);

      // assert
      expect(result, numberTriviaModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing the proper  data', () {
      // act
      final result = numberTriviaModel.toJson();

      // assert
      final expectedMap = {
        'text': 'Test Text',
        'number': 1,
      };
      expect(result, expectedMap);
    });
  });
}
