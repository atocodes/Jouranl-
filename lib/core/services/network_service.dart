import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkService {
  Connectivity _connectivity;
  InternetConnectionChecker internetConnection;
  final StreamController<bool> _networkController =
      StreamController.broadcast();

  NetworkService(this._connectivity, this.internetConnection) {
    _connectivity.onConnectivityChanged.listen(_updateStatus);
  }

  Future<void> init() async {
    final isOnlineNow = await isOnline();
    _networkController.add(isOnlineNow);
  }

  Stream<bool> get networkStream => _networkController.stream;

  Future<bool> hasNetwork() async {
    final result = await _connectivity.checkConnectivity();
    return result.first != ConnectivityResult.none;
  }

  Future<bool> hasInternet() async {
    return await internetConnection.hasConnection;
  }

  Future<bool> isOnline() async {
    final network = await hasNetwork();
    if (!network) return false;
    final internet = await hasInternet();
    return internet;
  }

  Future<void> _updateStatus(List<ConnectivityResult> result) async {
    final online = await isOnline();
    _networkController.add(online);
  }

  void dispose() {
    _networkController.close();
  }
}
