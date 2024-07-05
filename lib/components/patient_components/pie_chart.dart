import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class MyPieChart extends StatelessWidget {
  final double painLevel;

  const MyPieChart({
    super.key,
    required this.painLevel
  });

  @override
  Widget build(BuildContext context) {
    double painPercentage = painLevel / 10;
    Color painColor;

    if (painPercentage <= 0.2) {
      painColor = const Color(0xFFD9D9D9);
    } else if (painPercentage <= 0.4) {
      painColor = const Color(0xFFD9D9D9);
    } else if (painPercentage <= 0.6) {
      painColor = const Color(0xFFD9D9D9);
    } else {
      painColor = const Color(0xFFD9D9D9);
    }

    return  Row(
        children: <Widget>[
          CircularPercentIndicator(
            radius: 30.0,
            lineWidth: 4.0,
            percent: painPercentage,
            center: Text("${(painPercentage * 100).toInt()}%"),
            progressColor: painColor,
          ),
        ],
    );
  }
}
