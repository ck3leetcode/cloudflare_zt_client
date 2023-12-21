import 'package:cloudflare_zt_client/features/connection/connection_session.dart';
import 'package:test/test.dart';

void main() {
  group('ConnectionStatus', () {
    test('should create a ConnectionStatus with authenticated type', () {
      final connectionStatus = ConnectionStatus(type: ConnectionStatusType.authenticated);
      expect(connectionStatus.type, equals(ConnectionStatusType.authenticated));
      expect(connectionStatus.errorMessage, isNull);
    });

    test('should create a ConnectionStatus with connected type and no error message', () {
      final connectionStatus = ConnectionStatus(type: ConnectionStatusType.connected);
      expect(connectionStatus.type, equals(ConnectionStatusType.connected));
      expect(connectionStatus.errorMessage, isNull);
    });

    test('should create a ConnectionStatus with disconnected type and no error message', () {
      final connectionStatus = ConnectionStatus(type: ConnectionStatusType.disconnected);
      expect(connectionStatus.type, equals(ConnectionStatusType.disconnected));
      expect(connectionStatus.errorMessage, isNull);
    });

    test('should create a ConnectionStatus with error type and an error message', () {
      final errorMessage = 'Connection failed';
      final connectionStatus = ConnectionStatus(type: ConnectionStatusType.error, errorMessage: errorMessage);
      expect(connectionStatus.type, equals(ConnectionStatusType.error));
      expect(connectionStatus.errorMessage, equals(errorMessage));
    });
  });
}
