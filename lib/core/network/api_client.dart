class ApiClient {
  const ApiClient({required this.baseUrl});

  final String baseUrl;

  Future<void> get(String path) async {}

  Future<void> post(String path, {Map<String, dynamic>? body}) async {}
}
