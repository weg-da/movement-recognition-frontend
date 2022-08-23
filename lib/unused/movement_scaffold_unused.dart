import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:flutter_sensors/flutter_sensors.dart';
import 'package:movement_recognition_frontend/http.dart';
import 'package:movement_recognition_frontend/model_data.dart';
import 'package:movement_recognition_frontend/sensor_chart.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MovementScaffoldOld extends StatefulWidget {
  const MovementScaffoldOld({Key? key, required this.movementNumber})
      : super(key: key);
  final int movementNumber;

  @override
  State<MovementScaffoldOld> createState() => _MovementScaffoldState();
}

class _MovementScaffoldState extends State<MovementScaffoldOld> {
  bool movementFinished = false;
  late int _counter;
  late String _title;
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
    // final stream = await SensorManager().sensorUpdates(
    //   sensorId: Sensors.ACCELEROMETER,
    //   interval: Sensors.SENSOR_DELAY_GAME,
    // );
    // accStream = stream.listen((sensorEvent) {
    //   print(sensorEvent.data);
    // });
    gyrStream = gyroscopeEvents.listen((GyroscopeEvent event) {
      modelData.gyrX.add(event.x);
      modelData.gyrY.add(event.y);
      modelData.gyrZ.add(event.z);
    });
    accStream = accelerometerEvents.listen((AccelerometerEvent event) {
      modelData.accX.add(event.x);
      modelData.accY.add(event.y);
      modelData.accZ.add(event.z);
    });

    await Future.delayed(const Duration(seconds: 5));
    accStream.cancel();
    gyrStream.cancel();
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
      _title = "Finished";
      movementFinished = true;
    });
  }

  void uploadData() async {
    if (modelData.accX.isNotEmpty) {
      await httpMovement.postSensorData(modelData: modelData);
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Movement" + widget.movementNumber.toString()),
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
            TextButton(
                onPressed: uploadData, child: const Text("Upload Movement"))
          ],
        ),
      ),
    );
  }
}
