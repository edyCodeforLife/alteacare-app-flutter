/// This model come from API [https://staging-services.alteacare.com/data/hospitals]
class Hospital {
  Hospital({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<Datum>? data;

  factory Hospital.fromJson(Map<String, dynamic> json) => Hospital(
        status: json["status"] as bool,
        message: json["message"] as String,
        data: List<Datum>.from((json["data"] as List).map((x) => Datum.fromJson(x as Map<String, dynamic>))),
      );

  factory Hospital.fromJsonError(Map<String, dynamic> json) {
    List data = json["data"] as List;

    return Hospital(
      status: json["status"] as bool,
      message: json["message"] as String,
      data: List<Datum>.from(data.map((x) => Datum.fromJson(x as Map<String, dynamic>))),
    );
  }

  factory Hospital.fromJsonErrorCatch(String json) {
    return Hospital(
      message: json,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    this.hospitalId,
    this.name,
    this.phone,
    this.address,
    this.latitude,
    this.longitude,
  });

  String? hospitalId;
  String? name;
  String? phone;
  String? address;
  String? latitude;
  String? longitude;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        hospitalId: json["hospital_id"] as String,
        name: json["name"] as String,
        phone: json["phone"] == null ? null : json["phone"] as String,
        address: json["address"] as String,
        latitude: json["latitude"] == null ? null : json["latitude"] as String,
        longitude: json["longitude"] == null ? null : json["longitude"] as String,
      );

  Map<String, dynamic> toJson() => {
        "hospital_id": hospitalId,
        "name": name,
        "phone": phone,
        "address": address,
        "latitude": latitude == null ? null : latitude,
        "longitude": longitude == null ? null : longitude,
      };
}
