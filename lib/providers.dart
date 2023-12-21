import 'package:cloudflare_zt_client/core/socket/socket_client.dart';
import 'package:cloudflare_zt_client/features/authentication/authentication_client.dart';
import 'package:cloudflare_zt_client/features/authentication/authentication_repository.dart';
import 'package:cloudflare_zt_client/features/connection/connection_service.dart';
import 'package:cloudflare_zt_client/features/daemon/daemon_client.dart';
import 'package:cloudflare_zt_client/features/daemon/daemon_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authenticationClientProvider =
    Provider<AuthenticationClient>((ref) => AuthenticationHttpClient());
final authenticationRepositoryProvider = Provider<AuthenticationRepository>(
    (ref) => AuthenticationRepository(
        authenticationClient: ref.read(authenticationClientProvider)));

final socketClientProvider =
    Provider<SocketClient>((ref) => DefaultSocketClient());
final daemonClientProvider = Provider<DaemonClient>(
    (ref) => DefaultDaemonClient(socketClient: ref.read(socketClientProvider)));
final daemonRepositoryProvider = Provider<DaemonRepository>(
    (ref) => DaemonRepository(daemonClient: ref.read(daemonClientProvider)));

final connectionServiceProvider = Provider<ConnectionService>((ref) {
  final daemonRepository = ref.read(daemonRepositoryProvider);
  final authenticationRepository = ref.read(authenticationRepositoryProvider);
  return DefaultConnectionService(
      authenticationRepository: authenticationRepository,
      daemonRepository: daemonRepository);
});
