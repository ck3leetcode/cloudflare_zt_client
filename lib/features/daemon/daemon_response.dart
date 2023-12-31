// To parse this JSON data, do
//
//     final daemonResponse = daemonResponseFromJson(jsonString);

import 'dart:convert';

DaemonResponse daemonResponseFromJson(String str) =>
    DaemonResponse.fromJson(json.decode(str));

class DaemonResponse {
  String? status;
  String? message;
  Data? data;

  DaemonResponse({
    this.status,
    this.message,
    this.data,
  });

  factory DaemonResponse.fromJson(Map<String, dynamic> json) => DaemonResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );
}

class Data {
  String? daemonStatus;
  String? message;

  Data({
    this.daemonStatus,
    this.message,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        daemonStatus: json["daemon_status"],
        message: json["message"],
      );
}
