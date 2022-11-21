class ApiEndPoints {
  static final String baseUrl = 'http://172.29.128.1:8000/api/';
  static _AuthEndPoints authEndpoints = _AuthEndPoints();
}

class _AuthEndPoints {
  final String login = 'auth/login';
  final String logout = 'auth/logout';
  final String categories = 'categories';
}
