import 'dart:async';
import 'package:flutter/material.dart';
import 'package:movement_recognition_frontend/model_data.dart';
import 'package:movement_recognition_frontend/pages/page_movement.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int? movementNumber;
  List<String> movementNames = [
    "Resting position, sitting",
    "Outstreched arm, sitting",
    "Finger to nose movement",
    "Hand open, hand closed",
    "Rotating arm",
    "Finger tapping, thumb with index finger"
  ];
  // ModelData modelData =
  //     ModelData(accX: [], accY: [], accZ: [], gyrX: [], gyrY: [], gyrZ: []);

  // Stream<double> countStream(int max) async* {
  //   var rng = Random();
  //   Timer(const Duration(seconds: 5), () async* {
  //     yield rng.nextDouble();
  //   });
  //   // for (int i = 0; i < max; i++) {
  //   //   yield rng.nextDouble();
  //   // }
  // }

  // Future startRandomStream() async {
  //   var streama = countStream(5).listen((event) {
  //     // print(event);
  //   });
  //   Timer(const Duration(seconds: 5), () {
  //     // print("Stop");
  //     streama.cancel();
  //   });
  // }

  Future startMovement(bool sim) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          movementNumber = null;
          return AlertDialog(
              // backgroundColor: Colors.lightBlueAccent,
              scrollable: true,
              title: const Text("Select movement"),
              content: SizedBox(
                height: 400,
                width: 300,
                child: Row(children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                tileColor: Colors.blue,
                                textColor: Colors.white,
                                leading: Text((index + 1).toString()),
                                title: Text(movementNames[index]),
                                onTap: () {
                                  movementNumber = (index);
                                  Navigator.of(context).pop();
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ]),
              ));
        });
    if (sim != true) {
      if (movementNumber != null) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PageMovement(
                      movementNumber: movementNumber!,
                      movementName: movementNames[movementNumber!],
                    )));
      }
    }
  }

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
            ElevatedButton(
                onPressed: () => startMovement(false),
                child: const Text(
                  "Record Movement",
                  style: TextStyle(fontSize: 22),
                )),
            // TextButton(
            //     onPressed: startRandomStream,
            //     child: const Text("Start Random Number Stream")),
            // TextButton(
            //     onPressed: () {
            //       if (modelData.accX.isNotEmpty) {
            //         Navigator.push(
            //             context,
            //             MaterialPageRoute(
            //                 builder: (context) => SensorChartScaffold(
            //                       modelData: modelData,
            //                     )));
            //       }
            //     },
            //     child: const Text("Chart"))
          ],
        ),
      ),
    );
  }
}
