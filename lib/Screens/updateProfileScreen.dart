import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rituniversity/Consents/apis.dart';
import 'package:rituniversity/Consents/colors.dart';
import 'package:rituniversity/Consents/helperfunctions.dart';
import 'package:rituniversity/Consents/routes.dart';
import 'package:rituniversity/Model/nationality.dart';
import 'package:rituniversity/Model/profile.dart';
import 'package:rituniversity/Model/profileUpdate.dart';
import 'package:rituniversity/Provider/authentication_provider.dart';
import 'package:rituniversity/Provider/credentialprovider.dart';
import 'package:rituniversity/Provider/studentProfileProvider.dart';
import 'package:rituniversity/Screens/studentProfile.dart';

class PatientUpdateScreen extends StatefulWidget {
  @override
  State<PatientUpdateScreen> createState() => _PatientUpdateScreenState();
}

class _PatientUpdateScreenState extends State<PatientUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  List<Nationality> _nationalities = [];
  List<String>? _currentPrograms;
  late bool showPassword;

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

  // Form field controllers
  final _nameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _contactPersonController = TextEditingController();
  final _guarantorRelationController = TextEditingController();
  final _emergencyContactNumberController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Dropdown values
  String? _selectedVisaStatus;
  String? _selectedGender;
  String? _selectedEmirate;
  String? _selectedResidence;
  String? _selectedMaritalStatus;
  String? _selectedNationality;
  String? _selectedSubject;
  String? _major;
  String? _academicYear;

  @override
  void initState() {
    super.initState();
    _currentPrograms = _ugPrograms;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadPatientData();
      _fetchNationalities();
    });
    showPassword = false;
  }

  Future<void> _fetchNationalities() async {
    StudentRegistrationProvider regProvider =
        Provider.of<StudentRegistrationProvider>(context, listen: false);
    try {
      List<Nationality> nationalities = await regProvider.fetchNationalities();

      setState(() {
        _nationalities = nationalities;
      });
    } catch (error) {
      print('Error fetching nationalities: $error');
    }
  }

  Future<void> _loadPatientData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final patientProvider =
        Provider.of<PatientProvider>(context, listen: false);
    final patientId = authProvider.userId.toString();

    setState(() {
      loading = true;
    });

    try {
      Patient? patient = await patientProvider.getPatientProfileData(patientId);
      if (patient != null) {
        setState(() {
          _nameController.text = patient.name;
          _middleNameController.text = patient.middleName;
          _lastNameController.text = patient.lastName;
          _dobController.text = patient.dob.toLocal().toString().split(' ')[0];
          _mobileNumberController.text = patient.mobileNumber;
          _emailController.text = patient.email;
          _addressController.text = patient.address;
          _contactPersonController.text = patient.contactPerson;
          _guarantorRelationController.text = patient.guarantorRelation;
          _emergencyContactNumberController.text =
              patient.emergencyContactNumber;
          _fatherNameController.text = patient.fatherName;
          _motherNameController.text = patient.motherName;
          _usernameController.text = patient.username;
          _usernameController.text = patient.username;
          _passwordController.text = patient.password;
          _selectedVisaStatus = visaStatusMap[patient.visaStatus];
          _selectedGender = genderMap[patient.gender];
          _selectedEmirate =
              emiratesMap[int.parse(patient.emirates.toString())];
          _selectedMaritalStatus = martialStatusMap[patient.maritalStatus];
          _selectedNationality = patient.nationality;
          _academicYear = patient.academicYear;
        });
      }
    } catch (error) {
      print('Error loading patient data: $error');
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _mobileNumberController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _contactPersonController.dispose();
    _guarantorRelationController.dispose();
    _emergencyContactNumberController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        toolbarHeight: 80,
        backgroundColor: mainColor,
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
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
              "Update Profile",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(
              color: mainColor,
            ))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter your name' : null,
                      ),
                      TextFormField(
                        controller: _middleNameController,
                        decoration:
                            const InputDecoration(labelText: 'Middle Name'),
                      ),
                      TextFormField(
                        controller: _lastNameController,
                        decoration:
                            const InputDecoration(labelText: 'Last Name'),
                        validator: (value) => value!.isEmpty
                            ? 'Please enter your last name'
                            : null,
                      ),
                      TextFormField(
                        controller: _mobileNumberController,
                        decoration:
                            const InputDecoration(labelText: 'Mobile Number'),
                        validator: (value) => value!.isEmpty
                            ? 'Please enter your mobile number'
                            : null,
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
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
                      TextFormField(
                        controller: _dobController,
                        decoration: const InputDecoration(labelText: 'DOB'),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter your DOB' : null,
                      ),
                      DropdownSearch<String>(
                        items: visaStatusMap.keys.toList(),
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Visa Status",
                          ),
                        ),
                        selectedItem: _selectedVisaStatus,
                        onChanged: (visaValue) {
                          setState(() {
                            _selectedVisaStatus = visaValue;
                          });
                        },
                        popupProps: PopupProps.dialog(
                          showSearchBox: true,
                          searchFieldProps: const TextFieldProps(
                            decoration: InputDecoration(
                              hintText: "Search",
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                            ),
                          ),
                          itemBuilder: _customPopupItemBuilder,
                        ),
                        validator: (value) => value == null
                            ? 'Please select your Visa Status'
                            : null,
                        dropdownBuilder: _customDropDown,
                      ),
                      DropdownSearch<String>(
                        items: genderMap.keys.toList(),
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Gender",
                          ),
                        ),
                        selectedItem: _selectedGender,
                        onChanged: (sexValue) {
                          setState(() {
                            _selectedGender = sexValue;
                          });
                        },
                        popupProps: PopupProps.dialog(
                          showSearchBox: true,
                          searchFieldProps: const TextFieldProps(
                            decoration: InputDecoration(
                              hintText: "Search",
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                            ),
                          ),
                          itemBuilder: _customPopupItemBuilder,
                        ),
                        validator: (value) =>
                            value == null ? 'Please select your Gender' : null,
                        dropdownBuilder: _customDropDown,
                      ),
                      DropdownSearch<String>(
                        items: martialStatusMap.keys.toList(),
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Marital Status",
                          ),
                        ),
                        selectedItem: _selectedMaritalStatus,
                        onChanged: (statusValue) {
                          setState(() {
                            _selectedMaritalStatus = statusValue;
                          });
                        },
                        popupProps: PopupProps.dialog(
                          showSearchBox: true,
                          searchFieldProps: const TextFieldProps(
                            decoration: InputDecoration(
                              hintText: "Search",
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                            ),
                          ),
                          itemBuilder: _customPopupItemBuilder,
                        ),
                        validator: (value) => value == null
                            ? 'Please select your Marital Status'
                            : null,
                        dropdownBuilder: _customDropDown,
                      ),
                      DropdownSearch<String>(
                        items: emiratesMap.keys.toList(),
                        dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            labelText: "Emirates",
                          ),
                        ),
                        selectedItem: _selectedEmirate,
                        onChanged: (new1Value) {
                          setState(() {
                            _selectedEmirate = new1Value;
                          });
                        },
                        popupProps: PopupProps.dialog(
                          showSearchBox: true,
                          searchFieldProps: const TextFieldProps(
                            decoration: InputDecoration(
                              hintText: "Search",
                              border: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                            ),
                          ),
                          itemBuilder: _customPopupItemBuilder,
                        ),
                        validator: (value) => value == null
                            ? 'Please select your emirates'
                            : null,
                        dropdownBuilder: _customDropDown,
                      ),
                      DropdownButtonFormField<String>(
                        elevation: 10,
                        value: _selectedNationality,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedNationality = newValue;
                          });
                        },
                        items: _nationalities.map((nationality) {
                          return DropdownMenuItem<String>(
                            value: nationality.id.toString(),
                            child: Text(nationality.name),
                          );
                        }).toList(),
                        decoration:
                            const InputDecoration(labelText: 'Nationality'),
                        validator: (value) => value == null
                            ? 'Please select your nationality'
                            : null,
                      ),
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
                        value: _selectedResidence,
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
                            _selectedResidence = residenceValue;
                          });
                        },
                      ),
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(labelText: 'Address'),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter your address' : null,
                      ),
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
                      TextFormField(
                        controller: _contactPersonController,
                        decoration:
                            const InputDecoration(labelText: 'Contact Person'),
                      ),
                      TextFormField(
                        controller: _guarantorRelationController,
                        decoration: const InputDecoration(
                            labelText: 'Guarantor Relation'),
                      ),
                      TextFormField(
                        controller: _emergencyContactNumberController,
                        decoration: const InputDecoration(
                            labelText: 'Emergency Contact Number'),
                      ),
                      TextFormField(
                        controller: _fatherNameController,
                        decoration:
                            const InputDecoration(labelText: 'Father Name'),
                      ),
                      TextFormField(
                        controller: _motherNameController,
                        decoration:
                            const InputDecoration(labelText: 'Mother Name'),
                      ),
                      TextFormField(
                        controller: _usernameController,
                        decoration:
                            const InputDecoration(labelText: 'Username'),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          suffixIcon: InkWell(
                            borderRadius: BorderRadius.circular(1000),
                            onTap: () {
                              setState(() {
                                showPassword = !showPassword;
                              });
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
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
                      ),
                    ],
                  ),
                ),
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
              _handleupdateProfile();
            },
            child: const Text(
              'Update',
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

  Future<void> _handleupdateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      final patientProvider =
          Provider.of<PatientProvider>(context, listen: false);
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final patientId = authProvider.userId.toString();

      final updatedData = PatientUpdateModel(
        id: patientId,
        name: _nameController.text,
        middleName: _middleNameController.text,
        lastName: _lastNameController.text,
        mobileNumber: _mobileNumberController.text,
        emailId: _emailController.text,
        address: _addressController.text,
        nationId: _selectedNationality!,
        residence: _selectedResidence!,
        subjectMajor: _major!,
        subject: _selectedSubject!,
        academicYear: _academicYear!,
        stateId: emiratesMap[_selectedEmirate]!,
        gender: genderMap[_selectedGender]!,
        maritalStatus: martialStatusMap[_selectedMaritalStatus]!,
        dateOfBirth: _dobController.text,
        visaStatus: visaStatusMap[_selectedVisaStatus]!,
        fatherName: _fatherNameController.text,
        motherName: _motherNameController.text,
        contactPerson: _contactPersonController.text,
        guarantorRelation: _guarantorRelationController.text,
        emergencyContactNumber: _emergencyContactNumberController.text,
        username: _usernameController.text,
        password: _passwordController.text,
      );

      print('Updated Data: ${updatedData.toJson()}');

      final response = await patientProvider.updatePatientProfile(updatedData);

      print('API Response: $response');

      final success = response['Success'] == true;
      final result = response['Result'] ?? 'Unknown result';

      if (success) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => PatientDetailsScreen(),
            ));
        _showErrorSnackBar('Succesfully Updated');
      } else {
        _showErrorSnackBar('Failed to update profile: $result');
      }
    } catch (e) {
      _showErrorSnackBar('Error updating profile: ${e.toString()}');
    } finally {
      setState(() => loading = false);
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _customDropDown(
    BuildContext context,
    String? item,
  ) {
    return Container(
      child: (item == null)
          ? const ListTile(
              contentPadding: EdgeInsets.all(0),
            )
          : ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Text(
                item,
              ),
            ),
    );
  }

  Widget _customPopupItemBuilder(
      BuildContext context, String item, bool isSelected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              border: Border.all(color: mainColor),
              borderRadius: BorderRadius.circular(10),
              color: contcolor,
            ),
      child: ListTile(
        selected: isSelected,
        title: Text(
          item,
          style: const TextStyle(color: mainColor),
        ),
      ),
    );
  }
}
