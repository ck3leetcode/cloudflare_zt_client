import 'dart:developer';

import 'package:cloudflare_zt_client/features/authentication/authentication_repository.dart';
import 'package:cloudflare_zt_client/features/connection/connection_session.dart';
import 'package:cloudflare_zt_client/features/daemon/daemon_repository.dart';

abstract class ConnectionService {
  bool get isAuthenticated;

  Future<ConnectionStatus> authenticate();

  Future<ConnectionStatus> connect();

  Future<ConnectionStatus> disconnect();

  Future<ConnectionStatus> sync();
}

class DefaultConnectionService implements ConnectionService {
  final AuthenticationRepository authenticationRepository;
  final DaemonRepository daemonRepository;

  DefaultConnectionService(
      {required this.authenticationRepository, required this.daemonRepository});

  AuthenticationToken _authenticationToken =
      AuthenticationToken(expiredAt: DateTime.now(), value: 0);
  ConnectionStatus _current =
      ConnectionStatus(type: ConnectionStatusType.disconnected);

  @override
  Future<ConnectionStatus> authenticate() async {
    log("connection service starts authentication");
    final authResult = await authenticationRepository.authenticate();
    if (authResult.isFailure) {
      final errorMessage = authResult.getError()?.message;
      // return disconnect
      _current = ConnectionStatus(
          type: ConnectionStatusType.disconnected, errorMessage: errorMessage);
      return _current;
    }

    _authenticationToken = authResult.getData() ?? _authenticationToken;
    _current = ConnectionStatus(type: ConnectionStatusType.authenticated);
    return _current;
  }

  @override
  Future<ConnectionStatus> connect() async {
    log("connection service starts connection");
    if (!isAuthenticated) {
      _current = ConnectionStatus(type: ConnectionStatusType.disconnected);
      return _current;
    }

    _current = await daemonRepository.connect(_authenticationToken.value);
    if (_current.type == ConnectionStatusType.connected) {
      // reset auth token after successful connection
      _authenticationToken =
          AuthenticationToken(expiredAt: DateTime.now(), value: 0);
    }
    return _current;
  }

  @override
  Future<ConnectionStatus> disconnect() async {
    log("connection service starts disconnect");
    _current = await daemonRepository.disconnect();
    return _current;
  }

  @override
  Future<ConnectionStatus> sync() async {
    log("connection service starts sync");
    _current = await daemonRepository.status();
    return _current;
  }

  ConnectionStatus get currentConnectionStatus => _current;
  bool get isAuthenticated => _authenticationToken.isExpired == false;
}
