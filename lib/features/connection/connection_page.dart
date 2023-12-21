import 'dart:async';
import 'dart:developer';

import 'package:cloudflare_zt_client/features/connection/connection_session.dart';
import 'package:cloudflare_zt_client/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectionControllerProvider =
    AsyncNotifierProvider<ConnectionController, ConnectionStatus>(
        () => ConnectionController());

class ConnectionPage extends ConsumerWidget {
  const ConnectionPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(connectionControllerProvider);
    return controller.when(
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Center(child: Text('Error: $err')),
      data: (data) {
        return Center(
            child: Column(children: [
          Text("status: ${data.type.name}"),
          data.errorMessage == null
              ? Container()
              : Text("error: ${data.errorMessage}"),
          controlButton(data.type, ref),
        ]));
      },
    );
  }

  Widget controlButton(ConnectionStatusType type, WidgetRef ref) {
    switch (type) {
      case ConnectionStatusType.authenticated:
        return Container();
      case ConnectionStatusType.disconnected:
        return TextButton(
            child: Text("connect"),
            onPressed: () =>
                ref.read(connectionControllerProvider.notifier).connect());
      default:
        return Center(
            child: TextButton(
                child: Text("disconnect"),
                onPressed: () => ref
                    .read(connectionControllerProvider.notifier)
                    .disconnect()));
    }
  }
}

class ConnectionController extends AsyncNotifier<ConnectionStatus> {
  static const syncDuration = const Duration(seconds: 5);
  Timer? timer;

  @override
  FutureOr<ConnectionStatus> build() {
    return ConnectionStatus(type: ConnectionStatusType.disconnected);
  }

  Future<void> connect() async {
    final connectionService = this.ref.read(connectionServiceProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      var result = await connectionService.authenticate();
      bool isAuthenticated = connectionService.isAuthenticated;
      if (isAuthenticated) {
        result = await connectionService.connect();
        startSync();
      }
      return result;
    });
  }

  Future<void> disconnect() async {
    final connectionService = this.ref.read(connectionServiceProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () async => await connectionService.disconnect());
  }

  void startSync() {
    log("ConnectionController starts sync");
    timer = Timer.periodic(syncDuration, (timer) async {
      final connectionService = this.ref.read(connectionServiceProvider);
      final connectionStatus = state.value ??
          ConnectionStatus(type: ConnectionStatusType.disconnected);

      switch (connectionStatus.type) {
        case ConnectionStatusType.authenticated:
          state = await AsyncValue.guard(
              () async => await connectionService.connect());
        case ConnectionStatusType.disconnected:
          log("ConnectionController ends sync");
          timer.cancel();
          break;
        case ConnectionStatusType.error:
        case ConnectionStatusType.connected:
          state = await AsyncValue.guard(
              () async => await connectionService.sync());
          break;
      }
    });
  }

  void stopSync() => timer?.cancel();
}
