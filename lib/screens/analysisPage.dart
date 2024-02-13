import 'package:colours/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../App_Configuration/apptheme.dart';
import '../widgets/appBarWidget.dart';

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    late List<_ChartData> data;
    late TooltipBehavior _tooltip;
    data = [
      _ChartData('Honesty', 90),
      _ChartData('Courage', 84),
      _ChartData('Compassion', 30),
      _ChartData('Generosity', 64),
      _ChartData('Fidelity', 14),
      _ChartData('Integrity', 16),
      _ChartData('Fairness', 20),
      _ChartData('Self-control', 25),
      _ChartData('Prudence', 27)
    ];
    _tooltip = TooltipBehavior(enable: false);
    return
      SafeArea(
          child: Scaffold(
          backgroundColor: Color(0xFFEFE5CC),
    appBar: AppBarWidget('regular'),
    body:Container(
      child: Center(child:
       Container(
          decoration: BoxDecoration(
            color: Color(0xFFFFFDF9),
            border: Border.all(color: Color(0xFFFEFE5CC), width: 9.0),
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Legal Community",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width:150,
                child: DropdownButtonFormField<String>(
                  value: 'All-Time',
                  items: <String>['All-Time', 'Education', 'Technology', 'Healthcare']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {},

                  borderRadius: BorderRadius.circular(10),
                ),
              ),

                  SfCartesianChart(



                    plotAreaBorderWidth: 0, // Remove background margins
                    enableSideBySideSeriesPlacement: false,

                    primaryXAxis: CategoryAxis(
                      isVisible: true,
                      axisLine: AxisLine(width: 3,color: Colours.swatch("#534D3F")),
                      labelAlignment: LabelAlignment.end,
                      labelPosition: ChartDataLabelPosition.outside, // X-axis labels inside
                      edgeLabelPlacement: EdgeLabelPlacement.none, // Prevent labels from getting cut off
                    ),

                    primaryYAxis: NumericAxis(

                      isVisible: true,
                      axisLine: AxisLine(width: 3,color: Colours.swatch("#534D3F")),

                    ),

                    series: <CartesianSeries<_ChartData, String>>[
                      BarSeries<_ChartData, String>(
                        dataSource: data,
                        xValueMapper: (_ChartData data, _) => data.x,
                        yValueMapper: (_ChartData data, _) => data.y,
                        name: 'Analysis',
                        color: Color.fromRGBO(8, 142, 255, 1), // Default color for all bars
                        // Custom color for each bar
                        pointColorMapper: (_ChartData data, _) {

                          // Return custom colors based on your logic
                          if (data.x == 'Honesty') {
                            return Colours.swatch(clrHonesty); // Example custom color for Category1
                          } else if (data.x == 'Courage') {
                            return Colours.swatch(clrCourage);  // Example custom color for Category2
                          }
                          else if (data.x == 'Compassion') {
                            return Colours.swatch(clrCompassion);  // Example custom color for Category2
                          }
                          else if (data.x == 'Generosity') {
                            return Colours.swatch(clrGenerosity);  // Example custom color for Category2
                          }
                          else if (data.x == 'Fidelity') {
                            return Colours.swatch(clrFidelity);  // Example custom color for Category2
                          }
                          else if (data.x == 'Integrity') {
                            return Colours.swatch(clrIntegrity);  // Example custom color for Category2
                          }
                          else if (data.x == 'Fairness') {
                            return Colours.swatch(clrFairness);  // Example custom color for Category2
                          }
                          else if (data.x == 'Self-control') {
                            return Colours.swatch(clrSelfControl);  // Example custom color for Category2
                          }
                          else if (data.x == 'Prudence') {
                            return Colours.swatch(clrPrudence);  // Example custom color for Category2
                          }
                          // Return default color for other categories
                          return Color.fromRGBO(8, 142, 255, 1);
                        },
                        dataLabelSettings: DataLabelSettings(
                          isVisible: true,
                          textStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 12),
                          labelAlignment: ChartDataLabelAlignment.auto,
                          alignment: ChartAlignment.near,
                        ),
                      ),
                    ],
                  ),

            ],
          ),
        ),



      ),
    )));
  }
}
class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}