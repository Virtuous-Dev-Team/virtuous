import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colours/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:virtuetracker/App_Configuration/appConfig.dart';
import 'package:virtuetracker/Models/UserInfoModel.dart';
import 'package:virtuetracker/api/users.dart';
import 'package:virtuetracker/widgets/appBarWidget.dart';
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
  // Store data from a call with the same radius
  Map<String, Map<String, dynamic>>? cachedVirtueEntriesMap;
  List<_ChartData> chartData = [];
  @override
  Widget build(BuildContext context) {

    final userInfo = ref.watch(userInfoProviderr);
    shareLocation = userInfo.shareLocation;
    communityName = userInfo.currentCommunity;

    late TooltipBehavior _tooltip;

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
                    " ${communityName}",
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
                                width: 180,
                                child: DropdownButtonFormField<String>(
                                  value: 'Last week',
                                  items: <String>[
                                    'Last week',
                                    'Last 3 mo',
                                    'Last 6 mo',
                                    'Last yr'
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
                                    contentPadding: EdgeInsets.only(left: 10),
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
                                width: 190,
                                child: DropdownButtonFormField<String>(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide()), // Remove the border from the dropdown field
                                    contentPadding: EdgeInsets.only(
                                        left: 10), // Remove content padding
                                  ),
                                  value: '10km',
                                  iconSize:
                                      24, // Set the size of the dropdown icon
                                  onChanged: (String? newValue) async {
                                    String num = newValue!.replaceAll('km', '');
                                    double newRadius = double.parse(num);
                                    print('radius in onchange: $newRadius');
                                    setState(() {
                                      radius = newRadius;
                                      cachedVirtueEntriesMap = null; //delete the old map to trigger its replacement
                                    });
                                    // ref
                                    //     .read(usersRepositoryProvider)
                                    //     .getThoseEntries(
                                    //         shareLocation, radius);
                                  },
                                  items: <String>[
                                    '10km',
                                    '50km',
                                    '250km',
                                    '1000km',
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
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
    print('radius in render $radius');
    return StreamBuilder<Map<String, Map<String, dynamic>>>(
      stream: cachedVirtueEntriesMap == null
          ? usesAPI.getNearbyEntries(shareLocation, radius, communityName, timeFrame) : null,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && cachedVirtueEntriesMap == null) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          if (cachedVirtueEntriesMap == null) {
            Map<String, Map<String, dynamic>>? chartEntries =
            (snapshot.data?['chartEntries'] as Map<String, dynamic>?)?.map(
                  (key, value) => MapEntry(
                key,
                value as Map<String, dynamic>,
              ),
            );
            if (chartEntries != null) {
              cachedVirtueEntriesMap = chartEntries;
            } else {
              return Text('No data available'); // Handle null data gracefully
            }
          }
          List<_ChartData> chartData = buildChartData(cachedVirtueEntriesMap!, timeFrame);
          //Map<String, Map<String, dynamic>> virtueEntriesMap = snapshot.data!;
          //List<_ChartData> chartData = buildChartData(virtueEntriesMap, timeFrame);

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

  final Map<String, Map<String, Color>> communityColorLists = {
    'Legal': legalVirtueColors,
    'Alcoholics Anonymous': alAnVirtueColors,
    // Add other communities here if needed
  };

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
          pointColorMapper: (_ChartData data, _) => data.color,
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

DateTime getStartDate(String timeFrame, DateTime today) {
  DateTime startDate;
  // get start date for qualified entries
  if (timeFrame == 'Last week') {
    startDate = today.subtract(const Duration(days: 7));
  } else if (timeFrame == 'Last 3 mo') {
    startDate = today.subtract(const Duration(days: 90));
  } else if (timeFrame == 'Last 6 mo') {
    startDate = today.subtract(const Duration(days: 180));
  } else if (timeFrame == 'Last yr') {
    startDate = today.subtract(const Duration(days: 365));
  } else {
    print('invalid time frame');
    startDate = today.subtract(const Duration(days: 0));
  }

  return startDate;

}




List<_ChartData> buildChartData(Map<String, Map<String, dynamic>> virtueEntriesMap, String timeFrame) {

  // Contain the new chart data
  List<_ChartData> chartDataList = [];

  DateTime today = DateTime.now();
  DateTime startDate = getStartDate(timeFrame, today);

  // for each virtue from the map
  for (var entry in virtueEntriesMap.entries) {
    String virtueUsed = entry.key;
    Map<String, dynamic> virtueDataMap = entry.value;
    String colorString = virtueDataMap['color'];
    if (colorString.startsWith("0x")) {
      colorString = colorString.substring(2);
    }
    Color virtueColor = Color(int.parse(colorString, radix: 16));
    List<DocumentSnapshot<Object?>> virtueEntries = virtueDataMap['entries'];
    _ChartData virtueData = _ChartData(virtueUsed, [], virtueColor);

    // Decide whether to add each entry
    for (var doc in virtueEntries) {
      dynamic data = doc.data();
      // Check the time of each entry
      Timestamp? entryTime = data['dateEntried'] as Timestamp?;
      DateTime? dateEntered = entryTime != null ? entryTime.toDate() : today;
      if (!dateEntered.isAfter(startDate)) {
        continue;
      }
      virtueData.y.add(data);
    }
    chartDataList.add(virtueData);
  }
  return chartDataList;


}

class _ChartData {
  _ChartData(this.x, this.y, this.color);

  String x;
  List y;
  Color color;
}
