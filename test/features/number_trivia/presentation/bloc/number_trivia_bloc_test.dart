import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/core/usecases/usecase.dart';
import 'package:number_trivia/core/util/input_converter.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:number_trivia/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';

@GenerateNiceMocks([MockSpec<GetConcreteNumberTrivia>()])
@GenerateNiceMocks([MockSpec<GetRandomNumberTrivia>()])
@GenerateNiceMocks([MockSpec<InputConverter>()])
import 'number_trivia_bloc_test.mocks.dart';

void main() {
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState should be Empty', () {
    expect(bloc.state, equals(Empty()));
  });

  group('GetTriviaForConcreteNumber', () {
    const testNumberString = '1';
    const testNumberParsed = 1;
    const testNumberTrivia = NumberTrivia(
      text: 'Test Trivia',
      number: testNumberParsed,
    );

    void setUpInputConverterSuccess() =>
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(const Right(testNumberParsed));

    test('''should call the InputConverter to validate and convert the
          string to an unsigned integer''', () async {
      // arrange
      setUpInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(testNumberTrivia));

      // act
      bloc.add(const GetTriviaForConcreteNumber(testNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

      // assert
      verify(mockInputConverter.stringToUnsignedInteger(testNumberString));
    });

    test('should emit [Error] when the input is invalid', () async {
      // arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
          .thenReturn(Left(InvalidInputFailure()));

      // assert later
      final expected = [
        // Empty(), // TODO: Check how to migrate the this test part
        const Error(message: invalidInputFailureMessage),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(const GetTriviaForConcreteNumber(testNumberString));
    });

    test('should get data from the concrete use case', () async {
      // arrange
      setUpInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(testNumberTrivia));

      // act
      bloc.add(const GetTriviaForConcreteNumber(testNumberString));
      await untilCalled(mockInputConverter.stringToUnsignedInteger(any));

      // assert
      verify(
          mockGetConcreteNumberTrivia(const Params(number: testNumberParsed)));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      // arrange
      setUpInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => const Right(testNumberTrivia));

      // assert latter
      final expected = [
        // Empty(), // TODO: Check how to migrate the this test part
        Loading(),
        const Loaded(trivia: testNumberTrivia),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(const GetTriviaForConcreteNumber(testNumberString));
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      setUpInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      // assert latter
      final expected = [
        // Empty(), // TODO: Check how to migrate the this test part
        Loading(),
        const Error(message: serverFailureMessage),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(const GetTriviaForConcreteNumber(testNumberString));
    });

    test('''should emit [Loading, Error] with propper message for the error
            when getting data fails''', () async {
      // arrange
      setUpInputConverterSuccess();
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      // assert latter
      final expected = [
        // Empty(), // TODO: Check how to migrate the this test part
        Loading(),
        const Error(message: cacheFailureMessage),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(const GetTriviaForConcreteNumber(testNumberString));
    });
  });

  group('GetRandomNumberTrivia', () {
    const testNumberTrivia = NumberTrivia(
      text: 'Test Trivia',
      number: 1,
    );

    test('should get data from the random use case', () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => const Right(testNumberTrivia));

      // act
      bloc.add(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));

      // assert
      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test('should emit [Loading, Loaded] when data is gotten successfully',
        () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => const Right(testNumberTrivia));

      // assert latter
      final expected = [
        // Empty(), // TODO: Check how to migrate the this test part
        Loading(),
        const Loaded(trivia: testNumberTrivia),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForRandomNumber());
    });

    test('should emit [Loading, Error] when getting data fails', () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      // assert latter
      final expected = [
        // Empty(), // TODO: Check how to migrate the this test part
        Loading(),
        const Error(message: serverFailureMessage),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForRandomNumber());
    });

    test('''should emit [Loading, Error] with propper message for the error
            when getting data fails''', () async {
      // arrange
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      // assert latter
      final expected = [
        // Empty(), // TODO: Check how to migrate the this test part
        Loading(),
        const Error(message: cacheFailureMessage),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      // act
      bloc.add(GetTriviaForRandomNumber());
    });
  });
}
