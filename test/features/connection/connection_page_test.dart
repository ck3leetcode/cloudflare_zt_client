import 'package:cloudflare_zt_client/features/connection/connection_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloudflare_zt_client/features/connection/connection_page.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('ConnectionPage displays data state', (WidgetTester tester) async {
    // Mock a data state
    final connectionController = ConnectionController();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          connectionControllerProvider.overrideWith(() => connectionController),
        ],
        child: MaterialApp(
          home: const ConnectionPage(),
        ),
      ),
    );

    connectionController.state = AsyncData(ConnectionStatus(type: ConnectionStatusType.connected));
    await tester.pump();

    expect(find.text('status: connected'), findsOneWidget);
    expect(find.text('disconnect'), findsOneWidget);
  });
}
