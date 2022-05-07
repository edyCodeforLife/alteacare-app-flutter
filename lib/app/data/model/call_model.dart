class CallModel {
  String name;
  bool callerA;
  bool callerB;

  CallModel({required this.name, required this.callerA, required this.callerB});

  CallModel.fromJson(Map<String, dynamic> parsedJSON)
      : name = parsedJSON['name'] as String,
        callerA = parsedJSON['callerA'] as bool,
        callerB = parsedJSON['callerB'] as bool;
}
