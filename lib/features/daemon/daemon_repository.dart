import 'dart:developer';

import 'package:cloudflare_zt_client/features/connection/connection_session.dart';
import 'package:cloudflare_zt_client/features/daemon/daemon_client.dart';
import 'package:cloudflare_zt_client/features/daemon/daemon_response.dart';

class DaemonRepository {
  final DaemonClient daemonClient;
  DaemonRepository({required this.daemonClient});

  Future<ConnectionStatus> connect(int authToken) async {
    ConnectionStatus status;
    try {
      final DaemonResponse response = await daemonClient.connect(authToken);
      status = response.toConnectionStatus();
    } catch (e) {
      status = ConnectionStatus(type: ConnectionStatusType.error, errorMessage: e.toString());
    }
    log("DaemonRepository connects: ${status.type}");
    return status;
  }

  Future<ConnectionStatus> disconnect() async {
    ConnectionStatus status;
    try {
      final DaemonResponse response = await daemonClient.disconnect();
      status = response.toConnectionStatus();
    } catch (e) {
      status = ConnectionStatus(type: ConnectionStatusType.error, errorMessage: e.toString());
    }
    log("DaemonRepository disconnect: ${status.type}");
    return status;
  }

  Future<ConnectionStatus> status() async {
    ConnectionStatus status;
    try {
      final DaemonResponse response = await daemonClient.status();
      status = response.toConnectionStatus();
    } catch (e) {
      status = ConnectionStatus(type: ConnectionStatusType.error, errorMessage: e.toString());
    }
    log("DaemonRepository status: ${status.type}");
    return status;
  }
}

extension ConnectionStatusParsing on DaemonResponse {
  ConnectionStatus toConnectionStatus() {
    if (status == "error") {
      return ConnectionStatus(
          type: ConnectionStatusType.error, errorMessage: this.message);
    }

    final type = data?.daemonStatus == "connected"
        ? ConnectionStatusType.connected
        : ConnectionStatusType.disconnected;

    final dataMessage = data?.message;
    return ConnectionStatus(type: type, errorMessage: dataMessage);
  }
}
