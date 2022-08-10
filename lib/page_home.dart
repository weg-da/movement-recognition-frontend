import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:movement_recognition_frontend/page_sensor_chart.dart';
import 'package:movement_recognition_frontend/http.dart';
import 'package:movement_recognition_frontend/model_data.dart';
import 'package:sensors_plus/sensors_plus.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controllerResult = TextEditingController(text: "");
  int _counter = 5;
  HttpMovement httpMovement = HttpMovement();
  late StreamSubscription accStream;
  late StreamSubscription gyrStream;
  ModelData modelData =
      ModelData(accX: [], accY: [], accZ: [], gyrX: [], gyrY: [], gyrZ: []);

  Stream<double> countStream(int max) async* {
    var rng = Random();
    while (true) {
      yield rng.nextDouble();
    }
    // for (int i = 0; i < max; i++) {
    //   yield rng.nextDouble();
    // }
  }

  Future startRandomStream() async {
    countStream(5).listen((event) {
      print(event);
    });
  }

  Future startMovement() async {
    modelData.clean(); // clean model data
    // start stream
    accStream = accelerometerEvents.listen((AccelerometerEvent event) {
      modelData.accX.add(event.x);
      modelData.accY.add(event.y);
      modelData.accZ.add(event.z);
    });
    gyrStream = gyroscopeEvents.listen((GyroscopeEvent event) {
      modelData.gyrX.add(event.x);
      modelData.gyrY.add(event.y);
      modelData.gyrZ.add(event.z);
    });
    oneSecTimer(); // start Timer
  }

  Future<void> oneSecTimer() async {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      // print(timer.tick);
      setState(() {
        _counter--;
      });

      if (_counter == 0) {
        timer.cancel();
        setState(() {
          _counter = 5;
        });
        accStream.cancel();
        gyrStream.cancel();

        // modelData = ModelData(
        //     accX: modelData.createTestData(),
        //     accY: modelData.createTestData(),
        //     accZ: modelData.createTestData(),
        //     gyrX: modelData.createTestData(),
        //     gyrY: modelData.createTestData(),
        //     gyrZ: modelData.createTestData());

        await httpMovement.postSensorData(modelData: modelData);
        setState(() {
          if (modelData.result != null) {
            controllerResult.text = modelData.result!;
          }
        });
      }
    });
  }

  // void fiveSecTimer() {
  //   Timer(const Duration(seconds: 5), () {
  //     print("Start");
  //     oneSecTimer();
  //   });
  //   print("Stop");
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextField(
              controller: controllerResult,
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            TextButton(onPressed: startMovement, child: const Text("Start")),
            TextButton(
                onPressed: startRandomStream,
                child: const Text("Start Random Number Stream")),
            TextButton(
                onPressed: () {
                  if (modelData.accX.isNotEmpty) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SensorChartScaffold(
                                  modelData: modelData,
                                )));
                  }
                },
                child: const Text("Chart"))
          ],
        ),
      ),
    );
  }
}
