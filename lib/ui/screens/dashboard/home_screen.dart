import 'dart:io';

import 'package:app/blocs/other/mainbloc/main_bloc.dart';
import 'package:app/models/DB_Models/recent_view_list_db_tabel.dart';
import 'package:app/models/api_request/view_recent_cases/view_recent_cases_request.dart';
import 'package:app/models/common/all_name_id_list.dart';
import 'package:app/ui/res/color_resources.dart';
import 'package:app/ui/res/image_resources.dart';
import 'package:app/ui/screens/base/base_screen.dart';
import 'package:app/ui/screens/dashboard/about_us.dart';
import 'package:app/ui/screens/dashboard/calculate_net_present_value.dart';
import 'package:app/ui/screens/dashboard/contact_us.dart';
import 'package:app/ui/screens/dashboard/maximum_benifits.dart';
import 'package:app/ui/screens/dashboard/new_ppd_award_screen.dart';
import 'package:app/ui/screens/dashboard/notification_screen.dart';
import 'package:app/ui/screens/dashboard/ppd_award_screen.dart';
import 'package:app/ui/screens/dashboard/recent_cases_details_screen.dart';
import 'package:app/ui/screens/dashboard/recent_cases_list_screen.dart';
import 'package:app/utils/general_utils.dart';
import 'package:app/utils/offline_db_helper.dart';
import 'package:app/utils/push_notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

///Added New Commit
///
///
/// ////
class HomeScreen extends BaseStatefulWidget {
  static const routeName = '/HomeScreen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseState<HomeScreen>
    with BasicScreen, WidgetsBindingObserver {
  List<ALL_Name_ID> arrRecentCase = [];
  MainBloc _CustomerBloc;
  List<RecentViewDBTable> arrRecent_view_list = [];

  FirebaseMessaging _messaging;

  String statevalue = "0";

  //final FirebaseMessaging _firebaseMessaging;//= FirebaseMessaging();
  PushNotificationService pushNotificationService = PushNotificationService();
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  @override
  void initState() {
    //  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    //  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();
    _CustomerBloc = MainBloc(baseBloc);
    _CustomerBloc.add(
        ViewRecentCasesRequestEvent(ViewRecentCasesRequest(filter: "all")));

    _CustomerBloc.add(SearchRecentViewRetriveEvent("", "ALL"));

    FirebaseMessaging.instance.getToken().then((value) {
      print("TokenFCM" + " Token No : " + value);
    });

    registerNotification();
    checkIntialMessage();
  }

  void registerNotification() async {
    /* await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );*/
    _messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: true,
      sound: true,
    );

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('A new onMessageOpenedApp event was published!' +
          message.notification.title);
      print("message Id - onMessageOpenedApp ${message.messageId}");
    });

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("User Grant the Permission");
    } else {
      print("Permission Decline By User");
    }
  }

  checkIntialMessage() async {
    RemoteMessage intialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

/*
    if (intialMessage != null) {
      print("message Id - intialMessage ${intialMessage.messageId}");
      if (Globals.objectedNotifications.contains(intialMessage.messageId)) {
        return;
      }
      Globals.objectedNotifications.add(intialMessage.messageId);
*/

    /* PushNotification notification = PushNotification(
        title: intialMessage.notification!.title,
        body: intialMessage.notification!.body,
        dataTitle: intialMessage.data['title'],
        databody: intialMessage.data['body']
    );*/
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _CustomerBloc
        ..add(
            ViewRecentCasesRequestEvent(ViewRecentCasesRequest(filter: "all"))),
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (BuildContext context, MainStates state) {
          if (state is ViewRecentCasesResponseState) {
            _OnViewRecentCasesResponse(state);
          }
          if (state is SearchRecentViewRetriveState) {
            _onsearchResult(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is ViewRecentCasesResponseState ||
              currentState is SearchRecentViewRetriveState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, MainStates state) {
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          return false;
        },
      ),
    );
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
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigateTo(context, ContactUsScreen.routeName);
          },
          backgroundColor: Color(0xFFF9E910),
          child: Image.asset(CALL_SMS),
        ),
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
                InkWell(
                  onTap: () {
                    navigateTo(context, NotificationScreen.routeName,
                            arguments: NotificationScreenArguments(statevalue))
                        .then((value) {
                      statevalue = value;
                      //_expenseBloc..add(ExpenseEventsListCallEvent(1,ExpenseListAPIRequest(CompanyId: CompanyID.toString(),LoginUserID: edt_FollowupEmployeeUserID.text,word: edt_FollowupStatus.text,needALL: "0")));
                    });

                    //navigateTo(context, NotificationScreen.routeName);
                  },
                  child: Container(
                      margin: EdgeInsets.only(right: 28),
                      child: Image.asset(NOTIFICATION_ICON)),
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
                    navigateTo(context, NewPpdAwardScreen.routeName);
                  },
                  child: Container(
                    height: 140,
                    width: 155,
                    // margin: EdgeInsets.only(left: 25),
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.3,
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
                        SizedBox(
                          height: 22,
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
                    //navigateTo(context, CalculateNetPresentValue.routeName);
                    navigateTo(context, MaximumBenefitsScreen.routeName);
                  },
                  child: Container(
                    height: 140,
                    width: 155,
                    margin: EdgeInsets.only(left: 25),
                    decoration: BoxDecoration(
                        border: Border.all(
                          width: 0.3,
                          color: Colors.white,
                        ),
                        color: colorPrimary,
                        borderRadius: BorderRadius.all(Radius.circular(6))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          MAXIMUM_BENEFIT_ICON,
                          height: 45,
                          width: 45,
                        ),
                        SizedBox(
                          height: 22,
                        ),
                        Text("Maximum\n Benefits",
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
            /*  SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: () {
                //  navigateTo(context, MaximumBenefitsScreen.routeName);
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
                navigateTo(context, AboutUsScreen.routeName);
              },
              child: Row(
                children: [
                  //ABOUT_US
                  Container(
                    margin: EdgeInsets.only(left: 55),
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
            )*/
            SizedBox(
              height: 25,
            ),
            InkWell(
              onTap: () {
                //navigateTo(context, CalculateNetPresentValue.routeName);
                navigateTo(context, AboutUsScreen.routeName);
              },
              child: Center(
                child: Container(
                  height: 140,
                  width: 155,
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 0.3,
                        color: Colors.white,
                      ),
                      color: colorPrimary,
                      borderRadius: BorderRadius.all(Radius.circular(6))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        ABOUT_US,
                        height: 45,
                        width: 45,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text("About Us",
                          style: TextStyle(
                              fontSize: 15,
                              letterSpacing: 1,
                              color: Colors.white)),
                    ],
                  ),
                ),
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
              height: 400,
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      navigateTo(context, RecentCasesDetailsScreen.routeName,
                              arguments: RecentCasesDetailsScreenArgument(
                                  "homescreen", arrRecent_view_list[index]))
                          .then((value) {
                        //_expenseBloc..add(ExpenseEventsListCallEvent(1,ExpenseListAPIRequest(CompanyId: CompanyID.toString(),LoginUserID: edt_FollowupEmployeeUserID.text,word: edt_FollowupStatus.text,needALL: "0")));
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          arrRecent_view_list[index].title,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Text(
                          arrRecent_view_list[index]
                                  .subTitle
                                  .toString()
                                  .replaceAll("\n", "") +
                              " [" +
                              arrRecent_view_list[index]
                                  .judgeName
                                  .toString()
                                  .replaceAll("\n", "") +
                              "]",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                        /* Text(

                          arrRecent_view_list[index].caseDetailShort,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),*/
                        Container(
                          height: 0.5,
                          margin:
                              EdgeInsets.only(top: 10, bottom: 10, right: 30),
                          color: Colors.grey,
                        )
                      ],
                    ),
                  );
                },
                shrinkWrap: true,
                itemCount: arrRecent_view_list.length,
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

  void _OnViewRecentCasesResponse(ViewRecentCasesResponseState state) async {
    // arrRecent_view_list.clear();
    print("KeyRecentResponse" +
        "API Response and Bind data details" +
        state.viewRecentCasesResponse.data.details[0].title);

    await OfflineDbHelper.getInstance().deleteALLRecentViewDBTable();
    for (int i = 0;
        i < state.viewRecentCasesResponse.data.details.length;
        i++) {
      await OfflineDbHelper.getInstance()
          .insertRecentViewDBTable(RecentViewDBTable(
        state.viewRecentCasesResponse.data.details[i].title,
        state.viewRecentCasesResponse.data.details[i].caseNo.toString(),
        state.viewRecentCasesResponse.data.details[i].caseDetailShort,
        state.viewRecentCasesResponse.data.details[i].caseDetailLong,
        state.viewRecentCasesResponse.data.details[i].filter,
        state.viewRecentCasesResponse.data.details[i].link,
        state.viewRecentCasesResponse.data.details[i].subTitle,
        state.viewRecentCasesResponse.data.details[i].category,
        state.viewRecentCasesResponse.data.details[i].judgeName,
      ));
    }

    _CustomerBloc.add(SearchRecentViewRetriveEvent("", "ALL"));

    /*_CustomerBloc.add(
        SearchRecentViewRetriveEvent("", edt_FollowupEmployeeList.text));*/
    /* for (int i = 0;
        i < state.viewRecentCasesResponse.data.details.length;
        i++) {
      print("KeyRecentResponse" +
          "API Response and Bind data details" +
          state.viewRecentCasesResponse.data.details[i].title);

      for (int i = 0;
          i < state.viewRecentCasesResponse.data.details.length;
          i++) {
        arrRecent_view_list.add(RecentViewDBTable(
          state.viewRecentCasesResponse.data.details[i].title,
          state.viewRecentCasesResponse.data.details[i].caseNo.toString(),
          state.viewRecentCasesResponse.data.details[i].caseDetailShort,
          state.viewRecentCasesResponse.data.details[i].caseDetailLong,
          state.viewRecentCasesResponse.data.details[i].filter,
          state.viewRecentCasesResponse.data.details[i].link,
        ));
      }*/

    /* await OfflineDbHelper.getInstance().deleteALLRecentViewDBTable();
      for (int i = 0;
          i < state.viewRecentCasesResponse.data.details.length;
          i++) {
        await OfflineDbHelper.getInstance()
            .insertRecentViewDBTable(RecentViewDBTable(
          state.viewRecentCasesResponse.data.details[i].title,
          state.viewRecentCasesResponse.data.details[i].caseNo,
          state.viewRecentCasesResponse.data.details[i].caseDetailShort,
          state.viewRecentCasesResponse.data.details[i].caseDetailLong,
          state.viewRecentCasesResponse.data.details[i].filter,
          state.viewRecentCasesResponse.data.details[i].link,
        ));

        _CustomerBloc.add(
            SearchRecentViewRetriveEvent("", edt_FollowupEmployeeList.text));*/
  }

  void _onsearchResult(SearchRecentViewRetriveState state) {
    arrRecent_view_list.clear();
    //_allUsers.clear();
    for (int i = 0; i < state.recentViewDBTable.length; i++) {
      /*RecentViewDBTable customerDetails = RecentViewDBTable();
      customerDetails.customerID =
          int.parse(state.recentViewDBTable[i].CustomerID);

      customerDetails.customerName = state.recentViewDBTable[i].CustomerName;*/

      arrRecent_view_list.add(state.recentViewDBTable[i]);
      //_allUsers.add(state.recentViewDBTable[i]);
    }
  }
}
