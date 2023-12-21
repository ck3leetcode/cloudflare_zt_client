class HttpError extends Error {
  HttpError({
    this.message,
    this.statusCode,
  });

  /// Exception message
  final String? message;

  /// Exception http response code
  final int? statusCode;
}
