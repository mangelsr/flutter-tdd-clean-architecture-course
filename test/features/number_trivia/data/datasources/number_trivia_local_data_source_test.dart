import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exeptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';

@GenerateNiceMocks([MockSpec<SharedPreferences>()])
import 'number_trivia_local_data_source_test.mocks.dart';

void main() {
  late NumberTriviaLocalDataSourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final testNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));

    test(
        'should return NumberTriviaModel from SharedPreferences when there is one in the cache',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cached.json'));

      // act
      final result = await dataSource.getLastNumberTrivia();

      // assert
      verify(mockSharedPreferences.getString(cachedNumberTrivia));
      expect(result, equals(testNumberTriviaModel));
    });

    test('should throw a CacheExeption when there is not a cached value',
        () async {
      // arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      // act
      final call = dataSource.getLastNumberTrivia;

      // assert
      expect(() => call(), throwsA(isA<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    const testNumberTriviaModel = NumberTriviaModel(
      number: 1,
      text: 'Test Trivia',
    );

    test('should call SharedPreferences to cache the data', () async {
      // act
      dataSource.cacheNumberTrivia(testNumberTriviaModel);

      // assert
      final expectedJsonString = json.encode(testNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(
        cachedNumberTrivia,
        expectedJsonString,
      ));
    });
  });
}
