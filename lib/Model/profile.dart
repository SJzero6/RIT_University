class Patient {
  final int id;
  final String patientName;
  final String name;
  final String middleName;
  final String lastName;
  final String mobileNumber;
  final String email;
  final String address;
  final int nationId;
  final String nationality;
  final String residence;
  final String subjectMajor;
  final String subject;
  final String academicYear;
  final int stateId;
  final String emirates;
  final int gender;
  final int maritalStatus;
  final DateTime dob;
  final int visaStatus;
  final String fatherName;
  final String motherName;
  final String contactPerson;
  final String guarantorRelation;
  final String emergencyContactNumber;
  final String username;
  final String password;

  Patient({
    required this.id,
    required this.patientName,
    required this.name,
    required this.middleName,
    required this.lastName,
    required this.mobileNumber,
    required this.email,
    required this.address,
    required this.nationId,
    required this.nationality,
    required this.residence,
    required this.subjectMajor,
    required this.subject,
    required this.academicYear,
    required this.stateId,
    required this.emirates,
    required this.gender,
    required this.maritalStatus,
    required this.dob,
    required this.visaStatus,
    required this.fatherName,
    required this.motherName,
    required this.contactPerson,
    required this.guarantorRelation,
    required this.emergencyContactNumber,
    required this.username,
    required this.password,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
        id: json['Id'],
        patientName: json['PatientName'],
        name: json['name'],
        middleName: json['middleName'],
        lastName: json['lastName'],
        mobileNumber: json['MobileNumber'],
        email: json['Email'],
        address: json['adderss'], // Note the typo here
        nationId: json['nation_Id'],
        nationality: json['Nationality'],
        residence: json['Residence'],
        subjectMajor: json['SubjectMajor'],
        subject: json['Subject'],
        academicYear: json['AcademicYear'],
        stateId: json['state_Id'],
        emirates: json['Emirates'],
        gender: json['Gender'],
        maritalStatus: json['martialStatus'], // Note the typo here
        dob: DateTime.parse(json['DOB']),
        visaStatus: json['VisaStatus'],
        fatherName: json['FatherName'],
        motherName: json['MotherName'],
        contactPerson: json['ContactPerson'],
        guarantorRelation: json['guarantorRelation'],
        emergencyContactNumber: json['emergencyContactNumber'],
        username: json['Username'],
        password: json['Password']);
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'PatientName': patientName,
      'name': name,
      'middleName': middleName,
      'lastName': lastName,
      'MobileNumber': mobileNumber,
      'Email': email,
      'adderss': address, // Note the typo here
      'nation_Id': nationId,
      'Nationality': nationality,
      'Residence': residence,
      'SubjectMajor': subjectMajor,
      'Subject': subject,
      'AcademicYear': academicYear,
      'state_Id': stateId,
      'Emirates': emirates,
      'Gender': gender,
      'martialStatus': maritalStatus, // Note the typo here
      'DOB': dob.toIso8601String(),
      'VisaStatus': visaStatus,
      'FatherName': fatherName,
      'MotherName': motherName,
      'ContactPerson': contactPerson,
      'guarantorRelation': guarantorRelation,
      'emergencyContactNumber': emergencyContactNumber,
      'Username': username,
      'Password': password
    };
  }
}
