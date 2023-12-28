import 'package:cloudflare_zt_client/features/daemon/daemon_response.dart';
import 'package:test/test.dart';

void main() {
  group('DaemonResponse', () {
    test('fromJson should correctly parse JSON', () {
      // Arrange
      final json = {
        "status": "success",
        "message": "message",
        "data": {"daemon_status": "active", "message": "running"}
      };

      // Act
      final daemonResponse = DaemonResponse.fromJson(json);

      // Assert
      expect(daemonResponse.status, equals("success"));
      expect(daemonResponse.message, equals("message"));
      expect(daemonResponse.data?.daemonStatus, equals("active"));
      expect(daemonResponse.data?.message, equals("running"));
    });
  });
}
