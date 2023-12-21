import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloudflare_zt_client/core/socket/socket_client.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

void main() {
  group('DefaultSocketClient', () {
    final mockSocket = MockSocket();
    
    setUp(() {
      final stream = Stream.periodic(const Duration(seconds: 10), (i) => Uint8List.fromList([]));
      final subscription = stream.listen(print);
      when(() => mockSocket.listen(any(), onDone: any(named: 'onDone'), onError: any(named: 'onError')))
          .thenReturn(subscription);
    });

    test('open - successful connection', () async {
      final socketClient = DefaultSocketClient(socket: mockSocket);

      await socketClient.open();
      expect(socketClient.isConnected, true);
    });

    test('close - closes connection', () async {
      final socketClient = DefaultSocketClient(socket: mockSocket);
      when(() => mockSocket.close()).thenAnswer((_) async {});
      await socketClient.close();
      expect(socketClient.isConnected, false);
    });

    test('send - successful send and receive', () async {
      final socketClient = DefaultSocketClient(socket: mockSocket);
      final request = {'key': 'value'};
      final response = {'result': 'success'};

      Future.delayed(Duration(seconds: 3),() {
        socketClient.setComplete(response);
      });
      final result = await socketClient.send(request);
      expect(result, response);
    });
  });
}

class MockSocket extends Mock implements Socket {}
