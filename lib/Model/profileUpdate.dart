// patient_update_model.dart
class PatientUpdateModel {
  final String id;
  final String name;
  final String middleName;
  final String lastName;
  final String mobileNumber;
  final String emailId;
  final String address;
  final String nationId;
  final String residence;
  final String subjectMajor;
  final String subject;
  final String academicYear;
  final String stateId;
  final String gender;
  final String maritalStatus;
  final String dateOfBirth;
  final String visaStatus;
  final String fatherName;
  final String motherName;
  final String contactPerson;
  final String guarantorRelation;
  final String emergencyContactNumber;
  final String username;
  final String password;

  PatientUpdateModel({
    required this.id,
    required this.name,
    required this.middleName,
    required this.lastName,
    required this.mobileNumber,
    required this.emailId,
    required this.address,
    required this.nationId,
    required this.residence,
    required this.subjectMajor,
    required this.subject,
    required this.academicYear,
    required this.stateId,
    required this.gender,
    required this.maritalStatus,
    required this.dateOfBirth,
    required this.visaStatus,
    required this.fatherName,
    required this.motherName,
    required this.contactPerson,
    required this.guarantorRelation,
    required this.emergencyContactNumber,
    required this.username,
    required this.password,
  });

  // Convert the model to a map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'middleName': middleName,
      'lastName': lastName,
      'mobileNumber': mobileNumber,
      'emailId': emailId,
      'adderss': address,
      'nation_Id': nationId,
      'Residence': residence,
      'SubjectMajor': subjectMajor,
      'Subject': subject,
      'AcademicYear': academicYear,
      'state_Id': stateId,
      'gender': gender,
      'martialStatus': maritalStatus,
      'DateOfBirth': dateOfBirth,
      'visaStatus': visaStatus,
      'FatherName': fatherName,
      'MotherName': motherName,
      'ContactPerson': contactPerson,
      'guarantorRelation': guarantorRelation,
      'emergencyContactNumber': emergencyContactNumber,
      'Username': username,
      "Password": password
    };
  }
}
