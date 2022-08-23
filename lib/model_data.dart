import 'dart:math';

class ModelData {
  List<double> accX;
  List<double> accY;
  List<double> accZ;
  List<double> gyrX;
  List<double> gyrY;
  List<double> gyrZ;
  String? result;
  int? number;

  ModelData(
      {required this.accX,
      required this.accY,
      required this.accZ,
      required this.gyrX,
      required this.gyrY,
      required this.gyrZ,
      this.number});

// convert list of doubles to list of string values
  String listToString(List<double> input) {
    return input
        .toString()
        .substring(1, input.toString().length - 1)
        .replaceAll(",", "");
  }

// Create List of doubles with random values
  List<double> createTestData() {
    List<double> testList = [];

    var rng = Random();
    for (var i = 0; i < 1001; i++) {
      testList.add(rng.nextDouble());
    }

    return testList;
  }

// create map with sensor axes
// shorten length of axes to the same length
  Map createMap() {
    List<int> lengthsAcc = [
      accX.length,
      accY.length,
      accZ.length,
    ];
    List<int> lengthsGyr = [gyrX.length, gyrY.length, gyrZ.length];
    int smallestLenghtAcc = lengthsAcc.reduce(min);
    int smallestLenghtGyr = lengthsGyr.reduce(min);
    Map data = {
      "acc_x": listToString(accX.sublist(0, smallestLenghtAcc)),
      "acc_y": listToString(accY.sublist(0, smallestLenghtAcc)),
      "acc_z": listToString(accZ.sublist(0, smallestLenghtAcc)),
      "gyr_x": listToString(gyrX.sublist(0, smallestLenghtGyr)),
      "gyr_y": listToString(gyrY.sublist(0, smallestLenghtGyr)),
      "gyr_z": listToString(gyrZ.sublist(0, smallestLenghtGyr)),
      "label": number
    };

    return data;
  }

// clean all data from sensor axes
  void clean() {
    accX = [];
    accY = [];
    accZ = [];
    gyrX = [];
    gyrY = [];
    gyrZ = [];
  }

  double _roundDouble(double value, int places) {
    num mod = pow(10.0, places);

    return ((value * mod).round().toDouble() / mod);
  }

  List<double> _pruneList(List<double> list) {
    for (var i = 0; i < list.length; i++) {
      list[i] = _roundDouble(list[i], 4);
    }
    return list;
  }

  void modelPrune() {
    accX = _pruneList(accX);
    accY = _pruneList(accY);
    accZ = _pruneList(accZ);
    gyrX = _pruneList(gyrX);
    gyrY = _pruneList(gyrY);
    gyrZ = _pruneList(gyrZ);
  }

  // factory ModelData.toJson(Map<String, dynamic> json) {
  //   return ModelData(
  //     id: json['id'] as int,
  //     dateFrom: DateTime.parse(json['date_from']).toLocal(),
  //     dateTo: DateTime.parse(json['date_to']).toLocal(),
  //     title: json['appointment_title'] as String,
  //     comment: json['comment'] as String?,
  //     created: DateTime.parse(json['created_at']).toLocal(),
  //     host: json['host'] as int,
  //     patient: json['patient'] as int,
  //     reviewed: json['reviewed'] as bool,
  //     status: json['status'],
  //   );
  // }
}
