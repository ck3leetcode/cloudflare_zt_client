import 'package:cloudflare_zt_client/core/http/http_error.dart';
import 'package:test/test.dart';

void main() {
  group('HttpError', () {
    test('constructor should set message and statusCode', () {
      final errorMessage = 'Not Found';
      final statusCode = 404;
      final httpError = HttpError(message: errorMessage, statusCode: statusCode);

      // Assert
      expect(httpError.message, equals(errorMessage));
      expect(httpError.statusCode, equals(statusCode));
    });
  });
}
