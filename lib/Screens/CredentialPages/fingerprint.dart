import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rituniversity/Provider/fingerprintprovider.dart';

class FingerprintAuthScreen extends StatefulWidget {
  @override
  _FingerprintAuthScreenState createState() => _FingerprintAuthScreenState();
}

class _FingerprintAuthScreenState extends State<FingerprintAuthScreen> {
  @override
  void initState() {
    super.initState();
    _authenticate();
  }

  Future<void> _authenticate() async {
    final fingerprintProvider =
        Provider.of<FingerprintProvider>(context, listen: false);
    await fingerprintProvider.authenticate();
    if (fingerprintProvider.isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Drawer()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
