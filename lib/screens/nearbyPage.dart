import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colours/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:virtuetracker/App_Configuration/appColors.dart';
import 'package:virtuetracker/Models/UserInfoModel.dart';
import 'package:virtuetracker/api/users.dart';
import 'package:virtuetracker/widgets/appBarWidget.dart';
import 'package:virtuetracker/api/users.dart';

import '../App_Configuration/apptheme.dart';
//import '../widgets/appBarWidget.dart';

// Color palette
const Color appBarColor = Color(0xFFC4DFD3);
const Color mainBackgroundColor = Color(0xFFF3E8D2);
const Color buttonColor = Color(0xFFCEC0A1);
const Color bottomNavBarColor = Color(0xFFA6A1CC);
const Color iconColor = Color(0xFF000000);
const Color textColor = Colors.white;

Users usesAPI = Users();

class NearbyPage extends ConsumerStatefulWidget {
  const NearbyPage({Key? key}) : super(key: key);

  @override
  _NearbyPageState createState() => _NearbyPageState();
}

class _NearbyPageState extends ConsumerState<NearbyPage> {
  @override
  void initState() {
    super.initState();
    final userInfo = ref.read(userInfoProviderr);
    shareLocation = userInfo.shareLocation;
    communityName = userInfo.currentCommunity;
  }

  @override
  void dispose() {
    super.dispose();
  }

  late bool shareLocation;
  late String communityName;

  double radius = 10;
  String timeFrame = "Last week";
  List<_ChartData> chartData = [];
  @override
  Widget build(BuildContext context) {
    late List<_ChartData> data;
    late TooltipBehavior _tooltip;
    //data = Users().getNearbyEntries;
    data = [
      _ChartData('Prudence', [1, 1, 1, 1, 1, 1]),
      _ChartData('Self-control', [1, 1, 1, 1, 1, 1]),
      _ChartData('Fairness', [1, 1, 1, 1, 1, 1]),
      _ChartData('Integrity', [1, 1, 1, 1, 1, 1]),
      _ChartData('Fidelity', [1, 1, 1, 1, 1, 1]),
      _ChartData('Generosity', [1, 1, 1, 1, 1, 1]),
      _ChartData('Compassion', [1, 1, 1, 1, 1, 1]),
      _ChartData('Courage', [1, 1, 1, 1, 1, 1]),
      _ChartData('Honesty', [1, 1, 1, 1, 1, 1]),
    ];
    _tooltip = TooltipBehavior(enable: false);
    return Scaffold(
        backgroundColor: Color(0xFFEFE5CC),
        appBar: AppBarWidget('regular'),
        // appBar: AppBar(
        //   backgroundColor: appBarColor,
        //   elevation: 0,
        //   actions: [
        //     IconButton(
        //       icon: Icon(Icons.account_circle, size: 30, color: iconColor),
        //       onPressed: () {
        //         // TODO: Implement profile icon functionality.
        //       },
        //     ),
        //     SizedBox(width: 12),
        //   ],
        // ),
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
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "${communityName}",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 25),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 9.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Time Range'),
                              SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: 30,
                                width: 160,
                                child: DropdownButtonFormField<String>(
                                  value: 'Last week',
                                  items: <String>[
                                    'Last week',
                                    'Last 3 months',
                                    'Last 6 months',
                                    'Last year'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,
                                          style: TextStyle(
                                              fontSize:
                                                  15)), // Match font size here
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      timeFrame = newValue!;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(), // Remove circular border
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 30),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Maximum Distance'),
                              SizedBox(
                                height: 5,
                              ),
                              SizedBox(
                                height: 30,
                                width: 160,
                                child: DropdownButtonFormField<String>(
                                  value: '10km',
                                  items: <String>[
                                    '10km',
                                    '50km',
                                    '250km',
                                    '1000km',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,
                                          style: TextStyle(
                                              fontSize:
                                                  15)), // Match font size here
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) async {
                                    String num = newValue!.replaceAll('km', '');
                                    double newRadius = double.parse(num!);
                                    print('radius in onchange: $newRadius');
                                    setState(() {
                                      radius = newRadius;
                                    });
                                    // ref
                                    //     .read(usersRepositoryProvider)
                                    //     .getThoseEntries(
                                    //         shareLocation, radius);
                                  },
                                  decoration: InputDecoration(
                                    contentPadding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(), // Remove circular border
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  renderNearbyBarChart(shareLocation)
                ],
              ),
            ),
          ),
        ));
  }

  Widget renderNearbyBarChart(bool shareLocation) {
    print('radiues in render $radius');
    return StreamBuilder<List<DocumentSnapshot<Object?>>>(
      stream: usesAPI.getThoseEntries(
          shareLocation, radius), // Call your function here
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<DocumentSnapshot<Object?>> documents = snapshot.data ?? [];
          List<_ChartData> chartData = buildChartData(documents, timeFrame);

          // Use the documents list here
          return RenderNearbyBarChart(
            data: chartData,
            timeFrame: timeFrame,
          );
        }
      },
    );
  }
}

class RenderNearbyBarChart extends StatefulWidget {
  const RenderNearbyBarChart(
      {super.key, required this.data, required this.timeFrame});
  final List<_ChartData> data;
  final String timeFrame;

  @override
  State<RenderNearbyBarChart> createState() => Render_NearbyBarChartState();
}

class Render_NearbyBarChartState extends State<RenderNearbyBarChart> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0, // Remove background margins
      enableSideBySideSeriesPlacement: false,

      primaryXAxis: CategoryAxis(
          isVisible: true,
          axisLine: AxisLine(
            width: 3,
            color: Colours.swatch("#534D3F"),
          ),
          labelPosition: ChartDataLabelPosition.outside, // X-axis labels inside
          edgeLabelPlacement:
              EdgeLabelPlacement.none, // Prevent labels from getting cut off
          labelStyle: TextStyle(),
          tickPosition: TickPosition.inside,
          majorTickLines: MajorTickLines(size: 0, width: 0),
          minorTickLines: MinorTickLines(size: 0, width: 0),
          minorGridLines: MinorGridLines(width: 0),
          majorGridLines: MajorGridLines(width: 0),
          plotOffset: 4),

      primaryYAxis: NumericAxis(
          isVisible: true,
          axisLine: AxisLine(width: 3, color: Colours.swatch("#534D3F")),
          rangePadding: ChartRangePadding.auto,
          plotOffset: 2,
          majorTickLines: MajorTickLines(size: 0, width: 0),
          minorTickLines: MinorTickLines(size: 0, width: 0),
          minorGridLines: MinorGridLines(width: 0),
          majorGridLines: MajorGridLines(width: 0)),

      series: <CartesianSeries<_ChartData, String>>[
        BarSeries<_ChartData, String>(
          dataSource: widget.data,
          xValueMapper: (_ChartData data, _) => data.x,
          yValueMapper: (_ChartData data, _) => data.y.length,
          name: 'Analysis',
          color: Color.fromRGBO(8, 142, 255, 1), // Default color for all bars
          // Custom color for each bar
          pointColorMapper: (_ChartData data, _) {
            // Return custom colors based on your logic
            return legalVirtueColors[data.x];
          },
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            labelAlignment: ChartDataLabelAlignment.auto,
            alignment: ChartAlignment.near,
          ),
        ),
      ],
    );
  }
}

class NearbyBarChart extends StatelessWidget {
  const NearbyBarChart({super.key, required this.data});
  final List<_ChartData> data;
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      plotAreaBorderWidth: 0, // Remove background margins
      enableSideBySideSeriesPlacement: false,

      primaryXAxis: CategoryAxis(
          isVisible: true,
          axisLine: AxisLine(
            width: 3,
            color: Colours.swatch("#534D3F"),
          ),
          labelPosition: ChartDataLabelPosition.outside, // X-axis labels inside
          edgeLabelPlacement:
              EdgeLabelPlacement.none, // Prevent labels from getting cut off
          labelStyle: TextStyle(),
          tickPosition: TickPosition.inside,
          majorTickLines: MajorTickLines(size: 0, width: 0),
          minorTickLines: MinorTickLines(size: 0, width: 0),
          minorGridLines: MinorGridLines(width: 0),
          majorGridLines: MajorGridLines(width: 0),
          plotOffset: 4),

      primaryYAxis: NumericAxis(
          isVisible: true,
          axisLine: AxisLine(width: 3, color: Colours.swatch("#534D3F")),
          rangePadding: ChartRangePadding.auto,
          plotOffset: 2,
          majorTickLines: MajorTickLines(size: 0, width: 0),
          minorTickLines: MinorTickLines(size: 0, width: 0),
          minorGridLines: MinorGridLines(width: 0),
          majorGridLines: MajorGridLines(width: 0)),

      series: <CartesianSeries<_ChartData, String>>[
        BarSeries<_ChartData, String>(
          dataSource: data,
          xValueMapper: (_ChartData data, _) => data.x,
          yValueMapper: (_ChartData data, _) => data.y.length,
          name: 'Analysis',
          color: Color.fromRGBO(8, 142, 255, 1), // Default color for all bars
          // Custom color for each bar
          pointColorMapper: (_ChartData data, _) {
            // Return custom colors based on your logic
            return legalVirtueColors[data.x];
          },
          dataLabelSettings: DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            labelAlignment: ChartDataLabelAlignment.auto,
            alignment: ChartAlignment.near,
          ),
        ),
      ],
    );
  }
}

List<_ChartData> buildChartData(dynamic eventList, String timeFrame) {
  List<_ChartData> listy = [];
  _ChartData prudence = _ChartData('Prudence', []);
  _ChartData selfControl = _ChartData('Self-control', []);
  _ChartData fairness = _ChartData('Fairness', []);
  _ChartData integrity = _ChartData('Integrity', []);
  _ChartData fidelity = _ChartData('Fidelity', []);
  _ChartData generosity = _ChartData('Generosity', []);
  _ChartData compassion = _ChartData('Compassion', []);
  _ChartData courage = _ChartData('Courage', []);
  _ChartData honesty = _ChartData('Honesty', []);
  DateTime startDate;
  DateTime today = DateTime.now();

  // get start date for qualified entries
  if (timeFrame == 'Last week') {
    startDate = today.subtract(const Duration(days: 7));
  } else if (timeFrame == 'Last 3 months') {
    startDate = today.subtract(const Duration(days: 90));
  } else if (timeFrame == 'Last 6 months') {
    startDate = today.subtract(const Duration(days: 180));
  } else if (timeFrame == 'Last year') {
    startDate = today.subtract(const Duration(days: 365));
  } else {
    print('invalid time frame');
    startDate = today.subtract(const Duration(days: 0));
  }
  for (var event in eventList) {
    // Access each document in the stream
    dynamic data = event.data();
    String virtueUsed = data['quadrantUsed'];
    Timestamp? entryTime = data['dateEntried'] as Timestamp?;
    DateTime? dateEntered = entryTime != null ? entryTime.toDate() : today;

    // if date of entry is within time frame, add to parsed list
    if (!dateEntered.isAfter(startDate)) {
      continue;
    }
    switch (virtueUsed) {
      case "Honesty":
        {
          honesty.y.add(data);
        }
      case "Courage":
        {
          courage.y.add(data);
        }
      case "Compassion":
        {
          compassion.y.add(data);
        }
      case "Generosity":
        {
          generosity.y.add(data);
        }
      case "Fidelity":
        {
          fidelity.y.add(data);
        }
      case "Integrity":
        {
          integrity.y.add(data);
        }
      case "Fairness":
        {
          fairness.y.add(data);
        }
      case "Self-control":
        {
          selfControl.y.add(data);
        }
      case "Prudence":
        {
          prudence.y.add(data);
        }
    }
  }
  listy.addAll([
    honesty,
    compassion,
    courage,
    selfControl,
    integrity,
    fairness,
    fidelity,
    prudence,
    generosity
  ]);
  return listy;
}

class _ChartData {
  _ChartData(this.x, this.y);

  String x;
  List y;
}
