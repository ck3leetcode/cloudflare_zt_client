import 'package:cloudflare_zt_client/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloudflare_zt_client/core/socket/socket_client.dart';
import 'package:cloudflare_zt_client/features/authentication/authentication_client.dart';
import 'package:cloudflare_zt_client/features/authentication/authentication_repository.dart';
import 'package:cloudflare_zt_client/features/connection/connection_service.dart';
import 'package:cloudflare_zt_client/features/daemon/daemon_client.dart';
import 'package:cloudflare_zt_client/features/daemon/daemon_repository.dart';

void main() {
  group('Providers and Services Tests', () {
    test('Authentication Providers and Repository', () {
      final container = ProviderContainer();

      // Test AuthenticationClient
      final authenticationClient = container.read(authenticationClientProvider);
      expect(authenticationClient, isA<AuthenticationHttpClient>());

      // Test AuthenticationRepository
      final authenticationRepository =
          container.read(authenticationRepositoryProvider);
      expect(authenticationRepository, isA<AuthenticationRepository>());
    });

    test('SocketClient Provider', () {
      final container = ProviderContainer();

      // Test SocketClient
      final socketClient = container.read(socketClientProvider);
      expect(socketClient, isA<DefaultSocketClient>());
    });

    test('Daemon Providers and Repository', () {
      final container = ProviderContainer();

      // Test DaemonClient
      final daemonClient = container.read(daemonClientProvider);
      expect(daemonClient, isA<DefaultDaemonClient>());

      // Test DaemonRepository
      final daemonRepository = container.read(daemonRepositoryProvider);
      expect(daemonRepository, isA<DaemonRepository>());
    });

    test('Connection Service Provider', () {
      final container = ProviderContainer();

      // Test ConnectionService
      final connectionService = container.read(connectionServiceProvider);
      expect(connectionService, isA<DefaultConnectionService>());
    });
  });
}
