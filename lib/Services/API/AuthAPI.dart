// lib/Services/API/AuthAPI.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class AuthAPI {
  final String _signinUrl = '${Config.baseUrl}/auth/signin';
  final String _signoutUrl = '${Config.baseUrl}/auth/signout';

  Future<http.Response> signIn(String email, String password) async {
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer SD21rfjuBdOXSlbbOm0ee52UXnz2',
    };
    final body = jsonEncode({'email': email, 'password': password});

    return await http.post(Uri.parse(_signinUrl), headers: headers, body: body);
  }


}
