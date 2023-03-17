import 'dart:io';

import 'package:app/ui/res/color_resources.dart';
import 'package:app/ui/res/image_resources.dart';
import 'package:app/ui/screens/dashboard/recent_cases_list_screen.dart';
import 'package:app/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    //  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    //  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //428 * 926
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: colorPrimary,
          elevation: 0.0,
        ),
        backgroundColor: Colors.white,
        body: DashboardItems(),
      ),
    );
  }

  Widget DashboardItems() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  navigateTo(context, RecentCasesListScreen.routeName);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      RECENT_CASES,
                      height: 100,
                      width: 100,
                    ),
                    Text(
                      "Recent Cases",
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    PPD_AWARD,
                    height: 100,
                    width: 100,
                  ),
                  Text(
                    "Calc.PPD AWARD",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  )
                ],
              ),
            ],
          ),
          SizedBox(
            width: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    NET_PRESENT_VALUE,
                    height: 100,
                    width: 100,
                  ),
                  Text("Net Present Value",
                      style: TextStyle(fontSize: 12, color: Colors.black)),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                //MAX_BENEFIT
                children: [
                  Image.asset(
                    MAX_BENEFIT,
                    height: 100,
                    width: 100,
                  ),
                  Text("Max.Benefits",
                      style: TextStyle(fontSize: 12, color: Colors.black))
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<bool> _onBackPressed() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }
}
