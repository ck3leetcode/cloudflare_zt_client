import 'dart:developer';

import 'package:cloudflare_zt_client/core/common/result.dart';
import 'package:cloudflare_zt_client/core/http/http_error.dart';
import 'package:cloudflare_zt_client/features/authentication/authentication_client.dart';
import 'package:cloudflare_zt_client/features/authentication/authentication_response.dart';

class AuthenticationToken {
  final DateTime expiredAt;
  final int value;

  AuthenticationToken({required this.expiredAt, required this.value});

  bool get isExpired {
    return expiredAt.isBefore(DateTime.now());
  }
}

class AuthenticationRepository {
  static const _duration = Duration(minutes: 5);

  final AuthenticationClient authenticationClient;

  AuthenticationRepository({required this.authenticationClient});

  Future<Result<AuthenticationToken, HttpError>> authenticate(
      {DateTime? exipredAtOverride}) async {
    Result<AuthenticationResponse, HttpError> result =
        await authenticationClient.authenticate();
    if (result.isFailure) {
      log("authentication repository fails to authenticate");
      return Result.failure(result.getError());
    }

    final AuthenticationResponse? response = result.getData();
    final int val = response?.data?.authToken ?? 0;
    final DateTime expiredAt =
        exipredAtOverride ?? (DateTime.now().add(_duration));

    final AuthenticationToken token =
        AuthenticationToken(value: val, expiredAt: expiredAt);
    log("authentication repository succeeds to authenticate with token $expiredAt");
    return Result.success(token);
  }
}
