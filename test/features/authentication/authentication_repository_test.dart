import 'package:cloudflare_zt_client/core/common/result.dart';
import 'package:cloudflare_zt_client/features/authentication/authentication_client.dart';
import 'package:cloudflare_zt_client/features/authentication/authentication_response.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';
import 'package:cloudflare_zt_client/features/authentication/authentication_repository.dart';
import 'package:cloudflare_zt_client/core/http/http_error.dart';


void main() {
  group('AuthenticationRepository', () {
    test('authenticate - failure', () async {
      final AuthenticationClient mockAuthenticationClient = MockAuthenticationClient();
      final authenticationRepository =
          AuthenticationRepository(authenticationClient: mockAuthenticationClient);

      // Mock a failed authentication response
      when(() => mockAuthenticationClient.authenticate())
          .thenAnswer((_) async => Result<AuthenticationResponse, HttpError>.failure(HttpError()));

      final result = await authenticationRepository.authenticate();

      expect(result.isFailure, true);
      expect(result.getError(), isA<HttpError>());
    });

    test('authenticate - with expiration override', () async {
      final AuthenticationClient mockAuthenticationClient = MockAuthenticationClient();
      final authenticationRepository =
          AuthenticationRepository(authenticationClient: mockAuthenticationClient);

      final expirationOverride = DateTime.now().add(Duration(minutes: 10));

      // Mock a successful authentication response
      when(() => mockAuthenticationClient.authenticate())
          .thenAnswer((_) async => Result.success(
            AuthenticationResponse(
              status: "success",
              data: Data(authToken: 123))));

      final result =
          await authenticationRepository.authenticate(exipredAtOverride: expirationOverride);

      expect(result.isFailure, false);
      expect(result.getData(), isA<AuthenticationToken>());
      expect(result.getData()!.expiredAt, equals(expirationOverride));
      expect(result.getData()!.value, equals(123));
    });
  });
}

class MockAuthenticationClient extends Mock implements AuthenticationClient {}