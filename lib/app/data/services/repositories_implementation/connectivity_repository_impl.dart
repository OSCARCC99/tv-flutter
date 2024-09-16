import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../domain/repositories/connectivity_repository.dart';
import '../remote/internet_checker.dart';

class ConnectvityRepositoryImpl implements ConnectvityRepository {
  final Connectivity _connectivity;
  final InternetChecker _internetChecker;

  ConnectvityRepositoryImpl(
    this._connectivity,
    this._internetChecker,
  );

  @override
  Future<bool> get hasInternet async {
    final result = _connectivity.checkConnectivity();

    //comprobar si esta conectado a WiFi
    if (result == ConnectivityResult.none) {
      return false;
    }

    return _internetChecker.hasInternet();
  }
}
