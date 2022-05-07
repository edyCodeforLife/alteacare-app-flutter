class FamilyType {
  FamilyType({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<DatumFamilyType>? data;

  factory FamilyType.fromJson(Map<String, dynamic> json) => FamilyType(
        status: json["status"] as bool,
        message: json["message"] as String,
        data: List<DatumFamilyType>.from((json["data"] as List)
            .map((x) => DatumFamilyType.fromJson(x as Map<String, dynamic>))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DatumFamilyType {
  DatumFamilyType({
    this.id,
    this.name,
    this.isDefault,
  });

  String? id;
  String? name;
  bool? isDefault;

  factory DatumFamilyType.fromJson(Map<String, dynamic> json) =>
      DatumFamilyType(
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
