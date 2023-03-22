import 'dart:io';

import 'package:app/models/common/all_name_id_list.dart';
import 'package:app/ui/res/color_resources.dart';
import 'package:app/ui/res/image_resources.dart';
import 'package:app/ui/screens/base/base_screen.dart';
import 'package:app/ui/screens/dashboard/recent_cases_list_screen.dart';
import 'package:app/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends BaseStatefulWidget {
  static const routeName = '/HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseState<HomeScreen>
    with BasicScreen, WidgetsBindingObserver {
  List<ALL_Name_ID> arrRecentCase = [];

  @override
  void initState() {
    //  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    //  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();

    getrecentCases();
  }

  @override
  Widget buildBody(BuildContext context) {
    //428 * 926
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [HeaderPart(), ListingPart()],
          ),
        ),
      ),
    );
  }

  /* Widget DashboardItems() {
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
  }*/

  Future<bool> _onBackPressed() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }

  HeaderPart() {
    return Container(
      height: 420,
      decoration: BoxDecoration(
          /* border: Border.all(
            color: Colors.red[500],
          ),*/
          color: colorPrimary,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          )),
      child: Container(
        margin: EdgeInsets.only(top: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 25),
                  child: Text(
                    "Good Morning",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(right: 28),
                  child: Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                )
              ],
            )),
            SizedBox(
              height: 27,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                    child: InkWell(
                  onTap: () {
                    showCommonDialogWithSingleOption(context, "Coming Soon !",
                        positiveButtonTitle: "OK");
                  },
                  child: Container(
                    height: 140,
                    width: 155,
                    // margin: EdgeInsets.only(left: 25),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                        ),
                        color: colorPrimary,
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          PPD_AWARD_ICON,
                          height: 40,
                          width: 40,
                        ),
                        Text("Calculate\nPPD Award",
                            style: TextStyle(
                                fontSize: 15,
                                letterSpacing: 1,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                )),
                Flexible(
                    child: InkWell(
                  onTap: () {
                    showCommonDialogWithSingleOption(context, "Coming Soon !",
                        positiveButtonTitle: "OK");
                  },
                  child: Container(
                    height: 140,
                    width: 155,
                    margin: EdgeInsets.only(left: 25),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                        ),
                        color: colorPrimary,
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          PRESENT_VALUE_ICON,
                          height: 40,
                          width: 40,
                        ),
                        Text("Calculate Net\nPresent value",
                            style: TextStyle(
                                fontSize: 15,
                                letterSpacing: 1,
                                color: Colors.white)),
                      ],
                    ),
                  ),
                )),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: () {
                showCommonDialogWithSingleOption(context, "Coming Soon !",
                    positiveButtonTitle: "OK");
              },
              child: Row(
                children: [
                  //MAXIMUM_BENEFIT_ICON
                  Container(
                    margin: EdgeInsets.only(left: 50),
                    child: Image.asset(
                      MAXIMUM_BENEFIT_ICON,
                      height: 30,
                      width: 47.13,
                    ),
                  ),

                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Maximum Benefits",
                    style: TextStyle(
                        fontSize: 15, letterSpacing: 1, color: Colors.white),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.only(left: 55, right: 55),
              child: Divider(
                height: 1,
                color: Colors.grey,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                showCommonDialogWithSingleOption(context, "Coming Soon !",
                    positiveButtonTitle: "OK");
              },
              child: Row(
                children: [
                  //ABOUT_US
                  Container(
                    margin: EdgeInsets.only(left: 50),
                    child: Image.asset(
                      ABOUT_US,
                      height: 35,
                      width: 35,
                    ),
                  ),
                  SizedBox(
                    width: 18,
                  ),
                  Text(
                    "About Us",
                    style: TextStyle(
                        fontSize: 15, letterSpacing: 1, color: Colors.white),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ListingPart() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 25),
                child: Text(
                  "Recent Cases",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  navigateTo(context, RecentCasesListScreen.routeName);
                },
                child: Container(
                  margin: EdgeInsets.only(right: 28),
                  child: Text(
                    "View All ->",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ),
              )
            ],
          ),
          Container(
              margin: EdgeInsets.only(left: 25, top: 30),
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        arrRecentCase[index].Name,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Text(
                        arrRecentCase[index].Name,
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      Container(
                        height: 1,
                        margin: EdgeInsets.only(top: 5, bottom: 5, right: 30),
                        color: Colors.grey,
                      )
                    ],
                  );
                },
                shrinkWrap: true,
                itemCount: arrRecentCase.length,
              ))
        ],
      ),
    );
  }

  void getrecentCases() {
    arrRecentCase.clear();

    for (int i = 0; i < 4; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();
      /* if (i == 0) {
        all_name_id.Name = "High";
      } else if (i == 1) {
        all_name_id.Name = "Medium";
      } else if (i == 2) {
        all_name_id.Name = "Low";
      }
      if (i == 3) {
        all_name_id.Name = "High";
      } else if (i == 4) {
        all_name_id.Name = "Medium";
      }*/
      all_name_id.Name = "Burren v Destination Maternity";
      all_name_id.Name1 = "W.C. 4-962-740(ICAO 2022-04-28)[ALJ Felter]";

      arrRecentCase.add(all_name_id);
    }
  }
}
