import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:rituniversity/Consents/colors.dart';
import 'package:rituniversity/Screens/ConstantScreens/aboutUs.dart';
import 'package:rituniversity/Screens/appoinments.dart';
import 'package:rituniversity/Screens/homePage.dart';
import 'package:rituniversity/Screens/ConstantScreens/privacyPolicy.dart';
import 'package:rituniversity/Screens/ConstantScreens/termsConditons.dart';
import 'package:rituniversity/Screens/studentProfile.dart';

class DrawerContent extends StatelessWidget {
  const DrawerContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      screens: [
        ScreenHiddenDrawer(
          ItemHiddenMenu(
              colorLineSelected: Colors.white,
              name: 'Booking',
              baseStyle: GoogleFonts.afacad(
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25)),
              selectedStyle: TextStyle()),
          const DoctorProfile(),
        ),
        ScreenHiddenDrawer(
          ItemHiddenMenu(
              colorLineSelected: Colors.white,
              name: 'Appointments',
              baseStyle: GoogleFonts.afacad(
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25)),
              selectedStyle: TextStyle()),
          Appoinment(),
        ),
        ScreenHiddenDrawer(
            ItemHiddenMenu(
                colorLineSelected: Colors.white,
                name: 'Profile',
                baseStyle: GoogleFonts.afacad(
                    textStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25)),
                selectedStyle: const TextStyle()),
            PatientDetailsScreen()),
        ScreenHiddenDrawer(
          ItemHiddenMenu(
              colorLineSelected: Colors.white,
              name: 'Privacy Policy',
              baseStyle: GoogleFonts.afacad(
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25)),
              selectedStyle: const TextStyle()),
          const PrivacyPolicyScreen(),
        ),
        ScreenHiddenDrawer(
          ItemHiddenMenu(
              colorLineSelected: Colors.white,
              name: 'Terms & Conditions',
              baseStyle: GoogleFonts.afacad(
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25)),
              selectedStyle: const TextStyle()),
          TermsAndConditionsPage(),
        ),
        ScreenHiddenDrawer(
          ItemHiddenMenu(
              colorLineSelected: Colors.white,
              name: 'About Us',
              baseStyle: GoogleFonts.afacad(
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25)),
              selectedStyle: const TextStyle()),
          AboutToplinePage(),
        ),
      ],
      backgroundMenu: const DecorationImage(
          image: AssetImage('assets/rit.png'), fit: BoxFit.cover),
      backgroundColorMenu: mainColor,
      disableAppBarDefault: true,
      initPositionSelected: 0,
      slidePercent: 60,
      contentCornerRadius: 50,
    );
  }
}
