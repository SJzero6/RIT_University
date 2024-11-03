import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rituniversity/Consents/apis.dart';
import 'package:rituniversity/Model/Registration.dart';
import 'package:rituniversity/Model/nationality.dart';
import 'package:rituniversity/Provider/authentication_provider.dart';

class StudentRegistrationProvider with ChangeNotifier {
  Future<void> registerStudent(StudentRegistration student) async {
    const url = baseUrl + registrationAPI;
    var headers = {
      'Content-Type': 'application/json',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(student.toJson()),
      );

      if (response.statusCode == 200) {
        print('Registration successful');
      } else {
        print(student);

        print('Failed to register: ${response.body}');
        throw Exception('Failed to register');
      }
    } catch (error) {
      print('Exception: $error');
      throw error;
    }
  }

  static Future<bool> loginRequest(AuthProvider authProvider,
      {required String username, required String password}) async {
    bool success = false;
    final url = Uri.parse(baseUrl + loginApi);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'Username': username,
        'Password': password,
      },
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      if (body["Success"] == true) {
        final result = body['Result'];
        if (result.isNotEmpty) {
          final user = result[0];
          final username = user['Username'];
          final userId = user["UserId"];
          authProvider.setUserInfo(username, userId);
          success = true;
        } else {
          authProvider.errorMessage = 'No user data found';
        }
      } else {
        authProvider.errorMessage = body['Message'] ?? 'Something went wrong';
      }
    } else {
      final body = json.decode(response.body);
      print(body);

      authProvider.errorMessage =
          'Request failed with status: ${response.statusCode}';
    }

    return success;
  }

  Future<List<Nationality>> fetchNationalities() async {
    final response = await http.get(
      Uri.parse(baseUrl + nationalityApi),
    );

    if (response.statusCode == 200) {
      List<Nationality> nationalities = [];
      List<dynamic> data = jsonDecode(response.body)['Result'];
      data.forEach((item) {
        nationalities.add(Nationality.fromJson(item));
      });
      return nationalities;
    } else {
      throw Exception('Failed to load nationalities');
    }
  }
}
