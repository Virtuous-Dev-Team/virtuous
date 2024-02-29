import 'package:colours/colours.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:virtuetracker/controllers/pieChartController.dart';
import 'package:virtuetracker/controllers/statsController.dart';

import '../App_Configuration/apptheme.dart';
import '../Models/LegalCalendarModel.dart';
import '../Models/ChartDataModel.dart';
import '../widgets/Calendar.dart';
import '../widgets/appBarWidget.dart';

class AnalysisPage extends ConsumerWidget {
  const AnalysisPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Calendar
    List<LegalCalendarModel> calendarData = [];
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
    calendarData.add(LegalCalendarModel(
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
    return Consumer(builder: (context, ref, _) {
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
                      RenderBottom(),
                    ],
                  ),
                ),
              )));
    });
  }
}

class RenderBottom extends ConsumerWidget {
  const RenderBottom({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state =
        ref.watch(PieChartControllerProvider((communityName: "legal")));
    return state.when(
        data: (response) {
          final pieChartData = response['pieChart'];
          final topThreeVirtues = response['topThreeVirtues'];
          final bottomThreeVirtues = response['bottomThreeVirtues'];
          return Column(
            children: [
              RenderPieChart(chartData: pieChartData),
              Divider(
                endIndent: 10,
                indent: 10,
                color: Colours.swatch("#534D3F"),
                height: MediaQuery.of(context).size.height / 35,
              ),
              RenderQuadrantUsedList(
                topThreeVirtues: topThreeVirtues,
                bottomThreeVirtues: bottomThreeVirtues,
              )
            ],
          );
        },
        error: (error, st) {
          return Text('ero $error');
        },
        loading: () => CircularProgressIndicator());
  }
}

class RenderPieChart extends ConsumerWidget {
  const RenderPieChart({super.key, required this.chartData});
  final List<ChartData> chartData;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SfCircularChart(series: <CircularSeries>[
      // Render pie chart
      PieSeries<ChartData, String>(
          dataSource: chartData,
          pointColorMapper: (ChartData data, _) => data.color,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y)
    ]);
  }
}

class RenderQuadrantUsedList extends StatelessWidget {
  const RenderQuadrantUsedList(
      {super.key, this.topThreeVirtues, this.bottomThreeVirtues});
  final Map<String, int>? topThreeVirtues;
  final Map<String, int>? bottomThreeVirtues;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Container(
          padding: EdgeInsets.all(8),
          child: Column(children: [
            Center(
              child: Text(
                "Top 3 Virtues",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                  color: Colours.swatch(clrBlack),
                ),
              ),
            ),
            TopBottomVirtuesWidget(
              virtueList: topThreeVirtues,
            )
          ]),
        )),
        Expanded(
            child: Container(
          padding: EdgeInsets.all(8),
          child: Column(children: [
            Center(
              child: Text(
                "Bottom 3 Virtues",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                  color: Colours.swatch(clrBlack),
                ),
              ),
            ),
            TopBottomVirtuesWidget(
              virtueList: bottomThreeVirtues,
            )
          ]),
        )),
      ],
    );
  }
}

class TopBottomVirtuesWidget extends StatelessWidget {
  const TopBottomVirtuesWidget({
    super.key,
    this.virtueList,
  });

  final Map<String, int>? virtueList;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final entry = virtueList!.entries.elementAt(index);
        final key = entry.key;
        final value = entry.value;
        print('key: $key and val: $value');
        return Container(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    color: Colours.swatch(clrCompassion),
                  ),
                ),
                Expanded(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        padding: EdgeInsets.only(left: 10),
                        child: Text(key,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.normal,
                              fontStyle: FontStyle.italic,
                              color: Colours.swatch(clrBlack),
                            ))),
                    Text(value.toString(),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          fontStyle: FontStyle.italic,
                          color: Colours.swatch(clrBlack),
                        ))
                  ],
                )),
              ],
            ));
      },
      itemCount: virtueList!.length,
    );
  }
}
