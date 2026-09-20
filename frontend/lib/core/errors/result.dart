import 'failures.dart';

sealed class Result<T> {
  const Result();

  static Result<T> failure<T>(Failure error) => ResultFailure<T>(error);
  static Result<T> success<T>(T data) => Success<T>(data);

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is ResultFailure<T>;

  T? get data => switch (this) {
        Success<T> success => success.data,
        ResultFailure<T> _ => null,
      };

  Failure? get error => switch (this) {
        Success<T> _ => null,
        ResultFailure<T> failure => failure.error,
      };

  void when({
    required void Function(T data) success,
    required void Function(Failure error) failure,
  }) {
    switch (this) {
      case Success<T> s:
        success(s.data);
      case ResultFailure<T> f:
        failure(f.error);
    }
  }
}

class Success<T> extends Result<T> {
  @override
  final T data;
  const Success(this.data);
}

class ResultFailure<T> extends Result<T> {
  @override
  final Failure error;
  const ResultFailure(this.error);
}
