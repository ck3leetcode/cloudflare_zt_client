import 'dart:developer';

import 'package:cloudflare_zt_client/core/socket/socket_client.dart';
import 'package:cloudflare_zt_client/features/daemon/daemon_response.dart';

abstract class DaemonClient {
  Future<DaemonResponse> connect(int authToken);

  Future<DaemonResponse> disconnect();

  Future<DaemonResponse> status();
}

class DefaultDaemonClient implements DaemonClient {
  final SocketClient socketClient;

  DefaultDaemonClient({required this.socketClient});

  @override
  Future<DaemonResponse> connect(int authToken) async {
    final Map<String, dynamic> request = {
      "request": {"connect": authToken}
    };

    return await _send(request);
  }

  @override
  Future<DaemonResponse> disconnect() async {
    final Map<String, dynamic> request = {"request": "disconnect"};

    final result = await _send(request);
    await socketClient.close();
    return result;
  }

  @override
  Future<DaemonResponse> status() async {
    final Map<String, dynamic> request = {"request": "get_status"};
    return await _send(request);
  }

  Future<DaemonResponse> _send(Map<String, dynamic> request) async {
    if (!socketClient.isConnected) {
      await socketClient.open();
    }

    log("daemon client sends: $request");
    final Map<String, dynamic> socketResponse =
        await socketClient.send(request);
    log("daemon client received: $socketResponse");
    return DaemonResponse.fromJson(socketResponse);
  }
}
