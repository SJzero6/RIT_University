import 'package:flutter/material.dart';
import 'package:rituniversity/Consents/routes.dart';
import 'package:provider/provider.dart';
import 'package:rituniversity/Provider/apiProviders.dart';
import 'package:rituniversity/Provider/appoinmentProvider.dart';
import 'package:rituniversity/Provider/authentication_provider.dart';
import 'package:rituniversity/Provider/credentialprovider.dart';
import 'package:rituniversity/Provider/fingerprintprovider.dart';
import 'package:rituniversity/Provider/studentProfileProvider.dart';
import 'package:rituniversity/Provider/timeslotProvider.dart';
import 'package:rituniversity/Provider/bookingProvider.dart';

// import 'package:flutter/rendering.dart';

void main() {
  //debugPaintSizeEnabled = true;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ApiService("")),
        ChangeNotifierProvider(create: (_) => TimeslotProvider()),
        ChangeNotifierProvider(create: (_) => StudentRegistrationProvider()),
        ChangeNotifierProvider(create: (_) => SlotBookingProvider()),
        ChangeNotifierProvider(create: (_) => AppointmentProvider()),
        ChangeNotifierProvider(create: (_) => PatientProvider()),
        ChangeNotifierProvider(create: (_) => FingerprintProvider()),
      ],
      child: MaterialApp(
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.routes,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
