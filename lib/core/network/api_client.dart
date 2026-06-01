import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<dynamic> postJson(
    String path,
    Map<String, dynamic> body, {
    Map<String, String>? headers,
  }) async {
    final response = await http.post(
      _uri(path),
      headers: {
        'Content-Type': 'application/json',
        if (headers != null) ...headers,
      },
      body: jsonEncode(body),
    );
    return _decode(response);
  }

  Future<dynamic> postMultipartFile(
    String path, {
    required String field,
    required XFile file,
  }) async {
    final request = http.MultipartRequest('POST', _uri(path));
    final bytes = await file.readAsBytes();
    request.files.add(http.MultipartFile.fromBytes(
      field,
      bytes,
      filename: file.name,
      contentType: _imageMediaType(file.name),
    ));
    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);
    return _decode(response);
  }

  MediaType _imageMediaType(String path) {
    final ext = path.toLowerCase().split('.').last;
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return MediaType('image', 'jpeg');
      case 'png':
        return MediaType('image', 'png');
      case 'webp':
        return MediaType('image', 'webp');
      default:
        return MediaType('application', 'octet-stream');
    }
  }

  dynamic _decode(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(response.statusCode, response.body);
    }
    if (response.body.isEmpty) return null;
    return jsonDecode(response.body);
  }
}
