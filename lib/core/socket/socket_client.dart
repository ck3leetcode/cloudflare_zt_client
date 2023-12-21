import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';

abstract class SocketClient {
  bool get isConnected;

  Future<void> open();
  Future<void> close();
  Future<Map<String, dynamic>> send(Map<String, dynamic> request);
}

class DefaultSocketClient implements SocketClient {
  static const socketPath = "/tmp/daemon-lite";

  Socket? socket;
  bool isConnected = false;

  Completer<Map<String, dynamic>> _completer = Completer<Map<String, dynamic>>();
  DefaultSocketClient({Socket? socket}) {
    if (socket != null) this.socket = socket;
  }

  Future<void> open() async {
    log("socket client opens connection");
    socket = this.socket ??
      await Socket.connect(InternetAddress(socketPath, type: InternetAddressType.unix), 0);
    isConnected = true;

    // Listen for responses from the server
    socket?.listen(
      (List<int> data) {
        // Decode the list of bytes into a string
        final String recvPayloadJsonString = utf8.decode(Uint8List.fromList(data.skip(8).toList()));
        // Deserialize the JSON payload into a Dart object. This is the response
        final Map<String, dynamic> recvPayload = jsonDecode(recvPayloadJsonString);
        log('socket client received response from server: $recvPayload');
        _completer.complete(recvPayload);
      },
      onDone: () {
        log('socket client connection closed by server.');
        socket?.destroy();
        isConnected = false;
         _completer.completeError(Error());
      },
      onError: (error) {
        log('socket client Error: $error');
        socket?.destroy();
        isConnected = false;
         _completer.completeError(Error());
      });
  }

  Future<void> close() async {
    log('socket client closes connection');
    isConnected = false;
    await socket?.close();
  }

  Future<Map<String, dynamic>> send(Map<String, dynamic> request) async {
    _completer = Completer<Map<String, dynamic>>();

    // Serialize the payload into a JSON string
    String sendPayloadJson = jsonEncode(request);
    // Determine the size of the JSON payload
    int sendPayloadSize = sendPayloadJson.length;
    // Convert the size of the JSON payload into an array of 8 bytes
    ByteData sendPayloadSizeBytes =
        ByteData(8)..setUint64(0, sendPayloadSize, Endian.little);
    // -- Sending the request --
    log("socket client sending $sendPayloadJson");
    // First, send the size of the JSON payload to the socket
    socket?.add(sendPayloadSizeBytes.buffer.asUint8List());
    // Then, send the JSON payload to the socket
    socket?.add(utf8.encode(sendPayloadJson));    

    return await _completer.future;
  }

  // for test purpose
  setComplete(Map<String, dynamic> data) {
    _completer.complete(data);
  }
}
