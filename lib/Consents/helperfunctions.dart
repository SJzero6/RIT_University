import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

showTextSnackBar(context, content) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(15),
      content: Text(
        '$content',
        style: GoogleFonts.montserrat(),
      )));
}

Map<String, String> visaStatusMap = {
  'Residence': '0',
  'RIT Visa': '1',
  'Study Abroad': '2',
  'Citizen': '3',
};

Map<String, String> martialStatusMap = {
  'single': '1',
  'married': '3',
  'Widow': '2',
  'Unknown': '0',
};
Map<String, String> genderMap = {
  'Male': '1',
  'Female': '3',
};

Map<String, String> emiratesMap = {
  'Abu dhabi': '1',
  'Ajman': '2',
  'Sharjah': '3',
  'Dubai': '4',
  'Fujairah': '5',
  'Ras al khaimah': '6',
  'Umm Al Quwain': '7',
  'Other': '8'
};
Map<int, String> getgenderMap = {
  1: 'Male',
  3: 'Female',
};

Map<int, String> getmartialStatusMap = {
  1: 'single',
  3: 'married',
  2: 'Widow',
  0: 'Unknown',
};

Map<int, String> getvisaStatusMap = {
  0: 'Residence',
  1: 'RIT Visa',
  2: 'Study Abroad',
  3: 'Citizen',
};

Map<int, String> getemiratesMap = {
  1: 'Abu dhabi',
  2: 'Ajman',
  3: 'Sharjah',
  4: 'Dubai',
  5: 'Fujairah',
  6: 'Ras al khaimah',
  7: 'Umm Al Quwain',
  8: 'Other'
};
