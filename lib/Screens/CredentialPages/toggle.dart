import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _enableFingerprint = false;

  @override
  void initState() {
    super.initState();
    _loadFingerprintSetting();
  }

  Future<void> _loadFingerprintSetting() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _enableFingerprint = prefs.getBool('enableFingerprint') ?? false;
    });
  }

  Future<void> _saveFingerprintSetting(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('enableFingerprint', value);
    setState(() {
      _enableFingerprint = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Enable Fingerprint Authentication:',
              style: TextStyle(fontSize: 18),
            ),
            Switch(
              value: _enableFingerprint,
              onChanged: (value) {
                _saveFingerprintSetting(value);
              },
            ),
            SizedBox(height: 20),
            Text(
              _enableFingerprint
                  ? 'Fingerprint Authentication is Enabled'
                  : 'Fingerprint Authentication is Disabled',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
