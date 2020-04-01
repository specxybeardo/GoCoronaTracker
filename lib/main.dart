import 'package:flutter/material.dart';
import 'package:CoronaTracker/about.dart';
import 'package:CoronaTracker/advices.dart';
import 'package:CoronaTracker/google_map_base.dart';
import 'package:CoronaTracker/stats.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      title: 'Go Corona Tracker',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
           title: Center(
             
            child: Text('Go Corona Tracker'),
           ),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  text: "Tracker",
                ),
                Tab(
                  text: "Maps",
                ),
                Tab(
                  text: "Tips(WHO)",
                ),
                Tab(
                  text: "About",
                ),
              ],
            ),
          ),
          body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              StatsPage(),
              BaseGoogleMap().getWidget(),
              AdvicesPage(),
              AboutPage()
            ],
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
