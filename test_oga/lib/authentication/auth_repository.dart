import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final storage = const FlutterSecureStorage();
  final dio = Dio(BaseOptions(baseUrl: 'https://test.tamga.com.kz'));
  

  Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }

  Future<String?> login(String phoneNumber, String password) async {
    try {
      final response = await dio.post(
        '/api/auth/login',
        data: {'phone_number': phoneNumber, 'password': password},
      );

      if (response.statusCode == 200) {
        final token = response.data['token'];
        await storage.write(key: 'auth_token', value: token);
        return token;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error logging in: $e');
      }
    }
    return null;
  }

  Future<void> logout() async {
    await storage.delete(key: 'auth_token');
  }
}