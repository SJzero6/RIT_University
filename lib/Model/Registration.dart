class StudentRegistration {
  String name;
  String middleName;
  String lastName;
  String mobileNumber;
  String filenumber;
  String emailId;
  String address;
  String nationId;
  String residence;
  String subjectMajor;
  String subject;
  String academicYear;
  String stateId;
  String gender;
  String martialStatus;
  String dateOfBirth;
  String visaStatus;
  String fatherName;
  String motherName;
  String contactPerson;
  String guarantorRelation;
  String emergencyContactNumber;
  String password;
  String username;

  StudentRegistration(
      {required this.name,
      required this.middleName,
      required this.lastName,
      required this.mobileNumber,
      required this.filenumber,
      required this.emailId,
      required this.address,
      required this.nationId,
      required this.residence,
      required this.subjectMajor,
      required this.subject,
      required this.academicYear,
      required this.stateId,
      required this.gender,
      required this.martialStatus,
      required this.dateOfBirth,
      required this.visaStatus,
      required this.fatherName,
      required this.motherName,
      required this.contactPerson,
      required this.guarantorRelation,
      required this.emergencyContactNumber,
      required this.password,
      required this.username});

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "middleName": middleName,
      "lastName": lastName,
      "mobileNumber": mobileNumber,
      "filenumber": filenumber,
      "emailId": emailId,
      "adderss": address,
      "nation_Id": nationId.toString(),
      "Residence": residence,
      "SubjectMajor": subjectMajor,
      "Subject": subject,
      "AcademicYear": academicYear,
      "state_Id": stateId.toString(),
      "gender": gender.toString(),
      "martialStatus": martialStatus.toString(),
      "DateOfBirth": dateOfBirth,
      "visaStatus": visaStatus.toString(),
      "FatherName": fatherName,
      "MotherName": motherName,
      "ContactPerson": contactPerson,
      "guarantorRelation": guarantorRelation,
      "emergencyContactNumber": emergencyContactNumber,
      "Password": password,
      "Username": username,
    };
  }
}
