/// Example of a simple line chart.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:movement_recognition_frontend/model_data.dart';

class AccLineChart extends StatelessWidget {
  final List<charts.Series<dynamic, int>> seriesList;
  final bool? animate;

  const AccLineChart(this.seriesList, {Key? key, this.animate})
      : super(key: key);

  static double roundDouble(double value, int places) {
    num mod = pow(10.0, places);

    return ((value * mod).round().toDouble() / mod);
  }

  factory AccLineChart.acceloration(SensorData modelData) {
    return AccLineChart(
      createAccelaration(modelData),
      // Disable animations for image tests.
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.LineChart(
      seriesList,
      animate: animate,
      // defaultRenderer: charts.LineRendererConfig(includePoints: true),
      // primaryMeasureAxis: charts.NumericAxisSpec(
      //   tickProviderSpec: charts.StaticNumericTickProviderSpec(
      //     _createTickSpec(-0.1, 1.4),
      //   ),
      // ),
    );
  }

  List<charts.TickSpec<num>> _createTickSpec(double minValue, double maxValue) {
    List<charts.TickSpec<num>> _tickProvidSpecs = [];
    double d = minValue;
    while (d <= maxValue) {
      _tickProvidSpecs.add(charts.TickSpec(d,
          label: d.toStringAsFixed(1),
          style: const charts.TextStyleSpec(fontSize: 14)));
      d += 0.1;
    }
    return _tickProvidSpecs;
  }

  /// Create one series with sample hard coded data.

  static List<charts.Series<Acceleration, int>> createAccelaration(
      SensorData modelData) {
    final List<Acceleration> dataX = [];
    final List<Acceleration> dataY = [];
    final List<Acceleration> dataZ = [];
    // int i = 0;

    // for (int i = 0; i < 100; i++) {
    for (int i = 0; i < modelData.accX.length; i++) {
      dataX.add(Acceleration(i, roundDouble(modelData.accX[i], 3) * 1));
      dataY.add(Acceleration(i, roundDouble(modelData.accY[i], 3) * 1));
      dataZ.add(Acceleration(i, roundDouble(modelData.accZ[i], 3) * 1));
    }
    // for (var element in accList) {
    //   data.add(Acceleration(i, roundDouble(element, 1)));
    //   // data.add(Acceleration(i, i));
    //   i++;
    //   print(roundDouble(element, 1));
    // }

    return [
      charts.Series<Acceleration, int>(
        id: 'X-Chart',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (Acceleration sales, _) => sales.point,
        measureFn: (Acceleration sales, _) => sales.acc,
        data: dataX,
      ),
      charts.Series<Acceleration, int>(
        id: 'Y-Chart',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (Acceleration sales, _) => sales.point,
        measureFn: (Acceleration sales, _) => sales.acc,
        data: dataY,
      ),
      charts.Series<Acceleration, int>(
        id: 'Z-Chart',
        colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
        domainFn: (Acceleration sales, _) => sales.point,
        measureFn: (Acceleration sales, _) => sales.acc,
        data: dataZ,
      )
    ];
  }
}

class Acceleration {
  final int point;
  final double acc;

  Acceleration(this.point, this.acc);
}
