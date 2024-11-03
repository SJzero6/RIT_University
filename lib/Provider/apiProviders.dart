import 'dart:async';
import 'dart:convert';
//import 'package:DermaKlinic/Provider/DataModels/AppoinmentBookingData.dart'
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:rituniversity/Consents/apis.dart';
import 'package:rituniversity/Model/doctorProfile.dart';
import 'package:rituniversity/Model/timeslot_model.dart';
import 'package:rituniversity/Provider/authentication_provider.dart';

class ApiService extends ChangeNotifier {
  //final String baseUrl = 'http://tablet.wannagocloud.com:8101/DermaKlinic';

  //final String baseUrl = 'http://192.168.1.94:8200';

  final String apiKey;

  ApiService(this.apiKey);

  //final bookingApi = "/api/MobileApp/RitStudentDetails/BookAppointment?id=";

  Future<TimeslotResponse> fetchTimeslots(
      String fromDate, String toDate, int doctorId) async {
    final response = await http.get(Uri.parse(
        '$baseUrl/api/MobileApp/RitStudentDetails/DoctorAvailableTimeslots?from_date=$fromDate&to_date=$toDate&doctor_id=$doctorId'));

    if (response.statusCode == 200) {
      return TimeslotResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load timeslots');
    }
  }

  Future<List<DoctorData>> getDoctorData(
      AuthProvider authProvider, apiurl) async {
    final url = Uri.parse(baseUrl + apiurl);

    List<DoctorData> doctorData = [];

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      final result = body['Result'];
      for (var doctor in result) {
        DoctorData docData = DoctorData.fromJson(doctor);
        doctorData.add(docData);
        if (doctorData.isNotEmpty) {
          final docname = docData.DoctorName;
          final docid = docData.id;
          authProvider.setDoctorInfo(docname.toString(), docid);
        }
      }
    } else {
      throw Exception('Failed to load doctor data');
    }
    print(doctorData);
    return doctorData;
  }
}
