class AppConfig {
  static const String backendUrl = String.fromEnvironment(
    'BACKEND_URL',
    defaultValue: 'http://localhost:3000',
  );

  static const String apiPrefix = '/api/v1';

  static String url(String path) => '$backendUrl$apiPrefix$path';
}
