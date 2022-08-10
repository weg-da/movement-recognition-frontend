import 'dart:math';

class ModelData {
  List<double> accX;
  List<double> accY;
  List<double> accZ;
  List<double> gyrX;
  List<double> gyrY;
  List<double> gyrZ;
  String? result;

  ModelData(
      {required this.accX,
      required this.accY,
      required this.accZ,
      required this.gyrX,
      required this.gyrY,
      required this.gyrZ});

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
    List<int> lengths = [
      accX.length,
      accY.length,
      accZ.length,
      gyrX.length,
      gyrY.length,
      gyrZ.length
    ];
    int smallestLenght = lengths.reduce(min);
    Map data = {
      "acc_x": listToString(accX.sublist(0, smallestLenght)),
      "acc_y": listToString(accY.sublist(0, smallestLenght)),
      "acc_z": listToString(accZ.sublist(0, smallestLenght)),
      "gyr_x": listToString(gyrX.sublist(0, smallestLenght)),
      "gyr_y": listToString(gyrY.sublist(0, smallestLenght)),
      "gyr_z": listToString(gyrZ.sublist(0, smallestLenght))
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
