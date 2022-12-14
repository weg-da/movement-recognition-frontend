import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:movement_recognition_frontend/http.dart';
import 'package:movement_recognition_frontend/model_data.dart';
import 'package:movement_recognition_frontend/sensor_chart.dart';

class PageMovement extends StatefulWidget {
  const PageMovement(
      {Key? key, required this.movementNumber, required this.movementName})
      : super(key: key);
  final int movementNumber;
  final String movementName;

  @override
  State<PageMovement> createState() => _MovementScaffoldState();
}

class _MovementScaffoldState extends State<PageMovement> {
  List<String> movementNames = [
    "Resting position, sitting",
    "Outstreched arm, sitting",
    "Finger to nose movement",
    "Hand open, hand closed",
    "Rotating arm",
    "Finger tapping, thumb with index finger"
  ];
  bool movementFinished = false;
  bool uploading = false;
  late int _counter;
  late String _title;
  String _prediction = " ";
  HttpMovement httpMovement = HttpMovement();
  late StreamSubscription accStream;
  late StreamSubscription gyrStream;
  ModelData modelData =
      ModelData(accX: [], accY: [], accZ: [], gyrX: [], gyrY: [], gyrZ: []);

  Future countdown({required int seconds}) async {
    int counterLocal = seconds;
    _counter = seconds;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _counter--;
        counterLocal--;
      });
      if (counterLocal < 2) {
        timer.cancel();
      }
    });
    await Future.delayed(Duration(seconds: seconds));
  }

  void startStream() async {
    modelData.clean();
    modelData.number = widget.movementNumber;
    Stream streamACC = await SensorManager().sensorUpdates(
        sensorId: Sensors.LINEAR_ACCELERATION,
        // interval: Sensors.SENSOR_DELAY_GAME,
        interval: const Duration(milliseconds: 2));
    Stream streamGYR = await SensorManager().sensorUpdates(
        sensorId: Sensors.GYROSCOPE,
        // interval: Sensors.SENSOR_DELAY_GAME,
        interval: const Duration(milliseconds: 2));

    accStream = streamACC.listen((sensorEvent) {
      modelData.accX.add(sensorEvent.data[0]);
      modelData.accY.add(sensorEvent.data[1]);
      modelData.accZ.add(sensorEvent.data[2]);
    });
    gyrStream = streamGYR.listen((sensorEvent2) {
      modelData.gyrX.add(sensorEvent2.data[0]);
      modelData.gyrY.add(sensorEvent2.data[1]);
      modelData.gyrZ.add(sensorEvent2.data[2]);
    });

    await Future.delayed(const Duration(seconds: 5));
    accStream.cancel();
    gyrStream.cancel();
    // print("Acc length: " + modelData.accX.length.toString());
    // print("gyr length: " + modelData.gyrX.length.toString());
  }

  void record() async {
    setState(() {
      _title = "Start Movement in...";
    });
    await countdown(seconds: 3);
    // print("first Countdown finished");
    setState(() {
      _title = "Move...";
    });
    // print("Start stream");
    startStream();
    await countdown(seconds: 5);
    setState(() {
      _title = " ";
      movementFinished = true;
    });
    uploadData();
  }

  void uploadData() async {
    setState(() {
      uploading = true;
    });
    modelData.modelPrune();
    if (modelData.accX.isNotEmpty) {
      //await httpMovement.postSensorData(modelData: modelData);
      httpMovement
          .postSensorDataAWS(modelData: modelData)
          .then((value) => {
                setState(() {
                  uploading = false;
                  _prediction = "Prediction: " +
                      movementNames[int.parse(modelData.result!)];
                })
              })
          .onError((error, stackTrace) => {
                setState(() {
                  uploading = false;
                  _prediction = "Prediction: " + "Error loading";
                })
              });
    }
  }

  @override
  void initState() {
    super.initState();
    record();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Movement: ",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    widget.movementName,
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            uploading
                ? const CircularProgressIndicator()
                : Text(
                    _prediction,
                    style: const TextStyle(fontSize: 20),
                  ),
            Text(
              _title,
              style: Theme.of(context).textTheme.headline4,
            ),
            movementFinished
                ? SizedBox(
                    height: 200, child: AccLineChart.acceloration(modelData))
                : Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headline4,
                  ),

            // TextButton(
            //     onPressed: uploadData, child: const Text("Upload Movement"))
          ],
        ),
      ),
    );
  }
}
