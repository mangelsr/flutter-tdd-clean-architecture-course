import 'package:cross_connectivity/cross_connectivity.dart';

abstract class ConnectivityWrapper {
  Future<bool> checkConnection();
}

class ConnectivityWrapperImpl implements ConnectivityWrapper {
  final Connectivity connectivity;

  ConnectivityWrapperImpl(this.connectivity);

  @override
  Future<bool> checkConnection() => connectivity.checkConnection();
}
