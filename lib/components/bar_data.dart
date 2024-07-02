import 'package:kineticare/components/indi_bar.dart';

class BarData {
  final double sunAmount;
  final double monAmount;
  final double tuesAmount;
  final double wedAmount;
  final double thursAmount;
  final double friAmount;
  final double satAmount;

  BarData(
      {required this.sunAmount,
      required this.monAmount,
      required this.tuesAmount,
      required this.wedAmount,
      required this.thursAmount,
      required this.friAmount,
      required this.satAmount});
  List<IndividualBar> barData = [];

  void initiliazeBarData() {
    barData = [
      IndividualBar(x: 0, y: sunAmount),
      IndividualBar(x: 1, y: monAmount),
      IndividualBar(x: 2, y: tuesAmount),
      IndividualBar(x: 3, y: wedAmount),
      IndividualBar(x: 4, y: thursAmount),
      IndividualBar(x: 5, y: friAmount),
      IndividualBar(x: 6, y: satAmount),
    ];
  }
}