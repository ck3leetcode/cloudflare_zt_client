import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:cloudflare_zt_client/core/socket/socket_client.dart';
import 'package:cloudflare_zt_client/features/daemon/daemon_client.dart';
import 'package:cloudflare_zt_client/features/daemon/daemon_response.dart';

void main() {
  group('DefaultDaemonClient', () {
    late DefaultDaemonClient daemonClient;
    late MockSocketClient mockSocketClient;

    setUp(() {
      mockSocketClient = MockSocketClient();
      daemonClient = DefaultDaemonClient(socketClient: mockSocketClient);
    });

    test('connect should send the correct request and return DaemonResponse', () async {
      final int authToken = 123;
      final Map<String, dynamic> expectedRequest = {
        "request": {"connect": authToken}
      };
      final Map<String, dynamic> mockSocketResponse = {"status": "success", "data": {"daemon_status": "connected"}};

      when(() => mockSocketClient.isConnected).thenReturn(true);
      when(() => mockSocketClient.send(expectedRequest)).thenAnswer((_) async => mockSocketResponse);

      final DaemonResponse result = await daemonClient.connect(authToken);
      final expected = DaemonResponse.fromJson(mockSocketResponse);
      expect(result.status, expected.status);
    });
    
    test('disconnect should send the correct request, close the socket, and return DaemonResponse', () async {
      final Map<String, dynamic> expectedRequest = {"request": "disconnect"};
      final Map<String, dynamic> mockSocketResponse = {"status": "success", "data": {"daemon_status": "disconnected", "message": "Disconnected successfully"}};

      when(() => mockSocketClient.isConnected).thenReturn(true);
      when(() => mockSocketClient.close()).thenAnswer((_) async {});
      when(() => mockSocketClient.send(expectedRequest)).thenAnswer((_) async => mockSocketResponse);

      final DaemonResponse result = await daemonClient.disconnect();
      final expected = DaemonResponse.fromJson(mockSocketResponse);
      expect(result.status, expected.status);
    });

    test('status should send the correct request and return DaemonResponse', () async {
      final Map<String, dynamic> expectedRequest = {"request": "get_status"};
      final Map<String, dynamic> mockSocketResponse = {"status": "success", "data": {"daemon_status": "connected", "message": "Connected successfully"}};

      when(() => mockSocketClient.isConnected).thenReturn(true);
      when(() => mockSocketClient.send(expectedRequest)).thenAnswer((_) async => mockSocketResponse);

      final DaemonResponse result = await daemonClient.status();
      final expected = DaemonResponse.fromJson(mockSocketResponse);
      expect(result.status, expected.status);
    });
  });
}

class MockSocketClient extends Mock implements SocketClient {}