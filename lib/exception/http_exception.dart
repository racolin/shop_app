class HttpException implements Exception {
  final String _message;
  HttpException(String message) : _message = message;
  @override
  String toString() {
    return _message;
  }
}
