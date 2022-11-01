import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

@GenerateNiceMocks([MockSpec<NumberTriviaRepository>()])
import 'get_concrete_number_trivia_test.mocks.dart';

void main() {
  test('should get trivia for the number repository', () async {
    // arrange
    const testNumber = 1;
    const testNumberTrivia = NumberTrivia(text: 'test', number: testNumber);

    MockNumberTriviaRepository mockNumberTriviaRepository =
        MockNumberTriviaRepository();
    GetConcreteNumberTrivia useCase =
        GetConcreteNumberTrivia(mockNumberTriviaRepository);

    when(mockNumberTriviaRepository.getConcreteNumberTrivia(testNumber))
        .thenAnswer((_) async => const Right(testNumberTrivia));

    // act
    final result = await useCase.execute(number: testNumber);

    // assert
    expect(result, const Right(testNumberTrivia));
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(testNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}