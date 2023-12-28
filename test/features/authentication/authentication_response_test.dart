import 'package:cloudflare_zt_client/features/authentication/authentication_response.dart';
import 'package:test/test.dart';

void main() {
  group('AuthenticationResponse', () {
    test('fromJson should correctly parse JSON', () {
      // Arrange
      final json = {
        "status": "success",
        "data": {"auth_token": 123456}
      };

      // Act
      final authenticationResponse = AuthenticationResponse.fromJson(json);

      // Assert
      expect(authenticationResponse.status, equals("success"));
      expect(authenticationResponse.data?.authToken, equals(123456));
    });
  });
}
