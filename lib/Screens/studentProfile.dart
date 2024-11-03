import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rituniversity/Animation/Animation.Dart';
import 'package:rituniversity/Consents/routes.dart';
import 'package:rituniversity/Model/profile.dart';
import 'package:rituniversity/Provider/studentProfileProvider.dart';
import 'package:rituniversity/Provider/authentication_provider.dart';
import 'package:rituniversity/Consents/colors.dart';
import 'package:rituniversity/Consents/helperfunctions.dart';
import 'package:rituniversity/Screens/CredentialPages/loginpage.dart';
import 'package:rituniversity/Screens/updateProfileScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientDetailsScreen extends StatefulWidget {
  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  bool loading = false;
  List<Patient> profileData = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
    //_loadFingerprintSetting();
  }

  Future<void> _fetchData() async {
    try {
      final patientProvider =
          Provider.of<PatientProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final patientId = authProvider.userId.toString();

      setState(() {
        loading = true;
      });

      Patient? patient = await patientProvider.getPatientProfileData(patientId);

      setState(() {
        loading = false;
        if (patient != null) {
          profileData = [patient];
        } else {
          //print("kaaalan:$profileData");
          _showErrorSnackbar('Unable to fetch patient data');
        }
      });
    } catch (e) {
      setState(() {
        loading = false;
      });
      _showErrorSnackbar('Error fetching data: $e');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  String getStatus(String genderValue, Map<int, String> genderMap) {
    final int? genderInt = int.tryParse(genderValue);
    if (genderInt != null) {
      return genderMap[genderInt] ?? 'Unknown';
    }
    return 'Invalid';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(
              color: mainColor,
            ))
          : Stack(
              children: [
                Center(
                  child: Image.asset(
                    'assets/rit.png',
                    opacity: const AlwaysStoppedAnimation(0.2),
                  ),
                ),
                _buildProfileDetails(),
              ],
            ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      actions: [
        IconButton(
            onPressed: () {
              _showBottomSheet(context);
            },
            icon: Icon(
              Icons.expand_more,
              color: Colors.white,
            ))
      ],
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
      toolbarHeight: 80,
      backgroundColor: mainColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
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
              const SizedBox(width: 20),
              const Text(
                "Profile",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          TextButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientUpdateScreen(),
                    ));
              },
              child: const Text(
                'Edit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ))
        ],
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    // Access the provider with listen: false
    // final fingerprintProvider =
    //     Provider.of<FingerprintProvider>(context, listen: false);

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              // ListTile(
              //   leading: const Icon(
              //     Icons.fingerprint,
              //     color: mainColor,
              //   ),
              //   title: Text(
              //     fingerprintProvider.isAuthenticated
              //         ? 'Fingerprint Enabled'
              //         : 'Fingerprint Disabled',
              //   ),
              //   trailing: Switch(
              //     value: fingerprintProvider.isAuthenticated,
              //     onChanged: (bool value) {
              //       if (value) {
              //         fingerprintProvider.authenticate();
              //       } else {
              //         fingerprintProvider.resetAuthentication();
              //       }
              //     },
              //   ),
              // ),
              ListTile(
                leading: const Icon(
                  Icons.logout_outlined,
                  color: mainColor,
                ),
                title: const Text('Logout'),
                onTap: () {
                  // Handle the logout action
                  showLogOutAccountDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileDetails() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        margin: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSection(
                'Personal Information',
                [
                  _buildCard([
                    _buildRow(
                      'Name :',
                      profileData.isNotEmpty
                          ? '${profileData[0].name} ${profileData[0].middleName} ${profileData[0].lastName}'
                          : 'N/A',
                      'Date of Birth :',
                      profileData.isNotEmpty
                          ? '${profileData[0].dob.toLocal()}'.split(' ')[0]
                          : 'N/A',
                    ),
                    const SizedBox(height: 10),
                    _buildRow(
                      'Marital Status :',
                      profileData.isNotEmpty
                          ? getStatus(profileData[0].maritalStatus.toString(),
                              getmartialStatusMap)
                          : 'N/A',
                      'Gender :',
                      profileData.isNotEmpty
                          ? getStatus(
                              profileData[0].gender.toString(), getgenderMap)
                          : 'N/A',
                    ),
                  ], 1.0),
                ],
                1.0),
            _buildSection(
                'Contact Information',
                [
                  _buildCard([
                    _buildRow(
                      'Mobile :',
                      profileData.isNotEmpty
                          ? profileData[0].mobileNumber
                          : 'N/A',
                      'Email :',
                      profileData.isNotEmpty ? profileData[0].email : 'N/A',
                    ),
                    const SizedBox(height: 10),
                    _buildRow(
                      'Address :',
                      profileData.isNotEmpty ? profileData[0].address : 'N/A',
                    ),
                  ], 1.1),
                ],
                1.1),
            _buildSection(
                'Nationality & Residence',
                [
                  _buildCard([
                    _buildRow(
                      'Nationality :',
                      profileData.isNotEmpty
                          ? profileData[0].nationality
                          : 'N/A',
                      'Residence :',
                      profileData.isNotEmpty ? profileData[0].residence : 'N/A',
                    ),
                    const SizedBox(height: 10),
                    _buildListTile(
                      'Emirates :',
                      profileData.isNotEmpty ? profileData[0].emirates : 'N/A',
                    ),
                  ], 1.2),
                ],
                1.2),
            _buildSection(
                'Academic Information',
                [
                  _buildCard([
                    _buildRow(
                      'Subject Major :',
                      profileData.isNotEmpty
                          ? profileData[0].subjectMajor
                          : 'N/A',
                      'Academic Year :',
                      profileData.isNotEmpty
                          ? profileData[0].academicYear
                          : 'N/A',
                    ),
                    const SizedBox(height: 10),
                    _buildListTile(
                      'Subject :',
                      profileData.isNotEmpty ? profileData[0].subject : 'N/A',
                    ),
                  ], 1.3),
                ],
                1.3),
            _buildSection(
                'Emergency Contact',
                [
                  _buildCard([
                    _buildRow(
                      'Emergency Contact\nPerson :',
                      profileData.isNotEmpty
                          ? profileData[0].contactPerson
                          : 'N/A',
                      'Guarantor\nRelation :',
                      profileData.isNotEmpty
                          ? profileData[0].guarantorRelation
                          : 'N/A',
                    ),
                    const SizedBox(height: 10),
                    _buildListTile(
                      'Emergency Contact\nNumber :',
                      profileData.isNotEmpty
                          ? profileData[0].emergencyContactNumber
                          : 'N/A',
                    ),
                  ], 1.4),
                ],
                1.4),
            _buildSection(
                'Other Information',
                [
                  _buildCard([
                    _buildRow(
                      'Father\'s Name',
                      profileData.isNotEmpty
                          ? profileData[0].fatherName
                          : 'N/A',
                      'Visa Status',
                      profileData.isNotEmpty
                          ? getStatus(profileData[0].visaStatus.toString(),
                              getvisaStatusMap)
                          : 'N/A',
                    ),
                    _buildListTile(
                      'Mother\'s Name',
                      profileData.isNotEmpty
                          ? profileData[0].motherName
                          : 'N/A',
                    ),
                  ], 1.5),
                ],
                1.5),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children, double delay) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeAnimation(
          delay,
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              title,
              style: GoogleFonts.candal(
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: mainColor,
                ),
              ),
            ),
          ),
        ),
        const Divider(color: blurcolor),
        ...children,
      ],
    );
  }

  Widget _buildCard(List<Widget> children, double delay) {
    return FadeAnimation(
      delay,
      Card(
        color: contcolor,
        elevation: 10,
        child: Container(
          margin: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String title1, String subtitle1,
      [String? title2, String? subtitle2]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildListTile(title1, subtitle1),
        if (title2 != null && subtitle2 != null)
          _buildListTile(title2, subtitle2),
      ],
    );
  }

  Widget _buildListTile(String title, String subtitle) {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.abel(
                textStyle: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Text(
            subtitle,
            style: GoogleFonts.cardo(textStyle: const TextStyle()),
          ),
        ],
      ),
    );
  }

  void showLogOutAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: contcolor,
          title: const Text(
            'Logout Account',
            style: TextStyle(color: mainColor),
          ),
          content: const Text(
            'Are you sure you want to Logout your account? This action cannot be undone.',
            style: TextStyle(color: mainColor),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: mainColor),
              ),
            ),
            TextButton(
              onPressed: () {
                _logout(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text(
                'LogOut',
                style: TextStyle(color: mainColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('UserId');
    prefs.remove('profileImagePath');
  }
}
