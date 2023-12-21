import 'package:meta/meta.dart';

@sealed
abstract class Result<T extends Object, E extends Error> {
  bool get isFailure;
  E? getError();
  T? getData();

  factory Result.success(T data) => Success(data: data);
  factory Result.failure(E? error) => Failure(error: error);
}

@immutable
class Success<T extends Object, E extends Error> implements Result<T, E> {
  final T data;
  const Success({required this.data});

  @override
  bool get isFailure => false;

  @override
  E? getError() => null;

  @override
  T? getData() => data;
}

@immutable
class Failure<T extends Object, E extends Error> implements Result<T, E> {
  final E? error;
  const Failure({required this.error});

  @override
  bool get isFailure => true;

  @override
  T? getData() => null;

  @override
  E? getError() => error;
}
