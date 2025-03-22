import 'package:number_trivia/core/util/connectivity_wrapper.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final ConnectivityWrapper connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected {
    return connectivity.checkConnection();
  }
}
