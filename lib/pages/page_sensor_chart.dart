import 'package:flutter/material.dart';
import 'package:movement_recognition_frontend/model_data.dart';
import 'package:movement_recognition_frontend/sensor_chart.dart';

class SensorChartScaffold extends StatefulWidget {
  const SensorChartScaffold({Key? key, required this.modelData})
      : super(key: key);
  final SensorData modelData;

  @override
  State<SensorChartScaffold> createState() => _AccScaffoldState();
}

class _AccScaffoldState extends State<SensorChartScaffold> {
  bool isSelected = false;
  String? selectedAxis;
  Widget? chartWidget;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sensor Chart"),
      ),
      body: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              child: Text(
                "Acc X",
                style: selectedAxis == "accX"
                    ? const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red)
                    : null,
              ),
              onPressed: () {
                chartWidget = AccLineChart.acceloration(widget.modelData);
                setState(() {
                  selectedAxis = "accX";
                  isSelected = true;
                });
              },
            ),
            TextButton(
              child: Text(
                "Acc Y",
                style: selectedAxis == "accY"
                    ? const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red)
                    : null,
              ),
              onPressed: () {
                chartWidget = AccLineChart.acceloration(widget.modelData);
                setState(() {
                  selectedAxis = "accY";
                  isSelected = true;
                });
              },
            ),
            TextButton(
              child: Text(
                "Acc Z",
                style: selectedAxis == "accZ"
                    ? const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red)
                    : null,
              ),
              onPressed: () {
                chartWidget = AccLineChart.acceloration(widget.modelData);
                setState(() {
                  selectedAxis = "accZ";
                  isSelected = true;
                });
              },
            ),
          ],
        ),
        const Spacer(
          flex: 1,
        ),
        isSelected ? Expanded(child: chartWidget!) : Container(),
        // Expanded(child: AccLineChart.acceloration(widget.modelData)),
        const Spacer(
          flex: 1,
        ),
      ]),
    );
  }
}
