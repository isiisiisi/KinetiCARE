import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:kineticare/components/patient_components/bar_data.dart';

class MyBarGraph extends StatelessWidget {
  final List weeklySummary;
  const MyBarGraph({super.key, required this.weeklySummary});

  @override
  Widget build(BuildContext context) {
    BarData myBarData = BarData(
        sunAmount: weeklySummary[0],
        monAmount: weeklySummary[1],
        tuesAmount: weeklySummary[2],
        wedAmount: weeklySummary[3],
        thursAmount: weeklySummary[4],
        friAmount: weeklySummary[5],
        satAmount: weeklySummary[6]);
    myBarData.initiliazeBarData();
    return SizedBox(
      height: 125,
      child: BarChart(
        BarChartData(
          maxY: 20,
          minY: 0,
          gridData:  const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData:  const FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: getBottomTiles,
              ),
            ),
          ),
          barGroups: myBarData.barData
              .map((data) => BarChartGroupData(
                    x: data.x,
                    barRods: [
                      BarChartRodData(
                        toY: data.y,
                        color: const Color(0xFF5A8DEE),
                        width: 25,
                        borderRadius: BorderRadius.circular(4),
                        backDrawRodData: BackgroundBarChartRodData(
                          show: true,
                           color: const Color(0xFF707070),
                        )
                      ),
                    ],
                  ))
              .toList(),
        ),
      ),
    );
  }
}

Widget getBottomTiles(double value, TitleMeta meta) {
  const style =
      TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 14);

  Widget text;
  switch (value.toInt()) {
    case 0:
      text = const Text('S', style: style);
      break;
    case 1:
      text = const Text('M', style: style);
      break;
    case 2:
      text = const Text('T', style: style);
      break;
    case 3:
      text = const Text('W', style: style);
      break;
    case 4:
      text = const Text('Th', style: style);
      break;
    case 5:
      text = const Text('F', style: style);
      break;
    case 6:
      text = const Text('S', style: style);
      break;
    default:
      text = const Text('', style: style);
      break;
  }

  return SideTitleWidget(axisSide: meta.axisSide, child: text);
}