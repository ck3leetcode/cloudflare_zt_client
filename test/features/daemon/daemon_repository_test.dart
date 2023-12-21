import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:cloudflare_zt_client/features/connection/connection_session.dart';
import 'package:cloudflare_zt_client/features/daemon/daemon_client.dart';
import 'package:cloudflare_zt_client/features/daemon/daemon_repository.dart';
import 'package:cloudflare_zt_client/features/daemon/daemon_response.dart';


void main() {
  group('DaemonRepository', () {
    late DaemonRepository daemonRepository;
    late MockDaemonClient mockDaemonClient;

    setUp(() {
      mockDaemonClient = MockDaemonClient();
      daemonRepository = DaemonRepository(daemonClient: mockDaemonClient);
    });

    test('connect should return ConnectionStatus', () async {
      final int authToken = 123;
      final DaemonResponse mockResponse = DaemonResponse.fromJson({"status": "success", "data": {"daemon_status": "connected", "message": "Connected successfully"}});

      when(() => mockDaemonClient.connect(authToken)).thenAnswer((_) async => mockResponse);

      final ConnectionStatus result = await daemonRepository.connect(authToken);

      expect(result.type, ConnectionStatusType.connected);
      expect(result.errorMessage, "Connected successfully");
    });

    test('disconnect should return ConnectionStatus', () async {
      final DaemonResponse mockResponse = DaemonResponse.fromJson({"status": "success", "data": {"daemon_status": "disconnected", "message": "Disconnected successfully"}});

      when(() => mockDaemonClient.disconnect()).thenAnswer((_) async => mockResponse);

      final ConnectionStatus result = await daemonRepository.disconnect();

      expect(result.type, ConnectionStatusType.disconnected);
      expect(result.errorMessage, "Disconnected successfully");
    });

    test('status should return ConnectionStatus', () async {
      final DaemonResponse mockResponse = DaemonResponse.fromJson({"status": "success", "data": {"daemon_status": "connected", "message": "Connected"}});

      when(() => mockDaemonClient.status()).thenAnswer((_) async => mockResponse);

      final ConnectionStatus result = await daemonRepository.status();

      expect(result.type, ConnectionStatusType.connected);
      expect(result.errorMessage, "Connected");
    });

    test('connect should handle error and return ConnectionStatus with type error', () async {
      final int authToken = 123;

      when(() => mockDaemonClient.connect(authToken)).thenThrow('Connection error');

      final ConnectionStatus result = await daemonRepository.connect(authToken);

      expect(result.type, ConnectionStatusType.error);
      expect(result.errorMessage, 'Connection error');
    });
  });
}

class MockDaemonClient extends Mock implements DaemonClient {}
