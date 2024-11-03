import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rituniversity/Consents/colors.dart';
import 'package:rituniversity/Consents/routes.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime selectedDate = DateTime.now();

    var format = DateFormat('yyyy/MM/dd').format(selectedDate);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [mainColor, secColor, terColor],
            ),
          ),
        ),
        automaticallyImplyLeading: false,
        toolbarHeight: 50,
        backgroundColor: mainColor,
        title: Row(children: [
          Container(
            margin: const EdgeInsets.only(top: 1),
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, AppRoutes.drawer);
              },
              child: Center(
                child: Image.asset(
                  "assets/back-arrow.png",
                  scale: 30,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Container(
            margin: const EdgeInsets.only(top: 1),
            child: const Text(
              "Privacy Policy",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ]),
      ),
      body: Stack(
        children: [
          Center(
              child: Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/rit.png',
                    opacity: const AlwaysStoppedAnimation(0.2),
                  ))),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    'Privacy Policy\n\n'
                    'Effective Date:$format \n\n'
                    'Thank you for using our Doctor Appointment Booking App ("App"). Your privacy is important to us. This Privacy Policy outlines how we collect, use, and protect your personal information.\n\n'
                    '1.Information We Collect\n\n'
                    '- Personal Information: When you use our App, we may collect personal information such as your name, contact details, medical history (if provided), and appointment preferences.\n\n'
                    '- Usage Data: We may collect information about how you interact with the App, such as the dates and times of your appointments.\n\n'
                    '2.How We Use Your Information\n\n'
                    '- To facilitate booking and managing appointments with healthcare providers.\n'
                    '- To improve our services and personalize your experience.\n'
                    '- To communicate with you, such as appointment reminders or important updates.\n'
                    '- To comply with legal obligations.\n\n'
                    '3.Data Security\n\n'
                    'We implement reasonable security measures to protect your personal information from unauthorized access, alteration, or disclosure.\n\n'
                    'Sharing of Information\n\n'
                    'We may share your information with healthcare providers to facilitate appointment bookings. We do not sell your personal information to third parties.\n\n'
                    '4.Your Choices\n\n'
                    'You have the right to access, correct, or delete your personal information. You may also choose to opt-out of certain communications.\n\n'
                    '5.Changes to This Policy\n\n'
                    'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new policy on this page.\n\n'
                    '6.Contact Us\n\n'
                    'If you have any questions about this Privacy Policy, please contact us at info@toplineuae.com.',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
