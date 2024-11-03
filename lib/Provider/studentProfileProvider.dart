import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:rituniversity/Consents/apis.dart';
import 'package:rituniversity/Model/profile.dart';
import 'package:rituniversity/Model/profileUpdate.dart';

class PatientProvider with ChangeNotifier {
  Future<Patient?> getPatientProfileData(String apiurl) async {
    final url = Uri.parse(baseUrl + studentProfile + apiurl);

    try {
      var response = await http.get(url);

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);

        print('Response body: $body');

        if (body['Result'] != null) {
          var profileDataJson = body['Result'];

          print("Jumbooooooooooooo::::$profileDataJson");

          try {
            var patientData = Patient.fromJson(profileDataJson);
            return patientData;
          } catch (e) {
            print(e.toString());
            return null;
          }
        } else {
          print(
              'Invalid response format. Expected a non-null object under "Result".');
        }
      } else {
        print('HTTP request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error during HTTP request: $e');
    }

    return null;
  }

  Future<Map<String, dynamic>> updatePatientProfile(
      PatientUpdateModel updatedData) async {
    try {
      final response = await http.put(
        Uri.parse(baseUrl + updateProfile),
        body: jsonEncode(updatedData.toJson()),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      // Print status code and body for debugging
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to update profile. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception in updatePatientProfile: $e');
      throw e;
    }
  }
}
