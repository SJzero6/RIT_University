import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rituniversity/Consents/routes.dart';
import 'package:rituniversity/Provider/fingerprintprovider.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigatetohome();
  }

  void _navigatetohome() {
    Future.delayed(const Duration(milliseconds: 3500), () async {
      final fingerprintProvider =
          Provider.of<FingerprintProvider>(context, listen: false);
      if (fingerprintProvider.isFingerprintSupported &&
          !fingerprintProvider.isAuthenticated) {
        Navigator.pushReplacementNamed(context, AppRoutes.finger);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: Image.asset('assets/rit.gif')),
    );
  }
}
