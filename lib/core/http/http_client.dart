import 'package:cloudflare_zt_client/core/common/result.dart';
import 'package:cloudflare_zt_client/core/http/http_error.dart';
import 'package:dio/dio.dart';

abstract class HttpClient {
  String get host;
  Map<String, String> get requestHeaders;

  Future<Result<dynamic, HttpError>> doGet(
      String resourcePath, Map<String, dynamic>? queryParameters);

  Future<Result<dynamic, HttpError>> doPost(
      String resourcePath, Map<String, dynamic> jsonData);

  Future<Result<dynamic, HttpError>> doPut(
      String resourcePath, Map<String, dynamic> jsonData);

  Future<Result<dynamic, HttpError>> doDelete(String resourcePath);
}

class DefaultHttpClient implements HttpClient {
  // The Dio Http client
  late final Dio dio;

  @override
  final String host;
  @override
  final Map<String, String> requestHeaders;

  DefaultHttpClient({
    required this.host,
    required this.requestHeaders,
    Dio? overrideDio,
  }) : dio = overrideDio ??
            Dio(BaseOptions(
              baseUrl: host,
              headers: requestHeaders,
              validateStatus: (status) => true,
            ));

  @override
  Future<Result<dynamic, HttpError>> doGet(
      String resourcePath, Map<String, dynamic>? queryParameters) async {
    try {
      final Response<dynamic> response = await dio.get(
        resourcePath,
        queryParameters: queryParameters,
      );
      if (response.data == null || response.statusCode != 200) {
        return Failure(
            error: HttpError(
          statusCode: response.statusCode,
          message: response.statusMessage,
        ));
      }
      return Success(data: response.data);
    } catch (e) {
      return Failure(
          error: HttpError(
        statusCode: -1,
        message: e.toString(),
      ));
    }
  }

  @override
  Future<Result<dynamic, HttpError>> doDelete(String resourcePath) {
    throw UnimplementedError();
  }

  @override
  Future<Result<dynamic, HttpError>> doPost(
      String resourcePath, Map<String, dynamic> jsonData) {
    throw UnimplementedError();
  }

  @override
  Future<Result<dynamic, HttpError>> doPut(
      String resourcePath, Map<String, dynamic> jsonData) {
    throw UnimplementedError();
  }
}
