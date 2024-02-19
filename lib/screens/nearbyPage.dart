import 'package:colours/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../App_Configuration/apptheme.dart';
import '../widgets/appBarWidget.dart';

class NearbyPage extends StatefulWidget {
  const NearbyPage({Key? key}) : super(key: key);

  @override
  _NearbyPageState createState() => _NearbyPageState();
}

class _NearbyPageState extends State<NearbyPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
    return SafeArea(
        child: Scaffold(
            backgroundColor: Color(0xFFEFE5CC),
            appBar: AppBarWidget('regular'),
            body: Container(
              child: Center(
                child: Container(
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
                        width: 150,
                        child: DropdownButtonFormField<String>(
                          value: 'All-Time',
                          items: <String>[
                            'All-Time',
                            'Education',
                            'Technology',
                            'Healthcare'
                          ].map<DropdownMenuItem<String>>((String value) {
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
                          axisLine: AxisLine(
                              width: 3, color: Colours.swatch("#534D3F")),
                          labelAlignment: LabelAlignment.end,
                          labelPosition: ChartDataLabelPosition
                              .outside, // X-axis labels inside
                          edgeLabelPlacement: EdgeLabelPlacement
                              .none, // Prevent labels from getting cut off
                        ),

                        primaryYAxis: NumericAxis(
                          isVisible: true,
                          axisLine: AxisLine(
                              width: 3, color: Colours.swatch("#534D3F")),
                        ),

                        series: <CartesianSeries<_ChartData, String>>[
                          BarSeries<_ChartData, String>(
                            dataSource: data,
                            xValueMapper: (_ChartData data, _) => data.x,
                            yValueMapper: (_ChartData data, _) => data.y,
                            name: 'Analysis',
                            color: Color.fromRGBO(
                                8, 142, 255, 1), // Default color for all bars
                            // Custom color for each bar
                            pointColorMapper: (_ChartData data, _) {
                              // Return custom colors based on your logic
                              if (data.x == 'Honesty') {
                                return Colours.swatch(
                                    clrHonesty); // Example custom color for Category1
                              } else if (data.x == 'Courage') {
                                return Colours.swatch(
                                    clrCourage); // Example custom color for Category2
                              } else if (data.x == 'Compassion') {
                                return Colours.swatch(
                                    clrCompassion); // Example custom color for Category2
                              } else if (data.x == 'Generosity') {
                                return Colours.swatch(
                                    clrGenerosity); // Example custom color for Category2
                              } else if (data.x == 'Fidelity') {
                                return Colours.swatch(
                                    clrFidelity); // Example custom color for Category2
                              } else if (data.x == 'Integrity') {
                                return Colours.swatch(
                                    clrIntegrity); // Example custom color for Category2
                              } else if (data.x == 'Fairness') {
                                return Colours.swatch(
                                    clrFairness); // Example custom color for Category2
                              } else if (data.x == 'Self-control') {
                                return Colours.swatch(
                                    clrSelfControl); // Example custom color for Category2
                              } else if (data.x == 'Prudence') {
                                return Colours.swatch(
                                    clrPrudence); // Example custom color for Category2
                              }
                              // Return default color for other categories
                              return Color.fromRGBO(8, 142, 255, 1);
                            },
                            dataLabelSettings: DataLabelSettings(
                              isVisible: true,
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 12),
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

Widget Vitruous(double screnWidth, double screenHeight) {
  return SingleChildScrollView(
    child: Container(
      color: Colours.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: screenHeight / 60),
            child: Container(
                width: screnWidth / 3,
                constraints: BoxConstraints(maxWidth: screnWidth),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colours.swatch("#FAD4E3")),
                child: Center(
                  child: Text("Why use virtues?",
                      style: TextStyle(
                        fontSize: 20,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.normal,
                        color: Colours.swatch(clrBlack),
                      )),
                )),
          ),
          Padding(
            padding: EdgeInsets.only(top: screenHeight / 60),
            child: Container(
                // width: screnWidth/3,
                constraints: BoxConstraints(maxWidth: screnWidth),
                // decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(5),
                //     color: Colours.swatch("#FAD4E3")
                // ),
                child: Center(
                  child: Text(
                      "Using virtues can have a positive impact on one’s mental state. Focusing on the positive aspects of life greatly increases one’s outlook and mood. and stuff",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        color: Colours.swatch(clrBlack),
                      )),
                )),
          )
        ],
      ),
    ),
  );
}

Widget MyCommunity(double screnWidth, double screenHeight) {
  final List<String> virtues = [
    "Honesty is being truthful and sincere in both words and actions, without deceit or deception.",
    "Courage is the willingness to face fear, danger, or challenges with bravery and determination.",
    "Compassion is caring for others and wanting to help them when they are going through difficult times.",
    "Generosity is the act of giving or sharing with others, often without expecting anything in return.",
    "Fairness is treating people justly, not letting your personal feelings bias your decisions about others.",
    "Integrity is the practice of being honest and showing a consistent and uncompromising adherence to strong moral and ethical principles and values.",
    "Fidelity is faithfulness, loyalty, and the commitment to keeping promises and maintaining trust in a relationship or duty."
  ];
  return SingleChildScrollView(
    child: Container(
      color: Colours.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(top: screenHeight / 60),
                child: Container(
                    width: screnWidth / 1.5,
                    constraints: BoxConstraints(maxWidth: screnWidth),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colours.swatch("#D7F1F7")),
                    child: Center(
                      child: Text("Why are virtues important in my community?",
                          style: TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.normal,
                            color: Colours.swatch(clrBlack),
                          )),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: screenHeight / 60),
                child: Container(
                    // width: screnWidth/3,
                    constraints: BoxConstraints(maxWidth: screnWidth),
                    // decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(5),
                    //     color: Colours.swatch("#FAD4E3")
                    // ),
                    child: Center(
                      child: Text(
                          "The legal community has seen an increase in corruption. Using virtues ensures that those who practice law use their knowledge for noble purposes etc etc etc",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colours.swatch(clrBlack),
                          )),
                    )),
              ),
            ],
          ),
          Divider(
            endIndent: 10,
            indent: 10,
            color: Colours.swatch(clrBlack),
            height: screenHeight / 35,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: screenHeight / 60),
                child: Container(
                  width: screnWidth / 3,
                  constraints: BoxConstraints(maxWidth: screnWidth),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colours.swatch("#FAD4E3")),
                  child: Center(
                    child: Text("About my virtues:",
                        style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.normal,
                          color: Colours.swatch(clrBlack),
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight,
                child: ListView.builder(
                  itemCount: virtues.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Icon(
                        Icons.circle,
                        size: 10,
                      ), // You can replace this icon with a bullet point icon
                      title: Text(virtues[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: Colours.swatch(clrBlack),
                          )),
                    );
                  },
                ),
              )
            ],
          )
        ],
      ),
    ),
  );
}
