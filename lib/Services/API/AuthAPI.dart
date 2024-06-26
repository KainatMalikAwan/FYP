// lib/Services/API/AuthAPI.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';

class AuthAPI {
  final String _signinUrl = '${Config.baseUrl}/auth/signin';
  final String _docUrl= '${Config.baseUrlDoc}/auth/signin';

  Future<http.Response> signIn(String email, String password,bool f) async {
    final headers = {
      'Content-Type': 'application/json',

    };
    final body = jsonEncode({'email': email, 'password': password});
   if(f) {
     return await http.post(
         Uri.parse(_signinUrl), headers: headers, body: body);
   }else {

     return await http.post(
         Uri.parse(_docUrl), headers: headers, body: body);
   }
   }
  }





