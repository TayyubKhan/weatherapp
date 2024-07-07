
class FetchDataException implements Exception {
  final String message;

  FetchDataException(this.message);

  @override
  String toString() => 'FetchDataException: $message';
}