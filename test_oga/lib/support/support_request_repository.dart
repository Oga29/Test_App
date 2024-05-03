import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test_oga/support/support_request.dart';

class SupportRequestRepository {
  final Dio dio;
  final FlutterSecureStorage _storage;

  SupportRequestRepository()
      : dio = Dio(BaseOptions(baseUrl: 'https://test.tamga.com.kz')),
        _storage = const FlutterSecureStorage();

  Future<String> getToken() async {
    final token = await _storage.read(key: 'auth_token');
    if (token == null) {
      throw Exception("Token not found");
    }
    return token;
  }

  Future<List<SupportRequest>> getRequests() async {
    final token = await getToken();
    final response = await dio.get(
      '/api/support-request',
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data['data'];
      return data.map((item) => SupportRequest.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load requests");
    }
  }

  Future<void> createRequest(String message, {List<String>? images, List<String>? documents}) async {
    final token = await getToken();
    final formData = FormData();

    formData.fields.add(MapEntry('message', message));

    if (images != null) {
      for (final image in images) {
        formData.files.add(MapEntry(
          'images[]',
          MultipartFile.fromFileSync(image),
        ));
      }
    }

    if (documents != null) {
      for (final document in documents) {
        formData.files.add(MapEntry(
          'documents[]',
          MultipartFile.fromFileSync(document),
        ));
      }
    }

    await dio.post(
      '/api/support-request/create',
      data: formData,
      options: Options(headers: {
        'Authorization': 'Bearer $token',
      }),
    );
  }
}
