import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:fit_mate_client/core/config/app_config.dart';

class ApiException implements Exception {
  ApiException(this.statusCode, this.body);

  final int statusCode;
  final String body;

  @override
  String toString() => 'ApiException($statusCode): $body';
}

class ApiClient {
  ApiClient({String? baseUrl}) : baseUrl = baseUrl ?? AppConfig.backendUrl;

  final String baseUrl;

  Uri _uri(String path) => Uri.parse('$baseUrl${AppConfig.apiPrefix}$path');

  Future<dynamic> postJson(String path, Map<String, dynamic> body) async {
    final response = await http.post(
      _uri(path),
      headers: const {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return _decode(response);
  }

  Future<dynamic> postMultipartFile(
    String path, {
    required String field,
    required File file,
  }) async {
    final request = http.MultipartRequest('POST', _uri(path));
    request.files.add(await http.MultipartFile.fromPath(field, file.path));
    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    return _decode(response);
  }

  dynamic _decode(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(response.statusCode, response.body);
    }
    if (response.body.isEmpty) return null;
    return jsonDecode(response.body);
  }
}
