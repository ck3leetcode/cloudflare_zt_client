import 'package:cloudflare_zt_client/core/common/result.dart';
import 'package:cloudflare_zt_client/core/http/http_error.dart';
import 'package:cloudflare_zt_client/features/connection/connection_session.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloudflare_zt_client/features/authentication/authentication_repository.dart';
import 'package:cloudflare_zt_client/features/connection/connection_service.dart';
import 'package:cloudflare_zt_client/features/daemon/daemon_repository.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('DefaultConnectionService', () {
    late DefaultConnectionService connectionService;

    setUp(() {
      // Initialize the required dependencies with mock objects
      final authenticationRepository = MockAuthenticationRepository();
      final daemonRepository = MockDaemonRepository();

      connectionService = DefaultConnectionService(
        authenticationRepository: authenticationRepository,
        daemonRepository: daemonRepository,
      );
    });

    test('authenticate - successful authentication', () async {
      // Mock the authentication result
      when(() => connectionService.authenticationRepository.authenticate())
          .thenAnswer((_) async => Result.success(AuthenticationToken(expiredAt: DateTime(2099), value: 123)));

      final result = await connectionService.authenticate();

      expect(result.type, ConnectionStatusType.authenticated);
      expect(connectionService.isAuthenticated, true);
    });

    test('authenticate - authentication failure', () async {
      // Mock the authentication result
      final errorMessage = 'Authentication failed';
      when(() => connectionService.authenticationRepository.authenticate())
          .thenAnswer((_) async => Result.failure(HttpError(statusCode: 500, message: errorMessage)));

      final result = await connectionService.authenticate();

      expect(result.type, ConnectionStatusType.disconnected);
      expect(result.errorMessage, errorMessage);
      expect(connectionService.isAuthenticated, false);
    });

    test('connect - successful connection', () async {
      // Mock the authentication result
      when(()=>connectionService.authenticationRepository.authenticate())
          .thenAnswer((_) async => Result.success(AuthenticationToken(expiredAt: DateTime(2099), value: 123)));

      // Mock the connection result
      when(() => connectionService.daemonRepository.connect(123))
          .thenAnswer((_) async => ConnectionStatus(type: ConnectionStatusType.connected));

      await connectionService.authenticate(); // Authenticate first

      final result = await connectionService.connect();

      expect(result.type, ConnectionStatusType.connected);
      expect(connectionService.isAuthenticated, false); // Authentication token should be reset
    });

    test('connect - not authenticated', () async {
      final result = await connectionService.connect();

      expect(result.type, ConnectionStatusType.disconnected);
    });

    test('disconnect', () async {
      when(() => connectionService.daemonRepository.disconnect())
          .thenAnswer((_) async => ConnectionStatus(type: ConnectionStatusType.disconnected));

      final result = await connectionService.disconnect();

      expect(result.type, ConnectionStatusType.disconnected);
    });

    test('sync', () async {
      when(() => connectionService.daemonRepository.status())
          .thenAnswer((_) async => ConnectionStatus(type: ConnectionStatusType.disconnected));

      final result = await connectionService.sync();

      expect(result.type, ConnectionStatusType.disconnected);
    });
  });
}

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}

class MockDaemonRepository extends Mock implements DaemonRepository {}
