import 'dart:developer';

import 'package:cloudflare_zt_client/core/common/result.dart';
import 'package:cloudflare_zt_client/core/http/http_client.dart';
import 'package:cloudflare_zt_client/core/http/http_error.dart';
import 'package:cloudflare_zt_client/features/authentication/authentication_response.dart';

abstract class AuthenticationClient {
  Future<Result<AuthenticationResponse, HttpError>> authenticate();
}

class AuthenticationHttpClient implements AuthenticationClient {
  static const String host =
      "https://warp-registration.warpdir2792.workers.dev";
  static const String authAPIKey = "3735928559";

  late final HttpClient client;

  AuthenticationHttpClient({HttpClient? httpClient})
      : client = httpClient ??
            DefaultHttpClient(
                host: host, requestHeaders: {"X-Auth-Key": authAPIKey});

  @override
  Future<Result<AuthenticationResponse, HttpError>> authenticate() async {
    log("http client starts authentication");
    final Result<dynamic, HttpError> result = await client.doGet("", null);

    if (result.isFailure) {
      log("http client authentication fails");
      final HttpError? e = result.getError();
      return Result<AuthenticationResponse, HttpError>.failure(e);
    }

    final Map<String, dynamic>? json = result.getData();
    if (json == null) {
      return Result<AuthenticationResponse, HttpError>.failure(
          HttpError(message: "Empty Json content"));
    }

    log("http client authentication succeeds");
    return Result<AuthenticationResponse, HttpError>.success(
        AuthenticationResponse.fromJson(json));
  }
}
