// To parse this JSON data, do
//
//     final authenticationResponse = authenticationResponseFromJson(jsonString);

import 'dart:convert';

AuthenticationResponse authenticationResponseFromJson(String str) =>
    AuthenticationResponse.fromJson(json.decode(str));

class AuthenticationResponse {
  String? status;
  String? message;
  Data? data;

  AuthenticationResponse({
    this.status,
    this.message,
    this.data,
  });

  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) =>
      AuthenticationResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  int? authToken;

  Data({
    this.authToken,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        authToken: json["auth_token"],
      );
}
