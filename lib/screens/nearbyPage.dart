import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:colours/colours.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:virtuetracker/App_Configuration/appConfig.dart';
import 'package:virtuetracker/Models/UserInfoModel.dart';
import 'package:virtuetracker/api/users.dart';
import 'package:virtuetracker/widgets/appBarWidget.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_supercluster/flutter_map_supercluster.dart';


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
    cachedVirtueEntriesMap = null;
    cachedMarkers;
    shareLocation = userInfo.shareLocation;
    communityName = userInfo.currentCommunity;

    // get initial entry information
    prefetchNearbyEntries();

    // get initial bounds on map load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      currentBounds = _mapController.bounds ?? currentBounds;
      print("Initial bounds points: ");
      print("   NW: ${currentBounds.northWest} SE: ${currentBounds.southEast}");
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  late bool shareLocation;
  late String communityName;

  // current bounds initializes as all of North America, should change on map load
  LatLngBounds currentBounds = LatLngBounds(
    LatLng(28.70, -127.50),
    LatLng(48.85, -55.90)
  );

  String timeFrame = "Last week";
  // Store data from a call with the same radius
  Map<String, Map<String, dynamic>>? cachedVirtueEntriesMap;
  LatLng? savedUserLocation;
  List<_ChartData> chartData = [];
  Map<String, List<Map<String, dynamic>>> cachedMarkers = {};
  List<Marker> markers = [];

  // map center point for viewing
  //static final _defaultCenter = LatLng(51.509364, -0.128928);
  static var _currentCenter = LatLng(51.509364, -0.128928);
  // Generate 300 markers with randomized locations
  //static final _random = Random(42);
  /*
  static final _markers = List<Marker>.generate(
    300,
    (_) => Marker(
        //builder: (context) => const Icon(Icons.location_on),
        point: LatLng(
          _random.nextDouble() * 3 - 1.5 + _currentCenter.latitude,
          _random.nextDouble() * 3 - 1.5 + _currentCenter.longitude,
        ),
        // Marker Icon
        builder: (context) => const Icon(Icons.location_on)),
  );
*/
  // Set these with whatever want for backend
  final MapController _mapController = MapController();
  // Experimenting with bounds
  // LatLng _southwestCorner = LatLng(51.0, -0.5);
  // LatLng _northeastCorner = LatLng(52.0, 0.5);
  double _currentZoom = 10;
  double _minZoom = 3;
  double _maxZoom = 12;

  @override
  Widget build(BuildContext context) {
    final userInfo = ref.watch(userInfoProviderr);

    // Detect if community has changed
    if (communityName != userInfo.currentCommunity) {
      setState(() {
        communityName = userInfo.currentCommunity;
        cachedVirtueEntriesMap = null; // Reset cached data to trigger API call
      });
    }

    shareLocation = userInfo.shareLocation;

    late TooltipBehavior _tooltip;

    _tooltip = TooltipBehavior(enable: false);
    return Scaffold(
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
              //height: MediaQuery.of(context).size.height,
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).padding.top,
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
                      SizedBox(
                        height: 300,
                        child: buildMapWidget(),
                      ),
                    SizedBox(height: 25),

                              // Alicia:
                              // interactiveFlags could help us limit user interaction
                                // directly with the map if we need to
                              // we can set bounds but idk what it would be
                              // bounds: LatLngBounds(
                              //   _southwestCorner,
                              //   _northeastCorner,
                              // ),
                              // boundsOptions: FitBoundsOptions(
                              //   padding:EdgeInsets.all(10.0),
                              // ),

                      SizedBox(width: 30),
                      // Basic Slider Implementation with Dummy Variables
                      Slider(
                        value: _currentZoom,
                        min: _minZoom,
                        max: _maxZoom,
                        label: _currentZoom.toStringAsFixed(1),
                        onChanged: (value) {
                          setState(() {
                            _currentZoom = value;
                            _mapController.move(
                                _currentCenter,
                                _currentZoom,
                            );
                          });
                        },
                      ),
                      SizedBox(height: 25),
                      SizedBox(width: 30),
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
                                          markers = buildVirtueMarkers(cachedMarkers);
                                        });
                                      },
                                      decoration: InputDecoration(
                                        contentPadding:
                                            EdgeInsets.only(left: 10),
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
                                  // Text('Maximum Distance'),
                                  // SizedBox(
                                  //   height: 5,
                                  // ),
                                  // SizedBox(
                                  //   height: 30,
                                  //   width: 190,
                                  //   child: DropdownButtonFormField<String>(
                                  //     decoration: InputDecoration(
                                  //       border: OutlineInputBorder(
                                  //           borderSide:
                                  //               BorderSide()), // Remove the border from the dropdown field
                                  //       contentPadding: EdgeInsets.only(
                                  //           left: 10), // Remove content padding
                                  //     ),
                                  //     value: '10km',
                                  //     iconSize:
                                  //         24, // Set the size of the dropdown icon
                                  //     onChanged: (String? newValue) async {
                                  //       String num =
                                  //           newValue!.replaceAll('km', '');
                                  //       double newRadius = double.parse(num);
                                  //       print('radius in onchange: $newRadius');
                                  //       setState(() {
                                  //         radius = newRadius;
                                  //         markers = buildVirtueMarkers(cachedMarkers);
                                  //       });
                                  //     },
                                  //     items: <String>[
                                  //       '10km',
                                  //       '50km',
                                  //       '250km',
                                  //       '1000km',
                                  //     ].map((String value) {
                                  //       return DropdownMenuItem<String>(
                                  //         value: value,
                                  //         child: Text(value),
                                  //       );
                                  //     }).toList(),
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      renderNearbyBarChart()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  // get the entries from the api
  Future<void> prefetchNearbyEntries() async {
    try {
      final data = await usesAPI.getNearbyEntries(shareLocation, communityName, timeFrame).first;

      // Cache chart data
      cachedVirtueEntriesMap = (data['chartEntries'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, value as Map<String, dynamic>),
      );

      // Cache user location
      LatLng? newUserLocation  = data['userLocation'] != null
          ? LatLng(data['userLocation'].latitude, data['userLocation'].longitude)
          : null;

      setState(() {
        savedUserLocation = newUserLocation;
        _currentCenter = newUserLocation!;
        cachedMarkers = data['mapEntries'];
        markers = buildVirtueMarkers(cachedMarkers);
      });

    } catch (e) {
      print("Error getting data from API: $e");
    }
  }

  // make the nearby bar chart
  Widget renderNearbyBarChart() {

    if (cachedVirtueEntriesMap == null) {
      return CircularProgressIndicator(); // Show a loader until data is ready
    }

    // Build chart data
    List<_ChartData> chartData = buildChartData(
      cachedVirtueEntriesMap!,
      timeFrame,
      currentBounds
    );

    // Return the bar chart widget
    return RenderNearbyBarChart(
      data: chartData,
      timeFrame: timeFrame,
    );
  }

  Widget buildMapWidget() {
    if (savedUserLocation == null) {
      return CircularProgressIndicator(); // Loader until data is ready
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: savedUserLocation,
        zoom: _currentZoom,
        minZoom: _minZoom,
        maxZoom: _maxZoom,
        onPositionChanged: (mapPosition, _) {
          setState(() {
            _currentZoom = mapPosition.zoom!;
            _currentCenter = mapPosition.center!;
            currentBounds = mapPosition.bounds!;
            print("new camera bounds = NW: ${currentBounds.northWest} SE: ${currentBounds.southEast}");
          });
        },
      ),
      children: [
        TileLayer(
          urlTemplate:
              // TODO: add api key
          'https://tiles.stadiamaps.com/tiles/stamen_toner/{z}/{x}/{y}.png?api_key=',
        ),
        SuperclusterLayer.immutable(
          // Replaces MarkerLayer
          key: ValueKey(markers.hashCode),
          initialMarkers: markers,
          indexBuilder: IndexBuilders.rootIsolate,
          builder: (context, position, markerCount,
              extraClusterData) =>
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.blue,
                ),
                child: Center(
                  child: Text(
                    markerCount.toString(),
                    style:
                    const TextStyle(color: Colors.white),
                  ),
                ),
              ),
        ),
      ],
    );
  }


  List<Marker> buildVirtueMarkers(
      Map<String, List<Map<String, dynamic>>> virtueLocations
      ) {
    List<Marker> markers = [];
    virtueLocations.forEach((virtue, locations) {
      for (var location in locations) {
        LatLng position = LatLng(location['latitude'], location['longitude']);
        String colorString = location['color'];
        if (colorString.startsWith("0x")) {
          colorString = colorString.substring(2);
        }

        DateTime? dateEntered =  location['dateEntried'];
        if (!isMapEntryValid(
          dateEntered: dateEntered,
          entryLocation: position,
          cameraBounds: currentBounds
        ))
        {
          continue;
        }

        Color virtueColor = Color(int.parse(colorString, radix: 16));
        markers.add(
          Marker(
            point: position,
              builder: (context) => Icon(
              Icons.location_on,
              color: virtueColor,
            ),
          ),
        );
      }
    });

    return markers;
  }


  bool isMapEntryValid({
    required DateTime? dateEntered,
    required LatLng entryLocation,
    required LatLngBounds cameraBounds
  }) {
    DateTime today = DateTime.now();
    DateTime startDate = getStartDate(timeFrame, today);

    // Ensure the entry date is within the specified time frame
    if (dateEntered == null || dateEntered.isBefore(startDate)) {
      return false;
    }

    // Compare entry location to bounds to determine if it is in the camera view
    if (!cameraBounds.contains(entryLocation)){
      // out of bounds
      return false;
    }
   
    // Entry is valid
    return true;
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
    super.initState();
  }

  // This is hard coded right now.
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

List<_ChartData> buildChartData(Map<String, Map<String, dynamic>> virtueEntriesMap, String timeFrame, LatLngBounds cameraBounds) {

  // Contain the new chart data
  List<_ChartData> chartDataList = [];

  DateTime today = DateTime.now();

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
      // Get the time of each entry
      Timestamp? entryTime = data['dateEntried'] as Timestamp?;
      DateTime? dateEntered = entryTime != null ? entryTime.toDate() : today;

      // get entry location as LatLng
      final locationEntered = data['userLocation'] as Map<String,dynamic>;
      GeoPoint entryGeoPoint = locationEntered['geopoint'] as GeoPoint;
      final latitude = entryGeoPoint.latitude;
      final longitude = entryGeoPoint.longitude;
      LatLng entryLocation = LatLng(latitude, longitude);

      // check all parameters and add if all are met
      if (isEntryValid(
        timeFrame: timeFrame,        // Provide named arguments
        dateEntered: dateEntered,
        entryLocation: entryLocation,
        cameraBounds: cameraBounds, 
      ))
        {
          virtueData.y.add(data);
        }
    }
    chartDataList.add(virtueData);
  }
  return chartDataList;
}

bool isEntryValid({
  required String timeFrame,
  required DateTime? dateEntered,
  required LatLng entryLocation,
  required LatLngBounds cameraBounds
}) {
  DateTime today = DateTime.now();
  DateTime startDate = getStartDate(timeFrame, today);

  // Ensure the entry date is within the specified time frame
  if (dateEntered == null || dateEntered.isBefore(startDate)) {
    return false;
  }

  // Compare entry location to bounds to determine if it is in the camera view
  if (!cameraBounds.contains(entryLocation)){
    // out of bounds
    return false;
  }

  // Entry is valid
  return true;

}

class _ChartData {
  _ChartData(this.x, this.y, this.color);

  String x;
  List y;
  Color color;
}
