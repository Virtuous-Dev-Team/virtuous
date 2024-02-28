import 'package:colours/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../App_Configuration/apptheme.dart';
import '../Models/CalendarModel.dart';
import '../Models/ChartDataModel.dart';
import '../widgets/Calendar.dart';
import '../widgets/appBarWidget.dart';

class AnalysisPage extends StatelessWidget {
  const AnalysisPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('David', 25),
      ChartData('Steve', 38),
      ChartData('Jack', 34),
      ChartData('Others', 52)
    ];
    List<CalendarModel> calendarData = [];
    List<DateTime> HonestyDates = [
      DateTime(2024, 02, 1),
      DateTime(2024, 02, 3),
      DateTime(2024, 02, 5),
    ];
    List<DateTime> CourageDates = [
      DateTime(2024, 02, 7),
      DateTime(2024, 02, 9),
      DateTime(2024, 02, 11),
    ];
    List<DateTime> CompassionDates = [
      DateTime(2024, 02, 13),
      DateTime(2024, 02, 15),
      DateTime(2024, 02, 17),
    ];
    List<DateTime> GenerosityDates = [
      DateTime(2024, 02, 19),
      DateTime(2024, 02, 21),
      DateTime(2024, 02, 23),
    ];
    List<DateTime> FidelityDates = [
      DateTime(2024, 02, 25),
      DateTime(2024, 02, 27),
      DateTime(2024, 02, 2),
    ];
    List<DateTime> IntegrityDates = [
      DateTime(2024, 02, 4),
      DateTime(2024, 02, 6),
      DateTime(2024, 02, 8),
    ];
    List<DateTime> FairnessDates = [
      DateTime(2024, 02, 10),
      DateTime(2024, 02, 12),
      DateTime(2024, 02, 14),
    ];
    List<DateTime> PrudenceDates = [
      DateTime(2024, 02, 16),
      DateTime(2024, 02, 18),
      DateTime(2024, 02, 20),
    ];
    List<DateTime> SelfControlDates = [
      DateTime(2024, 02, 22),
      DateTime(2024, 02, 24),
      DateTime(2024, 02, 26),
    ];
    calendarData.add(CalendarModel(
        CompassionList: CompassionDates,
        CourageList: CourageDates,
        FairnessList: FairnessDates,
        FidelityList: FidelityDates,
        GenerosityList: GenerosityDates,
        HonestyList: HonestyDates,
        IntegrityList: IntegrityDates,
        PrudenceList: PrudenceDates,
        SelfControlList: SelfControlDates));

    CustomCalender calendar = CustomCalender();
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
            backgroundColor: Color(0xFFEFE5CC),
            appBar: AppBarWidget('regular'),
            body: Container(
              decoration: BoxDecoration(
                color: Color(0xFFFFFDF9),
                border: Border.all(color: Color(0xFFFEFE5CC), width: 9.0),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(0.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Colours.white,
                      child: Center(
                          child: Expanded(
                              child: calendar.customCalender(
                                  context, calendarData))),
                    ),
                    SfCircularChart(series: <CircularSeries>[
                      // Render pie chart
                      PieSeries<ChartData, String>(
                          dataSource: chartData,
                          pointColorMapper: (ChartData data, _) => data.color,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y)
                    ]),
                    Divider(
                      endIndent: 10,
                      indent: 10,
                      color: Colours.swatch("#534D3F"),
                      height: MediaQuery.of(context).size.height / 35,
                    ),
                    Padding(
                      padding:  EdgeInsets.only(bottom: screenHeight/50),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: screenWidth / 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Top 3 Virtues",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.italic,
                                    color: Colours.swatch(clrBlack),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: screenHeight / 50,left: screenWidth/50),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 25,
                                        height: 25,
                                        color: Colours.swatch(clrHonesty),
                                      ),
                                      Text("Honesty",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            fontStyle: FontStyle.italic,
                                            color: Colours.swatch(clrBlack),
                                          )),
                                      Text("10",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            fontStyle: FontStyle.italic,
                                            color: Colours.swatch(clrBlack),
                                          )),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: screenHeight / 50,left: screenWidth/50),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 25,
                                        height: 25,
                                        color: Colours.swatch(clrCourage),
                                      ),
                                      Text("Courage",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            fontStyle: FontStyle.italic,
                                            color: Colours.swatch(clrBlack),
                                          )),
                                      Text("7",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            fontStyle: FontStyle.italic,
                                            color: Colours.swatch(clrBlack),
                                          )),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: screenHeight / 50,left: screenWidth/50),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 25,
                                        height: 25,
                                        color: Colours.swatch(clrFairness),
                                      ),
                                      Text("Fairness",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            fontStyle: FontStyle.italic,
                                            color: Colours.swatch(clrBlack),
                                          )),
                                      Text("5",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            fontStyle: FontStyle.italic,
                                            color: Colours.swatch(clrBlack),
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: screenWidth / 2.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Bottom 3 Virtues",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FontStyle.italic,
                                    color: Colours.swatch(clrBlack),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: screenHeight / 50,right: screenWidth/50),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 25,
                                        height: 25,
                                        color: Colours.swatch(clrGenerosity),
                                      ),
                                      Text("Generosity",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            fontStyle: FontStyle.italic,
                                            color: Colours.swatch(clrBlack),
                                          )),
                                      Text("1",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            fontStyle: FontStyle.italic,
                                            color: Colours.swatch(clrBlack),
                                          )),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: screenHeight / 50,right: screenWidth/50),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 25,
                                        height: 25,
                                        color: Colours.swatch(clrFidelity),
                                      ),
                                      Text("Fidelity",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            fontStyle: FontStyle.italic,
                                            color: Colours.swatch(clrBlack),
                                          )),
                                      Text("2",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            fontStyle: FontStyle.italic,
                                            color: Colours.swatch(clrBlack),
                                          )),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(top: screenHeight / 50,right: screenWidth/50),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        width: 25,
                                        height: 25,
                                        color: Colours.swatch(clrSelfControl),
                                      ),
                                      Text("Self-Control",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            fontStyle: FontStyle.italic,
                                            color: Colours.swatch(clrBlack),
                                          )),
                                      Text("3",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.normal,
                                            fontStyle: FontStyle.italic,
                                            color: Colours.swatch(clrBlack),
                                          )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )));
  }



}
