import 'package:flutter/material.dart';
import 'package:rituniversity/Screens/appoinments.dart';

import 'package:rituniversity/Screens/drawer.dart';
import 'package:rituniversity/Screens/CredentialPages/fingerprint.dart';
import 'package:rituniversity/Screens/homePage.dart';
import 'package:rituniversity/Screens/CredentialPages/loginpage.dart';
import 'package:rituniversity/Screens/splash.dart';
import 'package:rituniversity/Screens/studentProfile.dart';
import '../Screens/CredentialPages/registration_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String finger = '/finger';
  static const String login = '/login';
  static const String register = '/register';
  static const String doctorProfile = '/doctorprofile';
  static const String drawer = '/drawer';
  static const String viewAppoinments = '/viewAppoinmnets';
  static const String studentDetails = '/studentdetails';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => const Splash(),
    finger: (context) => FingerprintAuthScreen(),
    login: (context) => const LoginPage(),
    register: (context) => const RegistrationPage(),
    doctorProfile: (context) => const DoctorProfile(),
    drawer: (context) => const DrawerContent(),
    viewAppoinments: (context) => Appoinment(),
    studentDetails: (context) => PatientDetailsScreen(),
  };
}
