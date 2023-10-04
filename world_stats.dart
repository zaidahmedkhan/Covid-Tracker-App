import 'package:covid_tracker/Services/stats_services.dart';
import 'package:covid_tracker/view/countries_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:covid_tracker/Models/WorldStatsModel.dart'; // Check the path and filename

class WorldStats extends StatefulWidget {
  const WorldStats({super.key});

  @override
  State<WorldStats> createState() => _WorldStatsState();
}

class _WorldStatsState extends State<WorldStats> with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 5), vsync: this)
        ..repeat();
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final colorList = <Color>[
    const Color(0xff4285F4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StatsServices statsServices = StatsServices();

    return Scaffold(
      // backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * .03),
            FutureBuilder(
                future: statsServices.fetchGlobalCovidData(),
                builder: (context, AsyncSnapshot<WorldStatsModels> snapshot) {
                  if (!snapshot.hasData) {
                    return Expanded(
                        flex: 1,
                        child: SpinKitFadingCircle(
                          color: Colors.white,
                        ));
                    // size: 50,
                    // ontroller: _controller);
                  } else {
                    return Column(
                      children: [
                        PieChart(
                          dataMap: {
                            "Total":
                                double.parse(snapshot.data!.cases!.toString()),
                            "Recovered": double.parse(
                                snapshot.data!.recovered.toString()),
                            "Deaths":
                                double.parse(snapshot.data!.deaths.toString())
                          },
                          chartValuesOptions: const ChartValuesOptions(
                              showChartValuesInPercentage: true),
                          legendOptions: const LegendOptions(
                              legendPosition: LegendPosition.left),
                          animationDuration: Duration(milliseconds: 2000),
                          chartType: ChartType.disc,
                          colorList: colorList,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.01),
                          child: Card(
                            child: Column(
                              children: [
                                ReusableRow(
                                    title: "Total",
                                    value: snapshot.data!.cases.toString()),
                                ReusableRow(
                                    title: "Deaths",
                                    value: snapshot.data!.deaths.toString()),
                                ReusableRow(
                                    title: "Recovered",
                                    value: snapshot.data!.recovered.toString()),
                                ReusableRow(
                                    title: "Active",
                                    value: snapshot.data!.active.toString()),
                                ReusableRow(
                                    title: "Critical",
                                    value: snapshot.data!.critical.toString()),
                                ReusableRow(
                                    title: "Today Deaths",
                                    value:
                                        snapshot.data!.todayDeaths.toString()),
                                ReusableRow(
                                    title: "Today Recovered",
                                    value: snapshot.data!.todayRecovered
                                        .toString()),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return const CountriesList();
                            }));
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(15)),
                            child: const Center(child: Text("Track Countries")),
                          ),
                        )
                      ],
                    );
                  }
                }),
          ],
        ),
      )),
    );
  }
}

class ReusableRow extends StatelessWidget {
  String title, value;
  ReusableRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 2),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
              ),
              Text(value),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          const Divider(),
        ],
      ),
    );
  }
}
