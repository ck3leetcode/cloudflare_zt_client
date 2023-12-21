import 'package:cloudflare_zt_client/core/common/result.dart';
import 'package:test/test.dart';

void main() {
  group('Result', () {
    test('Success - should return true for isFailure and null for getError', () {
      final successResult = Result.success('data');

      expect(successResult.isFailure, isFalse);
      expect(successResult.getError(), isNull);
    });

    test('Failure - should return true for isFailure and non-null for getError', () {
      final failureResult = Result.failure(Error());

      expect(failureResult.isFailure, isTrue);
      expect(failureResult.getError(), isA<Error>());
    });

    test('Success - should return data for getData', () {
      final successResult = Result.success('data');

      expect(successResult.getData(), equals('data'));
    });

    test('Failure - should return null for getData', () {
      final failureResult = Result.failure(Error());

      expect(failureResult.getData(), isNull);
    });
  });
}