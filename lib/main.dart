import 'dart:async';

import 'package:cloudflare_zt_client/features/connection/connection_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runZonedGuarded<Future<void>>(
    () async {
      runApp(ProviderScope(child: const ConnectionApp()));
    },
    // ignore: only_throw_errors
    (e, _) => throw e,
  );
}

class ConnectionApp extends StatelessWidget {
  const ConnectionApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: const ConnectionPage(),
    ));
  }
}
