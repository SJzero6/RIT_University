import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rituniversity/Animation/Animation.Dart';
import 'package:rituniversity/Consents/colors.dart';
import 'package:rituniversity/Consents/helperfunctions.dart';
import 'package:rituniversity/Consents/routes.dart';
import 'package:rituniversity/Model/Registration.dart';
import 'package:rituniversity/Model/nationality.dart';
import 'dart:async';
import 'package:rituniversity/Provider/authentication_provider.dart';
import 'package:rituniversity/Provider/credentialprovider.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  String? _visaStatus; // Set initial value to null
  String? _gender; // Set initial value to null
  String? _selectedEmirate;
  String? _residence;
  String? _major;
  String? _academicYear;
  String? _martialStatus;
  String? _guarantorRelation;
  String? _selectNation;
  String? _selectedSubject;
  // Set initial value to null

  late bool showPassword;
  late bool showConfirmPassword;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobileNumController = TextEditingController();
  final TextEditingController _studentIdController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _fatherController = TextEditingController();
  final TextEditingController _mothercontroller = TextEditingController();
  final TextEditingController _contactPersoncontroller =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emergancyContactNumber = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _confirmpasswordcontroller =
      TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  List<Nationality> _nationality = [];

  List<String>? _currentPrograms;

  final List<String> _ugPrograms = [
    'GLOBAL BUSINESS MANAGEMENT',
    'MARKETING',
    'ELECTRICAL ENGINEERING',
    'COMPUTING AND INFORMATION TECHNOLOGIES',
    'CYBERSECURITY',
    'PSYCHOLOGY',
    'FINANCE',
    'MECHANICAL ENGINEERING',
    'INDUSTRIAL ENGINEERING',
    'FINE ARTS IN NEW MEDIA DESIGN',
  ];

  final List<String> _pgPrograms = [
    'ELECTRICAL ENGINEERING',
    'COMPUTING SECURITY',
    'ORGANIZATIONAL LEADERSHIP AND INNOVATION',
    'PROFESSIONAL STUDIES:DATA ANALYTICS',
    'MECHANICAL ENGINEERING',
    'ENGINEERING IN ENGINEERING MANAGEMENT',
    'PROFESSIONAL STUDIES:SMART CITIES',
    'PROFESSIONAL STUDIES:FUTURE FORESIGHT AND PLANNING',
  ];

  @override
  void initState() {
    StudentRegistrationProvider regProvider =
        Provider.of<StudentRegistrationProvider>(context, listen: false);
    // TODO: implement initState
    super.initState();
    _currentPrograms = _ugPrograms;
    regProvider.fetchNationalities().then((nationalities) {
      setState(() {
        _nationality = nationalities;
      });
    }).catchError((error) {
      print('Error fetching nationalities: $error');
    });

    showPassword = false;
    showConfirmPassword = false;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _mobileNumController.dispose();
    _studentIdController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _dobController.dispose();
    _fatherController.dispose();
    _mothercontroller.dispose();
    _contactPersoncontroller.dispose();
    _emergancyContactNumber.dispose();
    _usernameController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.orange, // Change the color here
              onPrimary: Colors.white, // Text color
              onSurface: Colors.black, // Date numbers color
            ),
            dialogBackgroundColor: terColor, // Background color
          ),
          child: child!,
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [mainColor, secColor, terColor],
          ),
        ),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeAnimation(
                      1,
                      Text(
                        "Register",
                        style: GoogleFonts.alef(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    FadeAnimation(
                      1.2,
                      const Text(
                        "Here !",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(225, 95, 27, .3),
                          blurRadius: 20,
                          offset: Offset(0, 10),
                        )
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Form(
                        key: _formKey,
                        child: ListView(
                          children: [
                            FadeAnimation(
                              1.3,
                              TextFormField(
                                controller: _firstNameController,
                                decoration: const InputDecoration(
                                  hintText: 'First Name',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: buttonColor),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your first name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            FadeAnimation(
                              1.4,
                              TextFormField(
                                controller: _middleNameController,
                                decoration: const InputDecoration(
                                    hintText: 'Middle Name'),
                              ),
                            ),
                            const SizedBox(height: 20),
                            FadeAnimation(
                              1.5,
                              TextFormField(
                                controller: _lastNameController,
                                decoration: const InputDecoration(
                                    hintText: 'Last Name'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your last name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            FadeAnimation(
                              1.9,
                              TextFormField(
                                controller: _mobileNumController,
                                decoration: const InputDecoration(
                                    hintText: 'Mobile No'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your Mobile No';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            FadeAnimation(
                              1.6,
                              TextFormField(
                                controller: _studentIdController,
                                decoration: const InputDecoration(
                                  hintText: 'Student ID',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: buttonColor),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your student ID';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            FadeAnimation(
                              1.8,
                              TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  hintText: 'Email ID',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: buttonColor),
                                  ),
                                ),
                                validator: (value) {
                                  String pattern =
                                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                      r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                                      r"{0,253}[a-zA-Z0-9])?)*$";
                                  RegExp regex = new RegExp(pattern);
                                  if (value == null ||
                                      value.isEmpty ||
                                      !regex.hasMatch(value)) {
                                    return 'Please enter a valid your email ID';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            FadeAnimation(
                              1.10,
                              TextFormField(
                                controller: _addressController,
                                decoration: const InputDecoration(
                                  hintText: 'Address',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: buttonColor),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            FadeAnimation(
                              1.15,
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  hintText: 'Nationality',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: buttonColor),
                                  ),
                                ),
                                hint: const Text(
                                    'Select Nationality'), // Set hint
                                value: _selectNation,
                                items:
                                    _nationality.map((Nationality nationality) {
                                  return DropdownMenuItem(
                                    value: nationality.id
                                        .toString(), // Use ID as value
                                    child: Text(nationality
                                        .name), // Display nationality name
                                  );
                                }).toList(),
                                onChanged: (nationValue) {
                                  setState(() {
                                    _selectNation = nationValue;
                                    print(nationValue);
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            FadeAnimation(
                              1.15,
                              DropdownButtonFormField<String>(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select your Residence';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Residence',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: buttonColor),
                                  ),
                                ),
                                hint: const Text('Residence'), // Set hint
                                value: _residence,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Family',
                                    child: Text('Family'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Alone',
                                    child: Text('Alone'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'RIT Campus',
                                    child: Text('RIT Campus'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Hotel',
                                    child: Text('Hotel'),
                                  ),
                                ],
                                onChanged: (residenceValue) {
                                  setState(() {
                                    _residence = residenceValue;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            FadeAnimation(
                              1.15,
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  hintText: '_Major Subject',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: mainColor),
                                  ),
                                ),
                                hint: const Text('Major'), // Set hint
                                value: _major,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'UG',
                                    child: Text('UG'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'PG',
                                    child: Text('PG'),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _major = value;

                                    if (_major == 'UG') {
                                      _currentPrograms = _ugPrograms;
                                    } else if (_major == 'PG') {
                                      _currentPrograms = _pgPrograms;
                                    } else {
                                      _currentPrograms = null;
                                    }
                                    _selectedSubject = null;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            FadeAnimation(
                              1.13,
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  hintText: 'Subject',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: mainColor),
                                  ),
                                ),
                                value: _selectedSubject,
                                items: _currentPrograms?.map((program) {
                                  return DropdownMenuItem(
                                    value: program,
                                    child: Text(
                                      program,
                                      style: const TextStyle(fontSize: 13),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedSubject = value;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            FadeAnimation(
                              1.15,
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  hintText: 'Academic Year',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: buttonColor),
                                  ),
                                ),
                                hint: const Text('Academic Year'), // Set hint
                                value: _academicYear,
                                items: const [
                                  DropdownMenuItem(
                                    value: '1',
                                    child: Text('1'),
                                  ),
                                  DropdownMenuItem(
                                    value: '2',
                                    child: Text('2'),
                                  ),
                                  DropdownMenuItem(
                                    value: '3',
                                    child: Text('3'),
                                  ),
                                  DropdownMenuItem(
                                    value: '4',
                                    child: Text('4'),
                                  ),
                                  DropdownMenuItem(
                                    value: '5',
                                    child: Text('5'),
                                  ),
                                ],
                                onChanged: (yearValue) {
                                  setState(() {
                                    _academicYear = yearValue;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            FadeAnimation(
                              1.17,
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  hintText: 'Emirate',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: buttonColor),
                                  ),
                                ),
                                hint: const Text('Emirates'), // Set hint
                                value: _selectedEmirate,
                                items: emiratesMap.entries.map((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.value,
                                    child: Text(entry.key),
                                  );
                                }).toList(),
                                onChanged: (stateValue) {
                                  setState(() {
                                    _selectedEmirate = stateValue;
                                    print(stateValue);
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            FadeAnimation(
                              1.16,
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  hintText: 'Gender',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: buttonColor),
                                  ),
                                ),
                                hint: const Text('Gender'),
                                value: _gender,
                                items: genderMap.entries.map((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.value,
                                    child: Text(entry.key),
                                  );
                                }).toList(),
                                onChanged: (genderValue) {
                                  setState(() {
                                    _gender = genderValue;
                                    print(genderValue);
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            FadeAnimation(
                              1.15,
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  hintText: 'Martial Status',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: buttonColor),
                                  ),
                                ),
                                hint: const Text('Martial Status'), // Set hint
                                value: _martialStatus,
                                items: martialStatusMap.entries.map((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.value,
                                    child: Text(entry.key),
                                  );
                                }).toList(),
                                onChanged: (maritalValue) {
                                  setState(() {
                                    _martialStatus = maritalValue;
                                    print(maritalValue);
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            FadeAnimation(
                              1.7,
                              TextFormField(
                                controller: _dobController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: buttonColor),
                                  ),
                                  hintText: 'Pick Your DOB',
                                  suffixIcon: IconButton(
                                    icon: const Icon(
                                      Icons.calendar_today,
                                      color: buttonColor,
                                    ),
                                    onPressed: () => _selectDate(context),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your DOB';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            FadeAnimation(
                              1.15,
                              DropdownButtonFormField<String>(
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select your Residence';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Visa Status',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: buttonColor),
                                  ),
                                ),
                                hint: const Text('Visa Status'),
                                value: _visaStatus,
                                items: visaStatusMap.entries.map((entry) {
                                  return DropdownMenuItem<String>(
                                    value: entry.value,
                                    child: Text(entry.key),
                                  );
                                }).toList(),
                                onChanged: (visaValue) {
                                  setState(() {
                                    _visaStatus = visaValue;
                                    print(visaValue);
                                  });
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            FadeAnimation(
                              1.13,
                              TextFormField(
                                controller: _fatherController,
                                decoration: const InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: buttonColor),
                                    ),
                                    hintText: 'Father Name'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your Father Name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            FadeAnimation(
                              1.13,
                              TextFormField(
                                controller: _mothercontroller,
                                decoration: const InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: buttonColor),
                                    ),
                                    hintText: 'Mother Name'),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your Mother Name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            FadeAnimation(
                              1.13,
                              TextFormField(
                                controller: _contactPersoncontroller,
                                decoration: const InputDecoration(
                                  hintText: 'Contact Person',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: buttonColor),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                hintText: 'Guarantor Relation',
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: buttonColor),
                                ),
                              ),
                              hint:
                                  const Text('Guarantor Relation'), // Set hint
                              value: _guarantorRelation,
                              items: const [
                                DropdownMenuItem(
                                  value: 'Associate',
                                  child: Text('Associate'),
                                ),
                                DropdownMenuItem(
                                  value: 'Brother',
                                  child: Text('Brother'),
                                ),
                                DropdownMenuItem(
                                  value: 'Care giver',
                                  child: Text('Care giver'),
                                ),
                                DropdownMenuItem(
                                  value: 'Handicapped dependent',
                                  child: Text('Handicapped dependent'),
                                ),
                                DropdownMenuItem(
                                  value: 'Life partner',
                                  child: Text('Life partner'),
                                ),
                                DropdownMenuItem(
                                  value: 'Emergency contact',
                                  child: Text('Emergency contact'),
                                ),
                                DropdownMenuItem(
                                  value: 'Employee',
                                  child: Text('Employee'),
                                ),
                                DropdownMenuItem(
                                  value: 'Employer',
                                  child: Text('Employer'),
                                ),
                                DropdownMenuItem(
                                  value: 'Extended family',
                                  child: Text('Extended family'),
                                ),
                                DropdownMenuItem(
                                  value: 'Foster child',
                                  child: Text('Foster child'),
                                ),
                                DropdownMenuItem(
                                  value: 'Friend',
                                  child: Text('Friend'),
                                ),
                                DropdownMenuItem(
                                  value: 'Father',
                                  child: Text('Father'),
                                ),
                                DropdownMenuItem(
                                  value: 'Grandchild',
                                  child: Text('Grandchild'),
                                ),
                                DropdownMenuItem(
                                  value: 'Guardian',
                                  child: Text('Guardian'),
                                ),
                                DropdownMenuItem(
                                  value: 'Grandparent',
                                  child: Text('Grandparent'),
                                ),
                                DropdownMenuItem(
                                  value: 'Manager',
                                  child: Text('Manager'),
                                ),
                                DropdownMenuItem(
                                  value: 'Mother',
                                  child: Text('Mother'),
                                ),
                                DropdownMenuItem(
                                  value: 'Natural child',
                                  child: Text('Natural child'),
                                ),
                                DropdownMenuItem(
                                  value: 'None',
                                  child: Text('None'),
                                ),
                                DropdownMenuItem(
                                  value: 'Other adult',
                                  child: Text('Other adult'),
                                ),
                                DropdownMenuItem(
                                  value: 'Other',
                                  child: Text('Other'),
                                ),
                                DropdownMenuItem(
                                  value: 'Owner',
                                  child: Text('Owner'),
                                ),
                                DropdownMenuItem(
                                  value: 'Parent',
                                  child: Text('Parent'),
                                ),
                                DropdownMenuItem(
                                  value: 'Stepchild',
                                  child: Text('Stepchild'),
                                ),
                                DropdownMenuItem(
                                  value: 'Self',
                                  child: Text('Self'),
                                ),
                                DropdownMenuItem(
                                  value: 'Sibling',
                                  child: Text('Sibling'),
                                ),
                                DropdownMenuItem(
                                  value: 'Sister',
                                  child: Text('Sister'),
                                ),
                                DropdownMenuItem(
                                  value: 'Spouse',
                                  child: Text('Spouse'),
                                ),
                                DropdownMenuItem(
                                  value: 'Trainer',
                                  child: Text('Trainer'),
                                ),
                                DropdownMenuItem(
                                  value: 'Unknown',
                                  child: Text('Unknown'),
                                ),
                                DropdownMenuItem(
                                  value: 'Ward of court',
                                  child: Text('Ward of court'),
                                ),
                              ],
                              onChanged: (newValue) {
                                setState(() {
                                  _guarantorRelation = newValue;
                                });
                              },
                            ),
                            const SizedBox(height: 20),
                            FadeAnimation(
                              1.13,
                              TextFormField(
                                controller: _emergancyContactNumber,
                                decoration: const InputDecoration(
                                  hintText: 'Emergency Contact number',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: buttonColor),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            FadeAnimation(
                              1.13,
                              TextFormField(
                                controller: _usernameController,
                                decoration: const InputDecoration(
                                  hintText: 'Username',
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: buttonColor),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            FadeAnimation(
                              1.18,
                              TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: buttonColor),
                                  ),
                                  hintText: 'Enter Password',
                                  suffixIcon: InkWell(
                                    borderRadius: BorderRadius.circular(1000),
                                    onTap: () {
                                      setState(() {
                                        showPassword = !showPassword;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Icon(
                                        showPassword
                                            ? Icons.visibility_off
                                            : Icons.remove_red_eye,
                                        color: mainColor,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                obscureText: !showPassword,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            FadeAnimation(
                              1.19,
                              TextFormField(
                                controller: _confirmpasswordcontroller,
                                decoration: InputDecoration(
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(color: buttonColor),
                                  ),
                                  hintText: 'Confirm Password',
                                  suffixIcon: InkWell(
                                    borderRadius: BorderRadius.circular(1000),
                                    onTap: () {
                                      setState(() {
                                        showConfirmPassword =
                                            !showConfirmPassword;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Icon(
                                        showConfirmPassword
                                            ? Icons.visibility_off
                                            : Icons.remove_red_eye,
                                        color: mainColor,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                                obscureText: !showConfirmPassword,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Center(
                  //   child: Opacity(
                  //     opacity: 0.1,
                  //     child: Image.asset(
                  //       'assets/rit.png', // Ensure this image path is correct
                  //       fit: BoxFit.contain,
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
            left: 16.0, right: 16.0, bottom: 16.0, top: 16.0),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
            ),
            onPressed: () {
              _handleRegistration();
            },
            child: const Text(
              'Register',
              style: TextStyle(
                fontSize: 25,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _handleRegistration() {
    if (_firstNameController.text.isEmpty) {
      showTextSnackBar(context, 'First Name can\'t be empty');
      return;
    }
    if (_lastNameController.text.isEmpty) {
      showTextSnackBar(context, 'Last Name can\'t be empty');
      return;
    }
    if (_mobileNumController.text.isEmpty) {
      showTextSnackBar(context, 'Mobile Number can\'t be empty');
      return;
    }
    if (_studentIdController.text.isEmpty) {
      showTextSnackBar(context, 'Student ID can\'t be empty');
      return;
    }
    if (_dobController.text.isEmpty) {
      showTextSnackBar(context, 'DOB can\'t be empty');
      return;
    }
    if (_fatherController.text.isEmpty) {
      showTextSnackBar(context, 'DOB can\'t be empty');
      return;
    }
    if (_mothercontroller.text.isEmpty) {
      showTextSnackBar(context, 'DOB can\'t be empty');
      return;
    }
    if (_usernameController.text.isEmpty) {
      showTextSnackBar(context, 'Username can\'t be empty');
      return;
    }
    if (_passwordController.text.isEmpty) {
      showTextSnackBar(context, 'Enter a password');
      return;
    }
    if (_confirmpasswordcontroller.text.isEmpty) {
      showTextSnackBar(context, 'Confirm password');
      return;
    }

    if (_confirmpasswordcontroller.text.length < 6) {
      showTextSnackBar(context, 'Password too short');
      return;
    }

    if (_passwordController.text != _confirmpasswordcontroller.text) {
      showTextSnackBar(context, 'Passwords don\'t match');
      return;
    }

    if (_formKey.currentState!.validate()) {
      final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
      final String formattedDate =
          dateFormat.format(DateTime.parse(_dobController.text));

      final student = StudentRegistration(
        name: _firstNameController.text,
        middleName: _middleNameController.text,
        lastName: _lastNameController.text,
        mobileNumber: _mobileNumController.text,
        filenumber: _studentIdController.text,
        emailId: _emailController.text,
        address: _addressController.text,
        nationId: _selectNation ?? 'NULL',
        residence: _residence ?? 'NULL',
        subjectMajor: _major ?? 'NULL',
        subject: _selectedSubject ?? 'NULL',
        academicYear: _academicYear ?? 'NULL',
        stateId: _selectedEmirate ?? 'NULL',
        gender: _gender ?? 'NULL',
        martialStatus: _martialStatus ?? 'NULL',
        dateOfBirth: formattedDate,
        visaStatus: _visaStatus ?? 'NULL',
        fatherName: _fatherController.text,
        motherName: _mothercontroller.text,
        contactPerson: _contactPersoncontroller.text,
        guarantorRelation: _guarantorRelation ?? 'NULL',
        emergencyContactNumber: _emergancyContactNumber.text,
        username: _usernameController.text,
        password: _passwordController.text,
      );

      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final studentRegistrationProvider =
          Provider.of<StudentRegistrationProvider>(context, listen: false);

      authProvider.clearError();
      authProvider.anApiStarted();

      studentRegistrationProvider.registerStudent(student).then((_) {
        authProvider.anApiStopped();
        showTextSnackBar(context, 'Registration Success');
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      }).catchError((error) {
        authProvider.anApiStopped();
        showTextSnackBar(context, 'Registration Error: $error');
      });
    } else {
      showTextSnackBar(context, 'Please fill out all required fields');
    }
  }
}
