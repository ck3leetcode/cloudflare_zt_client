import 'package:cloudflare_zt_client/core/common/result.dart';
import 'package:cloudflare_zt_client/core/http/http_client.dart';
import 'package:cloudflare_zt_client/core/http/http_error.dart';
import 'package:cloudflare_zt_client/features/authentication/authentication_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cloudflare_zt_client/features/authentication/authentication_client.dart';

void main() {
  test('AuthenticationHttpClient - Successful Authentication', () async {
    final mockHttpClient = MockHttpClient(); // You need to implement MockHttpClient

    final authenticationClient = AuthenticationHttpClient(httpClient: mockHttpClient);

    // Mock the response from the HTTP client
    mockHttpClient.mockDoGetResult = Result.success({'status': 'success', 'data': {'auth_token' : 1234}});

    final result = await authenticationClient.authenticate();

    // Verify that the authentication was successful
    expect(result.isFailure, false);
    expect(result.getData(), isA<AuthenticationResponse>());
    final AuthenticationResponse response = result.getData()!;
    expect(response.data?.authToken, 1234);
  });

  test('AuthenticationHttpClient - Failed Authentication', () async {
    final mockHttpClient = MockHttpClient(); // You need to implement MockHttpClient

    final authenticationClient = AuthenticationHttpClient(httpClient: mockHttpClient);

    // Mock the response from the HTTP client
    mockHttpClient.mockDoGetResult = Result.failure(HttpError(message: 'Some error'));

    final result = await authenticationClient.authenticate();

    // Verify that the authentication failed
    expect(result.isFailure, true);
    expect(result.getError(), isA<HttpError>());
    final HttpError error = result.getError()!;
    expect(error.message, 'Some error');
  });
}

class MockHttpClient extends Fake implements HttpClient {
  late Result<dynamic, HttpError> mockDoGetResult;

  @override
  Future<Result<dynamic, HttpError>> doGet(String path, Map<String, dynamic>? queryParameters) async {
    return mockDoGetResult;
  }
}
