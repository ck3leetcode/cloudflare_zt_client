import 'package:cloudflare_zt_client/core/common/result.dart';
import 'package:cloudflare_zt_client/core/http/http_client.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

void main() {
  group('DefaultHttpClient', () {
    late DefaultHttpClient httpClient;
    final mockDio = MockDio();

    setUp(() {
      // Initialize the DefaultHttpClient with necessary parameters
      httpClient = DefaultHttpClient(
        host: 'https://example.com',
        requestHeaders: {'Content-Type': 'application/json'},
        overrideDio: mockDio
      );
    });

    test('doGet returns Success for successful GET request', () async {
      // Arrange
      final fakeResourcePath = '/fake/resource';
      final fakeResponseData = {'key': 'value'};
      final fakeResponse = Response<dynamic>(
        data: fakeResponseData,
        statusCode: 200,
        requestOptions: RequestOptions(),
      );

      // Mock the Dio client to return a successful response
      when(() => mockDio.get(fakeResourcePath, data: null)).thenAnswer((_) async  => fakeResponse);

      // Act
      final result = await httpClient.doGet(fakeResourcePath, null);

      // Assert
      expect(result, isA<Success>());
      expect(result.getData(), equals(fakeResponseData));
    });

    test('doGet returns Failure for unsuccessful GET request', () async {
      // Arrange
      final fakeResourcePath = '/fake/resource';
      final fakeResponse = Response<dynamic>(
        data: null,
        statusCode: 500,
        requestOptions: RequestOptions(),
      );

      // Mock the Dio client to return a successful response
      when(() => mockDio.get(fakeResourcePath, data: null)).thenAnswer((_) async  => fakeResponse);

      // Act
      final result = await httpClient.doGet(fakeResourcePath, null);

      // Assert
      expect(result, isA<Failure>());
    });
  });
}

class MockDio extends Mock implements Dio {}
