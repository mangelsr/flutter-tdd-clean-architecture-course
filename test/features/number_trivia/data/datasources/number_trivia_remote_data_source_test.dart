import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exeptions.dart';

import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';
@GenerateNiceMocks([MockSpec<http.Client>()])
import 'number_trivia_remote_data_source_test.mocks.dart';

void main() {
  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Not Found', 404));
  }

  group('getConcreteNumberTrivia', () {
    const testNumber = 1;
    final testNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should preform a GET request on a URL with number being the
    endpoint and with application/json header''', () async {
      // arrange
      setUpMockHttpClientSuccess200();

      // act
      dataSource.getConcreteNumberTrivia(testNumber);

      // assert
      verify(mockHttpClient.get(
        Uri.parse('http://numbersapi.com/$testNumber'),
        headers: {
          'Content-Type': 'application/json',
        },
      ));
    });

    test('should return NumberTrivia when the response code is 200 (success)',
        () async {
      // arrange
      setUpMockHttpClientSuccess200();

      // act
      final result = await dataSource.getConcreteNumberTrivia(testNumber);

      // assert
      expect(result, equals(testNumberTriviaModel));
    });

    test(
        'should throw a ServerException when the response code is different from 200',
        () async {
      // arrange
      setUpMockHttpClientFailure404();

      // act
      final call = dataSource.getConcreteNumberTrivia;

      // assert
      expect(() => call(testNumber), throwsA(isA<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final testNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should preform a GET request on a URL with number being the
    endpoint and with application/json header''', () async {
      // arrange
      setUpMockHttpClientSuccess200();

      // act
      dataSource.getRandomNumberTrivia();

      // assert
      verify(mockHttpClient.get(
        Uri.parse('http://numbersapi.com/random'),
        headers: {
          'Content-Type': 'application/json',
        },
      ));
    });

    test('should return NumberTrivia when the response code is 200 (success)',
        () async {
      // arrange
      setUpMockHttpClientSuccess200();

      // act
      final result = await dataSource.getRandomNumberTrivia();

      // assert
      expect(result, equals(testNumberTriviaModel));
    });

    test(
        'should throw a ServerException when the response code is different from 200',
        () async {
      // arrange
      setUpMockHttpClientFailure404();

      // act
      final call = dataSource.getRandomNumberTrivia;

      // assert
      expect(() => call(), throwsA(isA<ServerException>()));
    });
  });
}
