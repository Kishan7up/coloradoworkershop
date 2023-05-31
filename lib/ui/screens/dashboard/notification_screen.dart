import 'dart:io';

import 'package:app/blocs/other/mainbloc/main_bloc.dart';
import 'package:app/models/api_request/notification/notification_activate_request.dart';
import 'package:app/models/api_request/notification/notification_list_request.dart';
import 'package:app/models/api_response/customer/customer_details_api_response.dart';
import 'package:app/models/api_response/notification/notification_list_response.dart';
import 'package:app/models/api_response/recent_view_list/recent_view_list_response.dart';
import 'package:app/models/common/all_name_id_list.dart';
import 'package:app/ui/res/color_resources.dart';
import 'package:app/ui/screens/base/base_screen.dart';
import 'package:app/utils/shared_pref_helper.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

//import 'package:whatsapp_share/whatsapp_share.dart';

class NotificationScreenArguments {
  String editModel;

  NotificationScreenArguments(this.editModel);
}

class NotificationScreen extends BaseStatefulWidget {
  static const routeName = '/NotificationScreen';

  final NotificationScreenArguments arguments;

  NotificationScreen(this.arguments);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends BaseState<NotificationScreen>
    with BasicScreen, WidgetsBindingObserver {
  MainBloc _CustomerBloc;
  int _pageNo = 0;
  Recent_view_list _inquiryListResponse;

  List<CustomerDetails> arrRecent_view_list = [];
  final TextEditingController edt_searchDetails = TextEditingController();
  final TextEditingController edt_FollowupEmployeeList =
      TextEditingController();

  //
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_EmplyeeList = [];

  List<CustomerDetails> _allUsers = [];
  bool expanded = true;

  double sizeboxsize = 12;
  double _fontSize_Label = 9;
  double _fontSize_Title = 11;
  int label_color = 0xff4F4F4F; //0x66666666;
  int title_color = 0xff362d8b;
  int _key;
  String foos = 'One';
  int selected = 0; //attention
  bool isExpand = false;

  bool IsAddRights = true;
  bool IsEditRights = true;
  bool IsDeleteRights = true;

  int CompanyID = 0;
  String LoginUserID = "";

  bool _hasCallSupport = false;
  Future<void> _launched;
  String _phone = '';

  //var _url = "https://api.whatsapp.com/send?phone=91";
  var _url = "https://wa.me/91";
  bool isDeleteVisible = true;

  List<ALL_Name_ID> listStatus = [];
  List<ALL_Name_ID> selectedlistStatus = [];

  String _editModel;

  final TextEditingController edt_date_of_inquiry = TextEditingController();

  final TextEditingController edt_Ave_Weekly_Wage = TextEditingController();
  final TextEditingController edt_FirstName = TextEditingController();
  final TextEditingController edt_LastName = TextEditingController();
  final TextEditingController edt_EmailAddress = TextEditingController();

  final TextEditingController edt_PhoneNumber = TextEditingController();
  final TextEditingController edt_Message = TextEditingController();
  final TextEditingController edt_Whole_Person_Impairment_Less =
      TextEditingController();
  final TextEditingController Whole_Person_Impairment_More_than =
      TextEditingController();
  final TextEditingController edt_left_lower_extremity_rating =
      TextEditingController();
  bool IS_TTD = false;

  bool value = true;
  bool state = false;

  List<NotificationListResponseBody> notificationList = [];

  @override
  void initState() {
    super.initState();

    _CustomerBloc = MainBloc(baseBloc);


    FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance; // Change here
    _firebaseMessaging.getToken().then((token){
      print("token is $token");
      _CustomerBloc.add(NotificationListRequestEvent(NotificationListRequest(
          notification: "1", device_token: token)));
    });


    if (widget.arguments != null) {
      _editModel = widget.arguments.editModel;

      state = SharedPrefHelper.instance.getBool("IsNotificationtoggle");//_editModel.toString() == "true" ? true : false;
    } else {
      String CurrentDate = DateTime.now().day.toString() +
          "/" +
          DateTime.now().month.toString() +
          "/" +
          DateTime.now().year.toString();

      edt_date_of_inquiry.text = CurrentDate;
    }
    //_CustomerBloc.add(RecentListCallEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _CustomerBloc,
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (BuildContext context, MainStates state) {
          if (state is NotificationListResponseState) {
            _onGetNotificationAPI(state);
          }
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is NotificationListResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, MainStates state) {
          if (state is NotificationActivateResponseState) {
            _ongetNotificationActivateAPIResponse(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is NotificationActivateResponseState) {
            return true;
          }
          return false;
        },
      ),
    );
  }

  @override
  Widget buildBody(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        backgroundColor: Color(0xffe1e1e1),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderPart(),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                          margin: EdgeInsets.all(10),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white70, width: 1),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Container(
                              //margin: EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 20,
                                        top: 10,
                                        bottom: 10,
                                        right: 10),
                                    child: Row(children: [
                                      Text("On/Off",
                                          style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                      Spacer(),
                                      CupertinoSwitch(
                                        value: state,
                                        onChanged: (value) {
                                          state = value;

                                          SharedPrefHelper.instance.putBool("IsNotificationtoggle",state);
                                          setState(
                                            () {},
                                          );

                                          FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance; // Change here
                                          _firebaseMessaging.getToken().then((token){
                                            print("token is $token");
                                            _CustomerBloc.add(
                                                NotificationActivateRequestEvent(
                                                    NotificationActivateRequest(
                                                        notification:
                                                        value == true
                                                            ? "1"
                                                            : "0",
                                                        device_token:
                                                        token,
                                                        device_type : Platform.isAndroid?"a":"i")));
                                          });

                                        },
                                        thumbColor: CupertinoColors.white,
                                        activeColor:
                                            CupertinoColors.systemYellow,
                                      ),
                                    ]),
                                  ),
                                  Container(
                                    margin:
                                        EdgeInsets.only(top: 10, bottom: 10),
                                    height: 3,
                                    color: colorLightGray,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 10,
                                        right: 10,
                                        top: 5,
                                        bottom: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ListView.builder(
                                            key: Key('selected $selected'),
                                            itemBuilder: (context, index) {
                                              //return _buildInquiryListItem(index);

                                              return Text(
                                                notificationList[index].description,
                                                //arrRecent_view_list[index].customerName,
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18),
                                              );
                                            },
                                            shrinkWrap: true,
                                            itemCount: notificationList
                                                .length // arrRecent_view_list.length,
                                            ),
                                        /*Container(
                                            margin: EdgeInsets.all(5),
                                            child: Text(
                                              notificationList[0].body,
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black),
                                            )),*/
                                        /* SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          height: 1,
                                          color: colorLightGray,
                                        ),
                                        Container(
                                            margin: EdgeInsets.all(5),
                                            child: Text(
                                              "New App Version 1.5 available, Update now!",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black),
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          height: 1,
                                          color: colorLightGray,
                                        ),
                                        Container(
                                            margin: EdgeInsets.all(5),
                                            child: Text(
                                              "Check your Net Present Value to have more benefits. ",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black),
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          height: 1,
                                          color: colorLightGray,
                                        ),
                                        Container(
                                            margin: EdgeInsets.all(5),
                                            child: Text(
                                              "Calculate Net Present Value to have more benefits. ",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black),
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          height: 1,
                                          color: colorLightGray,
                                        ),
                                        Container(
                                            margin: EdgeInsets.all(5),
                                            child: Text(
                                              "Now you can check Maximum Benefits Rates.",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black),
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),*/
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    Navigator.of(context).pop(state.toString());
    //navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

  HeaderPart() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
          /* border: Border.all(
            color: Colors.red[500],
          ),*/

          color: Color(0xff181142),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          )),
      child: Container(
        margin: EdgeInsets.only(top: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin: EdgeInsets.only(left: 10, right: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop(state.toString());

                        // navigateTo(context, HomeScreen.routeName);
                      },
                      child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            "Notification",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  _launchURL(String pdfURL) async {
    var url123 = pdfURL;
    if (await canLaunch(url123)) {
      await launch(url123);
    } else {
      throw 'Could not launch $url123';
    }
  }

  void _showDateOfInquiry(ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 190,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  Container(
                    height: 180,
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: DateTime.now(),
                        maximumYear: DateTime.now().year,
                        onDateTimeChanged: (val) {
                          setState(() {
                            edt_date_of_inquiry.text = val.day.toString() +
                                "/" +
                                val.month.toString() +
                                "/" +
                                val.year.toString();
                          });
                        }),
                  ),
                ],
              ),
            ));
  }

  void _onGetNotificationAPI(NotificationListResponseState state) {
    notificationList.clear();
    for(int i=0;i<state.notificationListResponse.data.details.body.length;i++)
      {
        notificationList.add(state.notificationListResponse.data.details.body[i]);

      }
  }

  void _ongetNotificationActivateAPIResponse(
      NotificationActivateResponseState state) {
    _showModalSheet(state.notificationActivateResponse.message);
  }

  void _showModalSheet(String apiMessage) {
    showModalBottomSheet<void>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter state) {
            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 5, bottom: 5),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 10),
                      child: Text(
                        "Successful!",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      height: 2,
                      color: Colors.grey,
                    ),
                    Container(
                      margin: EdgeInsets.all(20),
                      child: Text(apiMessage),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        //navigateTo(context, HomeScreen.routeName);
                      },
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: Card(
                            elevation: 10,
                            color: APPButtonRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              width: 100,
                              margin: EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 10),
                              child: Center(
                                child: Text("Ok",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
