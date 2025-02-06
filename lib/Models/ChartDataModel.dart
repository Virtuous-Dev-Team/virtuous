import 'dart:ui';

class ChartData {
  ChartData(this.x, this.y, [this.color]);
  final String x; //name of virtue
  final double y; //amount of virtue reported
  final Color? color; //color of virtue
}