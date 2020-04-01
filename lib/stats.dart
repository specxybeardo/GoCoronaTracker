import 'package:flutter/material.dart';
import 'package:CoronaTracker/apis/corona_service.dart';
import 'package:CoronaTracker/models/corona_case_country.dart';
import 'package:CoronaTracker/models/corona_case_total_count.dart';
import 'package:CoronaTracker/utils/utils.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import './models/covid_home.dart';


class StatsPage extends StatefulWidget {
  StatsPage({Key key}) : super(key: key);

  @override
  _StatsPage createState() => _StatsPage();
}



class _StatsPage extends State<StatsPage>
    with AutomaticKeepAliveClientMixin<StatsPage> {
  @override
  bool get wantKeepAlive => true;

  var service = CoronaService.instance;
  Future<CoronaTotalCount> _totalCountFuture;
  Future<List<CoronaCaseCountry>> _allCasesFuture;

  @override
  void initState() {
    _fetchData();
    super.initState();
  }

  _fetchData() {
    _totalCountFuture = service.fetchAllTotalCount();
    _allCasesFuture = service.fetchCases();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: Center(
            child: Container(
                constraints: BoxConstraints(maxWidth: 768),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      _buildTotalCountWidget(context),
                      Padding(
                        padding: EdgeInsets.only(left: 16, right: 16),
                        child: Divider(),
                      ),
                       Container(height: 100,child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15, bottom: 15),
              child: CovidCard(),
            )),
                      _buildAllCasesWidget(context)
                    ],
                  ),
                ))));
  }

  Widget _buildTotalCountWidget(BuildContext context) {
    return FutureBuilder(
        future: _totalCountFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.error != null) {
            return Padding(
                padding: EdgeInsets.only(top: 16, bottom: 16),
                child: Center(
                  child: Text('Error fetching total count data'),
                ));
          } else {
            final CoronaTotalCount totalCount = snapshot.data;

            final data = [
              LinearCases(CaseType.sick.index, totalCount.sick,
                  totalCount.sickRate.toInt(), "Infected"),
              LinearCases(CaseType.deaths.index, totalCount.deaths,
                  totalCount.fatalityRate.toInt(), "Deaths"),
              LinearCases(CaseType.recovered.index, totalCount.recovered,
                  totalCount.recoveryRate.toInt(), "Recovered")
            ];

            final series = [
              charts.Series<LinearCases, int>(
                id: 'Total Count',
                domainFn: (LinearCases cases, _) => cases.type,
                measureFn: (LinearCases cases, _) => cases.total,
                labelAccessorFn: (LinearCases cases, _) =>
                    '${cases.text}\n${Utils.numberFormatter.format(cases.count)}',
                colorFn: (cases, index) {
                  switch (cases.text) {
                    case "Confirmed":
                      return charts.ColorUtil.fromDartColor(Colors.blueAccent);
                    case "Infected":
                      return charts.ColorUtil.fromDartColor(
                          Colors.orangeAccent);
                    case "Recovered":
                      return charts.ColorUtil.fromDartColor(Colors.greenAccent);
                    default:
                      return charts.ColorUtil.fromDartColor(Colors.redAccent);
                  }
                },
                data: data,
              )
            ];

            return Padding(
                padding:
                    EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                          "Last updated: ${Utils.dateFormatter.format(DateTime.now())}"),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8),
                      ),
                      Text(
                        "Globally Total Coronavirus Cases:",
                        style: Theme.of(context).textTheme.headline,
                      ),
                      Container(
                          height: 200,
                          child: charts.PieChart(
                            series,
                            animate: true,
                            defaultRenderer: charts.ArcRendererConfig(
                                arcWidth: 60,
                                arcRendererDecorators: [
                                  charts.ArcLabelDecorator()
                                ]),
                          )),
                      Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 8),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    totalCount.confirmedText,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline
                                        .apply(color: Colors.blueAccent),
                                  ),
                                  Text("Coronavirus Cases")
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    totalCount.sickText,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline
                                        .apply(color: Colors.orangeAccent),
                                  ),
                                  Text("Infected")
                                ],
                              )
                            ]),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      totalCount.recoveredText,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline
                                          .apply(color: Colors.green),
                                    ),
                                    Text("Recovered")
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      totalCount.recoveryRateText,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline
                                          .apply(color: Colors.greenAccent),
                                    ),
                                    Text("Recovery Rate")
                                  ],
                                )
                              ])),
                      Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 16),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      totalCount.deathsText,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline
                                          .apply(color: Colors.red),
                                    ),
                                    Text("Deaths")
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      totalCount.fatalityRateText,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline
                                          .apply(color: Colors.redAccent),
                                    ),
                                    Text("Mortality Rate")
                                  ],
                                )
                              ])),
                    ]));
          }
        });
  }

  Widget _buildAllCasesWidget(BuildContext context) {
    return FutureBuilder(
      future: _allCasesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: EdgeInsets.only(top: 16, bottom: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.error != null) {
          return Padding(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: Center(
                child: Text('Error fetching total cases global data'),
              ));
        } else {
          if (snapshot.data == null || snapshot.data.length == 0) {
            return Padding(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: Center(child: Text("No Data")),
            );
          }

          final List<CoronaCaseCountry> cases = snapshot.data;
          var children = List<Widget>();

          var confirmedCasesData = List<OrdinalCases>();
          var deathsCasesData = List<OrdinalCases>();
          var recoveredCasesData = List<OrdinalCases>();

          cases.forEach((element) {
            final totalCount = element.coronaTotalCount;
            var tailTexts = List<String>();

            if (totalCount.deaths > 0) {
              tailTexts.add("D:${totalCount.deathsText}");
            }

            if (totalCount.recovered > 0) {
              tailTexts.add("R:${totalCount.recoveredText}");
            }

            final tailText = tailTexts.join(" - ");

            var country = element.country;
            if (tailText.isNotEmpty) {
              country += "\n" + tailText;
            }

            confirmedCasesData.add(OrdinalCases(
                country, element.totalSickCount, element.coronaTotalCount));
            deathsCasesData.add(
              OrdinalCases(
                  country, element.totalDeathsCount, element.coronaTotalCount),
            );
            recoveredCasesData.add(OrdinalCases(country,
                element.totalRecoveredCount, element.coronaTotalCount));
          });

          final int height =
              cases.fold(0, (previousValue, element) => previousValue + 40);

          var seriesList = [
            charts.Series<OrdinalCases, String>(
              id: 'Deaths',
              domainFn: (OrdinalCases cases, _) => cases.country,
              measureFn: (OrdinalCases cases, _) => cases.total,
              data: deathsCasesData,
              labelAccessorFn: (OrdinalCases cases, _) {
                return null;
              },
              colorFn: (datum, index) =>
                  charts.ColorUtil.fromDartColor(Colors.red),
            ),
            charts.Series<OrdinalCases, String>(
              id: 'Recovered',
              domainFn: (OrdinalCases cases, _) => cases.country,
              measureFn: (OrdinalCases cases, _) => cases.total,
              data: recoveredCasesData,
              labelAccessorFn: (OrdinalCases cases, _) {
                return null;
              },
              colorFn: (datum, index) =>
                  charts.ColorUtil.fromDartColor(Colors.green),
            ),
            charts.Series<OrdinalCases, String>(
              id: 'Infected',
              domainFn: (OrdinalCases cases, _) => cases.country,
              measureFn: (OrdinalCases cases, _) => cases.total,
              data: confirmedCasesData,
              colorFn: (datum, index) =>
                  charts.ColorUtil.fromDartColor(Colors.blue),
              labelAccessorFn: (OrdinalCases cases, _) {
                return '${cases.totalCount.confirmedText}';
              },
            ),
          ];

          children.addAll([
            Padding(
              padding: EdgeInsets.only(top: 16),
            ),
            Text(
              "Stats Reports Countrywise: ",
              style: Theme.of(context).textTheme.headline,
            ),
            Container(
                height: height.toDouble(),
                child: charts.BarChart(
                  seriesList,
                  animate: true,
                  barGroupingType: charts.BarGroupingType.stacked,
                  vertical: false,
                  barRendererDecorator: charts.BarLabelDecorator<String>(),
                ))
          ]);

          return Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,
              ));
        }
      },
    );
  }
}

enum CaseType { confirmed, deaths, recovered, sick }

class LinearCases {
  final int type;
  final int count;
  final int total;
  final String text;

  LinearCases(this.type, this.count, this.total, this.text);
}

class OrdinalCases {
  final String country;
  final int total;
  final CoronaTotalCount totalCount;

  OrdinalCases(this.country, this.total, this.totalCount);
}
