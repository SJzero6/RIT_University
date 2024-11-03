class DoctorData {
  int id;
  String? DoctorName;
  String? DoctorDepartment;
  String DoctorProfile;
  String? Experiance;

  DoctorData(
      {required this.id,
      required this.DoctorName,
      required this.DoctorDepartment,
      required this.DoctorProfile,
      this.Experiance});

  factory DoctorData.fromJson(Map<String, dynamic> json) => DoctorData(
      id: json['Id'],
      DoctorName: json['DoctorName'],
      DoctorDepartment: json['DoctorDepartment'],
      DoctorProfile: json['ProfilePhoto'],
      Experiance: json['Experince']);

  Map<String, dynamic> toJson() => {
        'Id': id,
        'DoctorName': DoctorName,
        'DoctorDepartment': DoctorDepartment,
        'ProfilePhoto': DoctorProfile,
        'Experince': Experiance
      };
}
