import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/core/util/connectivity_wrapper.dart';

@GenerateNiceMocks([MockSpec<ConnectivityWrapper>()])
import 'network_info_test.mocks.dart';

void main() {
  late MockConnectivityWrapper mockConnectivityWrapper;
  late NetworkInfoImpl networkInfoImpl;

  setUp(() {
    mockConnectivityWrapper = MockConnectivityWrapper();
    networkInfoImpl = NetworkInfoImpl(mockConnectivityWrapper);
  });

  group('isConnected', () {
    test('should forward the call to cross_connectivity package', () async {
      // arrange
      final testConnectionFuture = Future.value(true);
      when(mockConnectivityWrapper.checkConnection())
          .thenAnswer((_) => testConnectionFuture);

      // act
      final result = networkInfoImpl.isConnected;

      // assert
      verify(mockConnectivityWrapper.checkConnection());
      expect(result, testConnectionFuture);
    });
  });
}
