// To parse this JSON data, do
//
//     final patientFamilyType = patientFamilyTypeFromJson(jsonString);

class PatientFamilyType {
  PatientFamilyType({
    required this.status,
    required this.message,
    required this.data,
  });

  bool status;
  String message;
  List<FamilyDatumType>? data;

  factory PatientFamilyType.fromJson(Map<String, dynamic> json) {
    List data = json["data"] as List;
    // print('dataaa => $data');
    return PatientFamilyType(
      status: json["status"] as bool,
      message: json["message"] as String,
      data: (json["data"] as List).map((x) => FamilyDatumType.fromJson(x as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };

  factory PatientFamilyType.fromJsonError(Map<String, dynamic> json) =>
      PatientFamilyType(status: json["status"] as bool, message: json["message"] as String, data: []);

  factory PatientFamilyType.fromJsonErrorCatch(String json) => PatientFamilyType(message: json, status: false, data: []);
}

class FamilyDatumType {
  FamilyDatumType({
    required this.id,
    required this.name,
    required this.isDefault,
  });

  String id;
  String name;
  bool isDefault;

  factory FamilyDatumType.fromJson(Map<String, dynamic> json) => FamilyDatumType(
        id: json["id"] as String,
        name: json["name"] as String,
        isDefault: json["is_default"] as bool,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "is_default": isDefault,
      };
}
