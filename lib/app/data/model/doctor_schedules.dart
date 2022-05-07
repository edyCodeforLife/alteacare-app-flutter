class DoctorSchedules {
  DoctorSchedules({
    this.status,
    this.message,
    this.data,
  });

  bool? status;
  String? message;
  List<DataDoctorSchedule>? data;

  factory DoctorSchedules.fromJson(Map<String, dynamic> json) => DoctorSchedules(
        status: json["status"] as bool,
        message: json["message"] as String,
        data: List<DataDoctorSchedule>.from((json["data"] as List).map((x) => DataDoctorSchedule.fromJson(x as Map<String, dynamic>))),
      );

  factory DoctorSchedules.fromJsonError(Map<String, dynamic> json) {
    // List data = json["data"] as List;

    return DoctorSchedules(
      status: json["status"] as bool,
      message: json["message"] as String,
      data: json["data"] == []
          ? <DataDoctorSchedule>[]
          : List<DataDoctorSchedule>.from((json["data"] as List).map((x) => DataDoctorSchedule.fromJson(x as Map<String, dynamic>))),
    );
  }

  factory DoctorSchedules.fromJsonErrorCatch(String json) {
    return DoctorSchedules(
      message: json,
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class DataDoctorSchedule {
  DataDoctorSchedule({
    this.code,
    this.date,
    this.startTime,
    this.endTime,
  });

  String? code;
  DateTime? date;
  String? startTime;
  String? endTime;

  factory DataDoctorSchedule.fromJson(Map<String, dynamic> json) => DataDoctorSchedule(
        code: json["code"] as String,
        date: DateTime.parse(json["date"] as String),
        startTime: json["start_time"] as String,
        endTime: json["end_time"] as String,
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "start_time": startTime,
        "end_time": endTime,
      };

  Map<String, dynamic> toJson2() {
    // print("${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}");
    return {
      "code": code,
      "date": "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
      "time_start": startTime,
      "time_end": endTime,
    };
  }
}
