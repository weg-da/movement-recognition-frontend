import 'package:flutter/material.dart';
import 'package:movement_recognition_frontend/unused/line_chart.dart';

class ChartScaffold extends StatefulWidget {
  const ChartScaffold({Key? key}) : super(key: key);

  @override
  State<ChartScaffold> createState() => _ChartScaffoldState();
}

class _ChartScaffoldState extends State<ChartScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chart"),
      ),
      body: SimpleLineChart.withSampleData(),
    );
  }
}
