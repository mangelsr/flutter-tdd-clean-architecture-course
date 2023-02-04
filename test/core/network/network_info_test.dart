import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:number_trivia/core/network/network_info.dart';

@GenerateNiceMocks([MockSpec<Connectivity>()])
import 'network_info_test.mocks.dart';

void main() {
  late MockConnectivity mockConnectivity;
  late NetworkInfoImpl networkInfoImpl;

  setUp(() {
    mockConnectivity = MockConnectivity();
    networkInfoImpl = NetworkInfoImpl(mockConnectivity as Connectivity);
  });

  group('isConnected', () {
    test('should forward the call to cross_connectivity package', () async {
      // arrange
      final testConnectionFuture = Future.value(true);
      when(mockConnectivity.checkConnection())
          .thenAnswer((_) => testConnectionFuture);

      // act
      final result = networkInfoImpl.isConnected;

      // assert
      verify(mockConnectivity.checkConnection());
      expect(result, testConnectionFuture);
    });
  });
}
