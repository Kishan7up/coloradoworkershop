import 'dart:ffi';

import 'package:age_calculator/age_calculator.dart';
import 'package:app/blocs/other/mainbloc/main_bloc.dart';
import 'package:app/models/api_request/max_benifit/max_benifit_request.dart';
import 'package:app/models/api_response/CombineValue/CombineValueResponse.dart';
import 'package:app/models/api_response/customer/customer_details_api_response.dart';
import 'package:app/models/api_response/recent_view_list/recent_view_list_response.dart';
import 'package:app/models/common/all_name_id_list.dart';
import 'package:app/ui/res/color_resources.dart';
import 'package:app/ui/res/image_resources.dart';
import 'package:app/ui/screens/base/base_screen.dart';
import 'package:app/ui/screens/dashboard/home_screen.dart';
import 'package:app/utils/general_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import "dart:math";
import "dart:core";

//import 'package:whatsapp_share/whatsapp_share.dart';

class NewPpdAwardScreenArguments {
  String editModel;

  NewPpdAwardScreenArguments(this.editModel);
}

class NewPpdAwardScreen extends BaseStatefulWidget {
  static const routeName = '/NewPpdAwardScreen';

  final NewPpdAwardScreenArguments arguments;

  NewPpdAwardScreen(this.arguments);

  @override
  _NewPpdAwardScreenState createState() => _NewPpdAwardScreenState();
}

class _NewPpdAwardScreenState extends BaseState<NewPpdAwardScreen>
    with BasicScreen, WidgetsBindingObserver {
  MainBloc _CustomerBloc;
  double row = 0.00, column = 0.00;
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
  bool isCombine = false;
  Future<void> _launched;
  String _phone = '';

  //var _url = "https://api.whatsapp.com/send?phone=91";
  var _url = "https://wa.me/91";
  bool isDeleteVisible = true;

  List<ALL_Name_ID> listStatus = [];
  List<ALL_Name_ID> selectedlistStatus = [];

  String _editModel;

  final TextEditingController edt_date_of_inquiry = TextEditingController();

  final TextEditingController edt_date_of_birth = TextEditingController();
  final TextEditingController edt_date_of_mmi = TextEditingController();
  final TextEditingController edt_avg_weekly_wage = TextEditingController();
  final TextEditingController edt_total_ttd_tpd = TextEditingController();

  final TextEditingController edt_whole_person_impliment_rating =
      TextEditingController();
  final TextEditingController edt_right_upper_extremity_rating =
      TextEditingController();
  final TextEditingController edt_left_upper_extremity_rating =
      TextEditingController();
  final TextEditingController edt_right_lower_extremity_rating =
      TextEditingController();
  final TextEditingController edt_left_lower_extremity_rating =
      TextEditingController();
  bool IS_TTD = false;

  final TextEditingController edt_Whole_Person_Rating = TextEditingController();

  final TextEditingController edt_Impairment_Rating_Right_Upper =
      TextEditingController();
  final TextEditingController edt_Value_of_the_Rating_Right_Upper =
      TextEditingController();

  final TextEditingController edt_Impairment_Rating_Left_Upper =
      TextEditingController();
  final TextEditingController edt_Value_of_the_Rating_Left_Upper =
      TextEditingController();

  final TextEditingController edt_Impairment_Rating_Right_Lower =
      TextEditingController();
  final TextEditingController edt_Value_of_the_Rating_Right_Lower =
      TextEditingController();

  final TextEditingController edt_Impairment_Rating_Left_Lower =
      TextEditingController();
  final TextEditingController edt_Value_of_the_Rating_Left_Lower =
      TextEditingController();

  //Impairment Rating

  final TextEditingController edt_Value_of_the_Rating = TextEditingController();

  final TextEditingController edt_Total_Scheduled_Rate =
      TextEditingController();
  final TextEditingController edt_Combined_Whole_Person_Rate =
      TextEditingController();
  final TextEditingController edt_Total_Award_Value_With_Current_Conversations =
      TextEditingController();
  final TextEditingController edt_Potential_Combined_Whole_Person_Rating =
      TextEditingController();
  final TextEditingController edt_Benefits_Cap = TextEditingController();

  final TextEditingController edt_Benefits_Cap1st = TextEditingController();
  final TextEditingController edt_Benefits_Cap2nd = TextEditingController();
  final TextEditingController edt_MAX_AWW = TextEditingController();
  final TextEditingController edt_COMP_RATE = TextEditingController();

  final TextEditingController Total_TTD_TPD_benefits_you_have_received =
      TextEditingController();
  final TextEditingController Amount_Remaining_to_Reach_Cap =
      TextEditingController();

  final TextEditingController edt_schedule_rate_fromAPI =
      TextEditingController();

  //Amount_Remaining_to_Reach_Cap

  bool IsRightUpperValue = false;
  bool IsRightUpperState = false;

  bool IsLeftUpperValue = false;
  bool IsLeftUpperState = false;

  bool IsRightLowerValue = false;
  bool IsRightLowerState = false;

  bool IsLeftLowerValue = false;
  bool IsLeftLowerState = false;

  double AgeFactor = 0.00;
  double AgeFactorForInjury = 0.00;
  bool isErrorforbenifitCap = false;

  double rightLowervalue = 0.00;
  double rightUppervalue = 0.00;
  double leftLowervalue = 0.00;
  double leftUppervalue = 0.00;

  bool ISErrorrightLowervalue = false;
  bool ISErrorrightUppervalue = false;
  bool ISErrorleftLowervalue = false;
  bool ISErrorleftUppervalue = false;

  double LessMore1 = 0.00;
  double LessMore2 = 0.00;
  double LessMore3 = 0.00;
  double LessMore4 = 0.00;

  double Totalrate = 0.00;

  double radio_one_red_before_per = 0.00;
  double radio_two_red_before_per = 0.00;
  double radio_three_red_before_per = 0.00;
  double radio_four_red_before_per = 0.00;

  double radio_one_red_after_per = 0.00;
  double radio_two_red_after_per = 0.00;
  double radio_three_red_after_per = 0.00;
  double radio_four_red_after_per = 0.00;

  double radio_one_red_per = 0.00;
  double radio_two_red_per = 0.00;
  double radio_three_red_per = 0.00;
  double radio_four_red_per = 0.00;

  double radio_one_red_value = 0.00;
  double radio_two_red_value = 0.00;
  double radio_three_red_value = 0.00;
  double radio_four_red_value = 0.00;

  int tot_rating_without_convert = 0;

  bool IS_Lost_Cap = false;

  @override
  void initState() {
    super.initState();

    _CustomerBloc = MainBloc(baseBloc);

    if (widget.arguments != null) {
      _editModel = widget.arguments.editModel;
    } else {
      String CurrentDate = DateTime.now().day.toString() +
          "-" +
          DateTime.now().month.toString() +
          "-" +
          DateTime.now().year.toString();

      var inputFormat = DateFormat('MM-dd-yyyy');
      var inputDate = inputFormat.parse(CurrentDate); // <-- dd/MM 24H format

      var outputFormat = DateFormat('MM-dd-yyyy');
      var outputDate = outputFormat.format(inputDate);
      //  edt_date_of_mmi.text = outputDate;

      edt_date_of_birth.text = "01-01-1990";
      edt_date_of_inquiry.text = outputDate;
      edt_date_of_mmi.text = outputDate;
    }

    //_CustomerBloc.add(RecentListCallEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _CustomerBloc,
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (BuildContext context, MainStates state) {
          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          return false;
        },
        listener: (BuildContext context, MainStates state) {
          if (state is MaxBenifitResponseState) {
            getScheduleRatefromAPI(state);
          }

          if (state is MaxBenifitDateofInjuryResponseState) {
            getDateofInjuryResult(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is MaxBenifitResponseState ||
              currentState is MaxBenifitDateofInjuryResponseState) {
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
                        BasicInformation(),
                        Impairments(),
                        Conversation(),
                        FinalSummary(),
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
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
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
                        navigateTo(context, HomeScreen.routeName);
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
                            "PPD Award",
                            style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _showModalSheet();
                      },
                      child: Container(
                          margin: EdgeInsets.only(left: 10),
                          child: Image.asset(INFO_ICON)),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }

  void _showModalSheet() {
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        margin: EdgeInsets.only(top: 20, bottom: 10),
                        child: Text(
                          "Info",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      height: 2,
                      color: Colors.grey,
                    ),
                    Container(
                        margin: EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        child: Text(
                          "This application is designed to provide accurate and authoritative information regarding the workers’ compensation law.  This information is given with the understanding that this application does not create an attorney client relationship.  Since the details of your situation are fact dependent; you should contact us to advise you how the law affects your particular circumstances.",
                          style: TextStyle(fontSize: 14, color: colorBlack),
                        )),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Center(
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
                                  child: Text("Close",
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                ),
                              )),
                        ),
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

  void _showDateOfInquiry(ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 250,
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
                            /* var monthwithzero  = val.month.bitLength>10?val.month.toString():"0"+val.month.toString();

                            edt_date_of_inquiry.text = val.day.toString() +
                                "-" +
                                monthwithzero +
                                "-" +
                                val.year.toString();*/

                            String from_calendor = val.day.toString() +
                                "-" +
                                val.month.toString() +
                                "-" +
                                val.year.toString();
                            var inputFormat = DateFormat('dd-MM-yyyy');
                            var inputDate = inputFormat
                                .parse(from_calendor); // <-- dd/MM 24H format

                            var outputFormat = DateFormat('MM-dd-yyyy');
                            var outputDate = outputFormat.format(inputDate);
                            edt_date_of_inquiry.text = outputDate;
                          });
                        }),
                  ),
                  Center(
                    child: ElevatedButton(
                        onPressed: () {
                          var inputFormat = DateFormat('MM-dd-yyyy');
                          var inputDate =
                              inputFormat.parse(edt_date_of_inquiry.text);

                          var outputFormat = DateFormat('dd-MM-yyyy');
                          var outputDate = outputFormat.format(inputDate);
                          edt_whole_person_impliment_rating.text = "";

                          FirebaseMessaging _firebaseMessaging =
                              FirebaseMessaging.instance; // Change here
                          _firebaseMessaging.getToken().then((token) {
                            print("token is $token");
                            _CustomerBloc.add(
                                MaxBenifitDateofInjoryRequestEvent(
                                    MaxBenifitRequest(
                                        notification: "1",
                                        device_token: token,
                                        date: outputDate.toString())));
                          });

                          calculateAgeOFInjury();
                          Navigator.pop(ctx);
                        },
                        child: Text("Select")),
                  ),
                ],
              ),
            ));
  }

  void _showDateOfBirth(ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 250,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  Container(
                    height: 180,
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: DateTime(1990, 01, 01),
                        maximumYear: DateTime.now().year,
                        onDateTimeChanged: (val) {
                          setState(() {
                            /*edt_date_of_birth.text = val.day.toString() +
                                "-" +
                                val.month.toString() +
                                "-" +
                                val.year.toString();*/

                            String from_calendor = val.day.toString() +
                                "-" +
                                val.month.toString() +
                                "-" +
                                val.year.toString();
                            var inputFormat = DateFormat('dd-MM-yyyy');
                            var inputDate = inputFormat
                                .parse(from_calendor); // <-- dd/MM 24H format

                            var outputFormat = DateFormat('MM-dd-yyyy');
                            var outputDate = outputFormat.format(inputDate);
                            edt_date_of_birth.text = outputDate;
                          });
                        }),
                  ),
                  Center(
                    child: ElevatedButton(
                        onPressed: () {
                          // calculateAgeMMI();
                          calculateAgeOFInjury();

                          Navigator.pop(ctx);
                        },
                        child: Text("Select")),
                  ),
                ],
              ),
            ));
  }

  void _showDateOfMMI(ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 250,
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
                            String from_calendor = val.day.toString() +
                                "-" +
                                val.month.toString() +
                                "-" +
                                val.year.toString();
                            var inputFormat = DateFormat('dd-MM-yyyy');
                            var inputDate = inputFormat
                                .parse(from_calendor); // <-- dd/MM 24H format

                            var outputFormat = DateFormat('MM-dd-yyyy');
                            var outputDate = outputFormat.format(inputDate);
                            edt_date_of_mmi.text = outputDate;
                          });
                        }),
                  ),
                  Center(
                    child: ElevatedButton(
                        onPressed: () {
                          var inputFormat = DateFormat('MM-dd-yyyy');
                          var inputDate = inputFormat.parse(
                              edt_date_of_inquiry.text); // <-- dd/MM 24H format

                          var outputFormat = DateFormat('dd-MM-yyyy');
                          var outputDate = outputFormat.format(inputDate);
                          FirebaseMessaging _firebaseMessaging =
                              FirebaseMessaging.instance;

                          // Change here
                          _firebaseMessaging.getToken().then((token) {
                            print("token is $token");
                            _CustomerBloc.add(
                                MaxBenifitDateofInjoryRequestEvent(
                                    MaxBenifitRequest(
                                        notification: "1",
                                        device_token: token,
                                        date: outputDate.toString())));
                          });
                          calculateAgeOFInjury();
                          // calculateAgeMMI();
                          Navigator.pop(ctx);
                        },
                        child: Text("Select")),
                  ),
                ],
              ),
            ));
  }

  calculateAge() {
    DateTime currentDate = DateFormat("MM-dd-yyyy").parse(edt_date_of_mmi.text);
    DateTime birthDate =
        new DateFormat("MM-dd-yyyy").parse(edt_date_of_birth.text);
    int age = currentDate.year - birthDate.year;
    int month1 = currentDate.month;
    int month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  age(DateTime today, DateTime dob) {
    final year = today.year - dob.year;
    final mth = today.month - dob.month;
    final days = today.day - dob.day;
    if (mth < 0) {
      /// negative month means it's still upcoming
      print('you buns is ${year - 1}');
      print('turning $year in ${mth.abs()} months and $days days');
    } else {
      print('your next bday is ${12 - mth}months and ${28 - days} days away');
    }
  }

  calculateAgeOFInjury() {
    // var a = DateTime.parse(edt_date_of_inquiry.text);
    //  var b = DateTime.parse(edt_date_of_birth.text);
    // DateDuration duration;
    // DateTime start = DateFormat("MM-dd-yyyy").parse(edt_date_of_inquiry.text);

    ///First A Veriable
    DateTime start = new DateFormat("dd-MM-yyyy").parse(edt_date_of_mmi.text);
    DateTime end = new DateFormat("dd-MM-yyyy").parse(edt_date_of_birth.text);
    print("Date of MMI " +
        edt_date_of_mmi.text +
        " DOB  " +
        edt_date_of_birth.text);
    final year1 = start.year - end.year;
    final mth = start.month - end.month;
    final days = start.day - end.day;
    int y;
    // if (mth < 0) {
    /// negative month means it's still upcoming
    print('you buns is ${year1 - 1}');
    y = year1 - 1;
    print('turning from MMI $year1 in ${mth.abs()} months and $days days');

    /// Second B Veriable
    DateTime start1 =
        new DateFormat("dd-MM-yyyy").parse(edt_date_of_inquiry.text);
    DateTime end1 = new DateFormat("dd-MM-yyyy").parse(edt_date_of_birth.text);
    print("Date of MMI " +
        edt_date_of_mmi.text +
        " DOB  " +
        edt_date_of_birth.text);
    final year11 = start1.year - end1.year;
    final mth1 = start1.month - end1.month;
    final days1 = start1.day - end1.day;
    int y11;
    // if (mth < 0) {
    /// negative month means it's still upcoming
    print('you buns is ${year11 - 1}');
    y11 = year11 - 1;
    print('turning $year11 in ${mth1.abs()} months and $days1 days');

    // } else {
    //   print('your next bday is ${12 - mth}months and ${28 - days} days away');
    // }
    // duration = AgeCalculator.dateDifference(
    //   fromDate: DateTime(start.year, start.month, start.day),
    //   toDate: DateTime(end.year, end.month, end.day),
    // );
    // print('The difference is $duration');
    // var years = start.difference(end);
    // var years = start.difference(end);
    // var startMonth = start.month;
    // var endMonth=end.month;
    // int y;
    // if(startMonth>endMonth) {
    //    y = (years.inDays - 365) ~/ 365;
    // }else{
    //    y = (years.inDays - 730) ~/ 365;
    // }
    // age(start, end);
    print(
      'sssssssss=== ',
    );
    // print("TotalYearMMI :- " + y.toString()+" "+years.inDays.toString());
    // print("TotalYearMMI :- " + calculateAge().toString());

    DateTime a = new DateFormat("dd-MM-yyyy")
        .parse(edt_date_of_birth.text); //edt_date_of_mmi.text);
    DateTime b = new DateFormat("dd-MM-yyyy").parse(edt_date_of_mmi.text);
    /* final differenceDays = date2.difference(date1).inDays;
    final differenceDays1 = (date2.difference(date1).inHours / 24).round();
    final differenceYears = (date2.difference(date1).inDays / 365).floor();*/

    //  print("YearsOfActualFlutter" + differenceYears.toString());

    /*  int totalDays = a.difference(b).inDays;
    int years7up = totalDays ~/ 365;
    int months7up = (totalDays - years7up * 365) ~/ 30;
    int days7up = totalDays - years7up * 365 - months7up * 30;
    print("YearsOfActualFlutter" + "$years7up $months7up $days7up $totalDays");

    y = years7up - 1;*/

    print("sdfdhfhfd45" + " Year  :" + calculateAge().toString());

    y = calculateAge();

    if (y < 21 || y11 < 21) {
      AgeFactorForInjury = 1.80;
    } else {
      if (y < 21) {
        AgeFactorForInjury = 1.80;
      } else if (y == 21) {
        AgeFactorForInjury = 1.78;
      } else if (y == 22) {
        AgeFactorForInjury = 1.76;
      } else if (y == 23) {
        AgeFactorForInjury = 1.74;
      } else if (y == 24) {
        AgeFactorForInjury = 1.72;
      } else if (y == 25) {
        AgeFactorForInjury = 1.70;
      } else if (y == 26) {
        AgeFactorForInjury = 1.68;
      } else if (y == 27) {
        AgeFactorForInjury = 1.66;
      } else if (y == 28) {
        AgeFactorForInjury = 1.64;
      } else if (y == 29) {
        AgeFactorForInjury = 1.62;
      } else if (y == 30) {
        AgeFactorForInjury = 1.60;
      } else if (y == 31) {
        AgeFactorForInjury = 1.58;
      } else if (y == 32) {
        AgeFactorForInjury = 1.56;
      } else if (y == 33) {
        AgeFactorForInjury = 1.54;
      } else if (y == 34) {
        AgeFactorForInjury = 1.52;
      } else if (y == 35) {
        AgeFactorForInjury = 1.50;
      } else if (y == 36) {
        AgeFactorForInjury = 1.48;
      } else if (y == 37) {
        AgeFactorForInjury = 1.46;
      } else if (y == 38) {
        AgeFactorForInjury = 1.44;
      } else if (y == 39) {
        AgeFactorForInjury = 1.42;
      } else if (y == 40) {
        AgeFactorForInjury = 1.40;
      } else if (y == 41) {
        AgeFactorForInjury = 1.38;
      } else if (y == 42) {
        AgeFactorForInjury = 1.36;
      } else if (y == 43) {
        AgeFactorForInjury = 1.34;
      } else if (y == 44) {
        AgeFactorForInjury = 1.32;
      } else if (y == 45) {
        AgeFactorForInjury = 1.30;
      } else if (y == 46) {
        AgeFactorForInjury = 1.28;
      } else if (y == 47) {
        AgeFactorForInjury = 1.26;
      } else if (y == 48) {
        AgeFactorForInjury = 1.24;
      } else if (y == 49) {
        AgeFactorForInjury = 1.22;
      } else if (y == 50) {
        AgeFactorForInjury = 1.20;
      } else if (y == 51) {
        AgeFactorForInjury = 1.18;
      } else if (y == 52) {
        AgeFactorForInjury = 1.16;
      } else if (y == 53) {
        AgeFactorForInjury = 1.14;
      } else if (y == 54) {
        AgeFactorForInjury = 1.12;
      } else if (y == 55) {
        AgeFactorForInjury = 1.10;
      } else if (y == 56) {
        AgeFactorForInjury = 1.08;
      } else if (y == 57) {
        AgeFactorForInjury = 1.06;
      } else if (y == 58) {
        AgeFactorForInjury = 1.04;
      } else if (y == 59) {
        AgeFactorForInjury = 1.02;
      } else if (y == 60) {
        AgeFactorForInjury = 1.00;
      } else if (y > 60) {
        AgeFactorForInjury = 1.00;
      }
    }
    print("AgeFactor:== " + AgeFactorForInjury.toString());

    print("AgeFactor From :== " + AgeFactorForInjury.toString());

    setState(() {});
  }

  void getScheduleRatefromAPI(MaxBenifitResponseState state) {
    edt_schedule_rate_fromAPI.text =
        state.maxBenifitResponse.data.details.scheduled.toString();

    print("sff4566dsf" + edt_schedule_rate_fromAPI.text.toString());
  }

  void rightupperExtremlyRatecalculation(String value) {
    //edt_whole_person_impliment_rating
    //edt_Whole_Person_Rating
    //edt_Value_of_the_Rating

    edt_Impairment_Rating_Right_Upper.text = value;

    double a = value.toString() == "" ? 0.00 : double.parse(value);
    double b = edt_schedule_rate_fromAPI.text.toString() == ""
        ? 0.00
        : double.parse(edt_schedule_rate_fromAPI.text);
    double result = 208 * b;

    double resulta = result * a;
    double resultb = resulta / 100;
    edt_Value_of_the_Rating_Right_Upper.text = resultb.toStringAsFixed(2);

    rightUppervalue = resultb;
    print("RightUpperExtremity== " + b.toString());
    updatetotalschedule();
    totalawarvaluewithconvertion(0.00);
    setState(() {});
  }

  void leftupperExtremlyRatecalculation(String value) {
    //edt_whole_person_impliment_rating
    //edt_Whole_Person_Rating
    //edt_Value_of_the_Rating

    edt_Impairment_Rating_Left_Upper.text = value;

    double a = value.toString() == "" ? 0.00 : double.parse(value);
    double b = edt_schedule_rate_fromAPI.text.toString() == ""
        ? 0.00
        : double.parse(edt_schedule_rate_fromAPI.text);
    double result = 208 * b;

    double resulta = result * a;
    double resultb = resulta / 100;
    edt_Value_of_the_Rating_Left_Upper.text = resultb.toStringAsFixed(2);

    leftUppervalue = resultb;

    updatetotalschedule();
    totalawarvaluewithconvertion(0.00);
    setState(() {});
  }

  void rightlowerExtremlyRatecalculation(String value) {
    //edt_whole_person_impliment_rating
    //edt_Whole_Person_Rating
    //edt_Value_of_the_Rating

    edt_Impairment_Rating_Right_Lower.text = value;

    double a = value.toString() == "" ? 0.00 : double.parse(value);
    double b = edt_schedule_rate_fromAPI.text.toString() == ""
        ? 0.00
        : double.parse(edt_schedule_rate_fromAPI.text);
    double result = 208 * b;

    double resulta = result * a;
    double resultb = resulta / 100;
    edt_Value_of_the_Rating_Right_Lower.text = resultb.toStringAsFixed(2);

    rightLowervalue = resultb;
    updatetotalschedule();
    totalawarvaluewithconvertion(0.00);
    setState(() {});
  }

  void leftlowerExtremlyRatecalculation(String value) {
    //edt_whole_person_impliment_rating
    //edt_Whole_Person_Rating
    //edt_Value_of_the_Rating

    edt_Impairment_Rating_Left_Lower.text = value;

    double a = value.toString() == "" ? 0.00 : double.parse(value);
    double b = edt_schedule_rate_fromAPI.text.toString() == ""
        ? 0.00
        : double.parse(edt_schedule_rate_fromAPI.text);
    double result = 208 * b;

    double resulta = result * a;
    double resultb = resulta / 100;
    edt_Value_of_the_Rating_Left_Lower.text = resultb.toStringAsFixed(2);

    leftLowervalue = resultb;
    updatetotalschedule();
    totalawarvaluewithconvertion(0.00);
    setState(() {});
  }

  BasicInformation() {
    return Container(
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
                margin: EdgeInsets.all(10),
                child: Text("Basic Information",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 10),
                height: 3,
                color: colorLightGray,
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: 10, bottom: 10, left: 10, right: 10),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                _showDateOfInquiry(context);
                              },
                              child: TextFormField(
                                  controller: edt_date_of_inquiry,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(top: 10.0),
                                    // border: UnderlineInputBorder(),
                                    labelText: 'Date of Injury',
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Image.asset(
                                        CALENDAR,
                                        width: 10,
                                        height: 10,
                                      ),
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF000000),
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                _showDateOfBirth(context);
                              },
                              child: TextFormField(
                                  controller: edt_date_of_birth,
                                  enabled: false,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          const EdgeInsets.only(top: 10.0),
                                      border: UnderlineInputBorder(),
                                      labelText: 'Date Of Birth',
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.all(1.0),
                                        child: Image.asset(
                                          CALENDAR,
                                          width: 10,
                                          height: 10,
                                        ),
                                      ),
                                      hintText: "DD-MM-YYYY"),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF000000),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 20, bottom: 10, left: 10, right: 10),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                _showDateOfMMI(context);
                              },
                              child: TextFormField(
                                  controller: edt_date_of_mmi,
                                  enabled: false,
                                  decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(top: 10.0),
                                    // border: UnderlineInputBorder(),
                                    labelText: 'Date of MMI',
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: Image.asset(
                                        CALENDAR,
                                        width: 10,
                                        height: 10,
                                      ),
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF000000),
                                  )),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                controller: edt_avg_weekly_wage,
                                onChanged: (value) {
                                  wholePersonimperimentsCalculation();
                                  setState(() {});
                                },
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(top: 10.0),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Text(
                                        "\$",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    border: UnderlineInputBorder(),
                                    labelText: 'Avg.Weekly Wage',
                                    hintText: "0.00"),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                )),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          /*onChanged: (value) {
                                        if (value.length >= 1) {
                                          setState(() {
                                            IS_TTD = true;
                                          });
                                        } else {
                                          setState(() {
                                            IS_TTD = false;
                                          });
                                        }
                                      },*/
                          controller: edt_total_ttd_tpd,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            wholePersonimperimentsCalculation();
                            setState(() {});
                          },
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top: 10.0),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 10.0),
                                child: Text(
                                  "\$",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              border: UnderlineInputBorder(),
                              labelText:
                                  'Total TTD/TPD benefits you have received',
                              hintText: "0.00"),
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF000000),
                          )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Impairments() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 5),
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.white70, width: 1),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 20,
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Text("Enter Impairments",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 10),
                height: 3,
                color: colorLightGray,
              ),
              SizedBox(
                width: 20,
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          /*onChanged: (value) {
                                        if (value.length >= 1) {
                                          setState(() {
                                            IS_TTD = true;
                                          });
                                        } else {
                                          setState(() {
                                            IS_TTD = false;
                                          });
                                        }
                                      },*/
                          onChanged: (value) {
                            wholePersonimperimentsCalculation();

                            /* int wholePerson = int.parse(value);
                            int rightUpper =
                                edt_right_upper_extremity_rating.text.isNotEmpty
                                    ? int.parse(
                                        edt_right_upper_extremity_rating.text)
                                    : 0;
                            int leftUpper =
                                edt_left_upper_extremity_rating.text.isNotEmpty
                                    ? int.parse(
                                        edt_left_upper_extremity_rating.text)
                                    : 0;
                            int rightLowwer =
                                edt_right_lower_extremity_rating.text.isNotEmpty
                                    ? int.parse(
                                        edt_right_lower_extremity_rating.text)
                                    : 0;
                            int leftLower =
                                edt_left_lower_extremity_rating.text.isNotEmpty
                                    ? int.parse(
                                        edt_left_lower_extremity_rating.text)
                                    : 0;

                            tot_rating_without_convert = rightUpper +
                                wholePerson +
                                leftUpper +
                                rightLowwer +
                                leftLower;
                            edt_Combined_Whole_Person_Rate.text =
                                tot_rating_without_convert.toString();
*/

                            getTotRatingValue();

                            setState(() {});
                          },
                          controller: edt_whole_person_impliment_rating,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top: 10.0),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 10.0),
                                child: Text(
                                  "\%",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              border: UnderlineInputBorder(),
                              labelText: 'Whole person impairment rating',
                              hintText: "0.00"),
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF000000),
                          )),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          /*onChanged: (value) {
                                        if (value.length >= 1) {
                                          setState(() {
                                            IS_TTD = true;
                                          });
                                        } else {
                                          setState(() {
                                            IS_TTD = false;
                                          });
                                        }
                                      },*/
                          controller: edt_right_upper_extremity_rating,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            rightupperExtremlyRatecalculation(value);

                            getTotRatingValue();
                          },
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top: 10.0),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 10.0),
                                child: Text(
                                  "\%",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              border: UnderlineInputBorder(),
                              labelText: 'Right upper extremity rating',
                              hintText: "0.00"),
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF000000),
                          )),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          /*onChanged: (value) {
                                        if (value.length >= 1) {
                                          setState(() {
                                            IS_TTD = true;
                                          });
                                        } else {
                                          setState(() {
                                            IS_TTD = false;
                                          });
                                        }
                                      },*/
                          controller: edt_left_upper_extremity_rating,
                          onChanged: (value) {
                            leftupperExtremlyRatecalculation(value);

                            getTotRatingValue();

                            setState(() {});
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top: 10.0),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 10.0),
                                child: Text(
                                  "\%",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              border: UnderlineInputBorder(),
                              labelText: 'Left upper extremity rating',
                              hintText: "0.00"),
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF000000),
                          )),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          /*onChanged: (value) {
                                        if (value.length >= 1) {
                                          setState(() {
                                            IS_TTD = true;
                                          });
                                        } else {
                                          setState(() {
                                            IS_TTD = false;
                                          });
                                        }
                                      },*/
                          controller: edt_right_lower_extremity_rating,
                          onChanged: (value) {
                            rightlowerExtremlyRatecalculation(value);

                            getTotRatingValue();

                            setState(() {});
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top: 10.0),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 10.0),
                                child: Text(
                                  "\%",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              border: UnderlineInputBorder(),
                              labelText: 'Right lower extremity rating',
                              hintText: "0.00"),
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF000000),
                          )),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: TextFormField(
                          keyboardType:
                              TextInputType.numberWithOptions(decimal: true),
                          controller: edt_left_lower_extremity_rating,
                          onChanged: (value) {
                            leftlowerExtremlyRatecalculation(value);

                            getTotRatingValue();

                            setState(() {});
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              contentPadding: const EdgeInsets.only(top: 10.0),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 10.0),
                                child: Text(
                                  "\%",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              border: UnderlineInputBorder(),
                              labelText: 'Left lower extremity rating',
                              hintText: "0.00"),
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF000000),
                          )),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    /* InkWell(
                      onTap: () {},
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
                              height: 25,
                              margin: EdgeInsets.only(
                                  left: 20, right: 20, top: 10, bottom: 10),
                              child: Center(
                                child: Text("Calculate",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),*/
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Conversation() {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Text(
              "Select  Conversation",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
        ),
        Container(
          child: Column(
            children: [
              SizedBox(
                width: 10,
              ),
              Whole_Person_UI(),
              Right_Upper_Extremity_UI(),
              Left_Upper_Extremity_UI(),
              Right_Lower_Extremity_UI(),
              Left_Lower_Extremity_UI(),
              SizedBox(
                width: 20,
              ),
            ],
          ),
        )
      ],
    );
  }

  FinalSummary() {
    return Container(
      child: Column(
        children: [
          SizedBox(
            width: 10,
          ),

          /// ENTER EMPREMENTS
          Container(
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 5),
            child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.white70, width: 1),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                enabled: false,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                /*onChanged: (value) {
                                        if (value.length >= 1) {
                                        setState(() {
                                        IS_TTD = true;
                                        });
                                        } else {
                                        setState(() {
                                        IS_TTD = false;
                                        });
                                        }
                                      },*/
                                controller: edt_Total_Scheduled_Rate,
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(top: 10.0),
                                    border: UnderlineInputBorder(),
                                    labelText: 'Total Scheduled Rate',
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Text(
                                        "\%",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    hintText: "0.00"),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                )),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                enabled: false,
                                controller: edt_Combined_Whole_Person_Rate,
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(top: 10.0),
                                    border: UnderlineInputBorder(),
                                    labelText: 'Combined Whole Person Rate',
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Text(
                                        "\%",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    hintText: "0.00"),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                )),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                /*onChanged: (value) {
                                        if (value.length >= 1) {
                                        setState(() {
                                        IS_TTD = true;
                                        });
                                        } else {
                                        setState(() {
                                        IS_TTD = false;
                                        });
                                        }
                                      },*/
                                enabled: false,
                                controller:
                                    edt_Total_Award_Value_With_Current_Conversations,
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(top: 10.0),
                                    border: UnderlineInputBorder(),
                                    labelText:
                                        'Total Award Value With Current Conversion',
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Text(
                                        "\$",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    hintText: "0.00"),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                )),
                          ),
                          IS_Lost_Cap == true
                              ? Text(
                                  "LOST DUE TO CAP",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.red),
                                )
                              : Container(),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: TextFormField(
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                /*onChanged: (value) {
                                        if (value.length >= 1) {
                                        setState(() {
                                        IS_TTD = true;
                                        });
                                        } else {
                                        setState(() {
                                        IS_TTD = false;
                                        });
                                        }
                                      },*/
                                controller:
                                    edt_Potential_Combined_Whole_Person_Rating,
                                enabled: false,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(top: 10.0),
                                    border: UnderlineInputBorder(),
                                    labelText:
                                        'Potential Combined Whole Person Rating',
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Text(
                                        "\%",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    hintText: "0.00"),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                )),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: TextFormField(
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                enabled: false,
                                controller: edt_Benefits_Cap,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(top: 10.0),
                                    border: UnderlineInputBorder(),
                                    labelText: 'Benefits Cap',
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Text(
                                        "\$",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    hintText: "0.00"),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                )),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                enabled: false,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                controller:
                                    Total_TTD_TPD_benefits_you_have_received,
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(top: 10.0),
                                  border: UnderlineInputBorder(),
                                  labelText:
                                      'Total TTD/TPD benefits you have received',
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, bottom: 10.0),
                                    child: Text(
                                      "\$",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                  hintText: "0.00",
                                ),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                )),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: TextFormField(
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                enabled: false,
                                controller: Amount_Remaining_to_Reach_Cap,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(top: 10.0),
                                    border: UnderlineInputBorder(),
                                    labelText: 'Amount Remaining to Reach Cap',
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Text(
                                        "\$",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    //   errorText:  isErrorforbenifitCap==true? "Benefit Cap exceeded so max benefit cap added" :null,

                                    hintText: "0.00"),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                )),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          Visibility(
            visible: false,
            child: InkWell(
              onTap: () {},
              child: Container(
                margin: EdgeInsets.all(5),
                child: Card(
                    elevation: 10,
                    color: APPButtonRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      width: 200,
                      height: 35,
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      child: Center(
                        child: Text("Calculate",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                    )),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    navigateTo(context, HomeScreen.routeName,
                        clearAllStack: true);
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Card(
                        elevation: 10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Container(
                          width: 100,
                          height: 35,
                          margin: EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          child: Center(
                            child: Text("Back",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ),
                        )),
                  ),
                ),
                InkWell(
                  onTap: () {
                    navigateTo(context, NewPpdAwardScreen.routeName,
                        clearAllStack: true);
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
                          height: 35,
                          margin: EdgeInsets.only(
                              left: 20, right: 20, top: 10, bottom: 10),
                          child: Center(
                            child: Text("Reset",
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
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  wholePersonimperimentsCalculation() {
    double TTDRate = 0.00;

    print("DateofInjuryAdge" + " AdgeFactor" + AgeFactorForInjury.toString());

    double a = edt_whole_person_impliment_rating.text.toString() == ""
        ? 0.00
        : double.parse(edt_whole_person_impliment_rating.text.toString());

    edt_Whole_Person_Rating.text = a.toStringAsFixed(2);
    if (a > 25) {
      edt_Benefits_Cap.text = edt_Benefits_Cap2nd.text;
    } else {
      edt_Benefits_Cap.text = edt_Benefits_Cap1st.text;
    }

    double avgweek = edt_avg_weekly_wage.text.toString() == ""
        ? 0.00
        : double.parse(edt_avg_weekly_wage.text);

    double max_aww = edt_MAX_AWW.text.toString() == ""
        ? 0.00
        : double.parse(edt_MAX_AWW.text);
    double compRate = edt_COMP_RATE.text.toString() == ""
        ? 0.00
        : double.parse(edt_COMP_RATE.text);

    print("skjdskdsdfdsfd" +
        " max_aww : " +
        max_aww.toString() +
        " compRate : " +
        compRate.toString());

    if (avgweek > max_aww) {
      TTDRate = compRate;
    } else {
      TTDRate = (avgweek * 2) / 3;
    }

    print("dskfdsfl" + TTDRate.toString());

    double resultb1 = TTDRate * 400 * AgeFactorForInjury;
    double resultb = (resultb1 * a) / 100;

    print("valuewhole" +
        " wholeImpRate : " +
        a.toString() +
        " TTDRate " +
        TTDRate.toString() +
        " AdgefactorInjury " +
        AgeFactorForInjury.toString() +
        "");

    print("Totaldf" + " wholeImpRate : " + resultb.toString());

    edt_Value_of_the_Rating.text = resultb.toStringAsFixed(2);

    double ttd_tpd = edt_total_ttd_tpd.text.toString() == ""
        ? 0.00
        : double.parse(edt_total_ttd_tpd.text.toString());
    double banifitcap = edt_Benefits_Cap.text.toString() == ""
        ? 0.00
        : double.parse(edt_Benefits_Cap.text.toString());

    double tot_ttd_tpd_rec = ttd_tpd + resultb;

    if (tot_ttd_tpd_rec > banifitcap) {
      // Total_TTD_TPD_benefits_you_have_received.text = banifitcap.toStringAsFixed(2);

      isErrorforbenifitCap = true;
    } else {
      // Total_TTD_TPD_benefits_you_have_received.text =tot_ttd_tpd_rec.toStringAsFixed(2);
      isErrorforbenifitCap = false;
    }

    double temp = Total_TTD_TPD_benefits_you_have_received.text.toString() == ""
        ? 0.00
        : double.parse(
            Total_TTD_TPD_benefits_you_have_received.text.toString());

    Total_TTD_TPD_benefits_you_have_received.text = ttd_tpd.toStringAsFixed(2);

    double newcal = banifitcap - resultb - ttd_tpd;

    Amount_Remaining_to_Reach_Cap.text = newcal.toStringAsFixed(2);
    updatetotalschedule();
    setState(() {});
  }

  void getDateofInjuryResult(MaxBenifitDateofInjuryResponseState state) {
    edt_Benefits_Cap1st.text =
        state.maxBenifitResponse.data.details.s1cap.toString();
    edt_Benefits_Cap2nd.text =
        state.maxBenifitResponse.data.details.s2cap.toString();

    edt_MAX_AWW.text = state.maxBenifitResponse.data.details.aww.toString();

    edt_COMP_RATE.text = state.maxBenifitResponse.data.details.comp.toString();
    edt_schedule_rate_fromAPI.text =
        state.maxBenifitResponse.data.details.scheduled.toString();

    print("sff4566dsf" + edt_schedule_rate_fromAPI.text.toString());
    calculateAgeOFInjury();
  }

  void RightLowerExtremlyCovertFormula(bool value) {
    print("sd00dff" + value.toString());
    double TTDRate = 0.00;
    if (edt_right_lower_extremity_rating.text.isNotEmpty) {
      if (value == true) {
        // double a = edt_Impairment_Rating_Right_Lower.text.toString() == "" ? 0.00 : double.parse(edt_Impairment_Rating_Right_Lower.text.toString());

        double test = edt_right_lower_extremity_rating.text.toString() == ""
            ? 0.00
            : double.parse(edt_right_lower_extremity_rating.text.toString());
        radio_three_red_before_per = test;
        int test1 = test.toInt();
        if (test1 == 0) {
          edt_Impairment_Rating_Right_Lower.text = "0";
        }
        if (test1 == 1) {
          edt_Impairment_Rating_Right_Lower.text = "0";
        }
        if (test1 == 2) {
          edt_Impairment_Rating_Right_Lower.text = "1";
        }
        if (test1 == 3) {
          edt_Impairment_Rating_Right_Lower.text = "1";
        }
        if (test1 == 4) {
          edt_Impairment_Rating_Right_Lower.text = "2";
        }
        if (test1 == 5) {
          edt_Impairment_Rating_Right_Lower.text = "2";
        }
        if (test1 == 6) {
          edt_Impairment_Rating_Right_Lower.text = "2";
        }
        if (test1 == 7) {
          edt_Impairment_Rating_Right_Lower.text = "3";
        }
        if (test1 == 8) {
          edt_Impairment_Rating_Right_Lower.text = "3";
        }
        if (test1 == 9) {
          edt_Impairment_Rating_Right_Lower.text = "4";
        }
        if (test1 == 10) {
          edt_Impairment_Rating_Right_Lower.text = "4";
        }
        if (test1 == 11) {
          edt_Impairment_Rating_Right_Lower.text = "4";
        }
        if (test1 == 12) {
          edt_Impairment_Rating_Right_Lower.text = "5";
        }
        if (test1 == 13) {
          edt_Impairment_Rating_Right_Lower.text = "5";
        }
        if (test1 == 14) {
          edt_Impairment_Rating_Right_Lower.text = "6";
        }
        if (test1 == 15) {
          edt_Impairment_Rating_Right_Lower.text = "6";
        }
        if (test1 == 16) {
          edt_Impairment_Rating_Right_Lower.text = "6";
        }
        if (test1 == 17) {
          edt_Impairment_Rating_Right_Lower.text = "7";
        }
        if (test1 == 18) {
          edt_Impairment_Rating_Right_Lower.text = "7";
        }
        if (test1 == 19) {
          edt_Impairment_Rating_Right_Lower.text = "8";
        }
        if (test1 == 20) {
          edt_Impairment_Rating_Right_Lower.text = "8";
        }
        if (test1 == 21) {
          edt_Impairment_Rating_Right_Lower.text = "8";
        }
        if (test1 == 22) {
          edt_Impairment_Rating_Right_Lower.text = "9";
        }
        if (test1 == 23) {
          edt_Impairment_Rating_Right_Lower.text = "9";
        }
        if (test1 == 24) {
          edt_Impairment_Rating_Right_Lower.text = "10";
        }
        if (test1 == 25) {
          edt_Impairment_Rating_Right_Lower.text = "10";
        }
        if (test1 == 26) {
          edt_Impairment_Rating_Right_Lower.text = "10";
        }
        if (test1 == 27) {
          edt_Impairment_Rating_Right_Lower.text = "11";
        }
        if (test1 == 28) {
          edt_Impairment_Rating_Right_Lower.text = "11";
        }
        if (test1 == 29) {
          edt_Impairment_Rating_Right_Lower.text = "12";
        }
        if (test1 == 30) {
          edt_Impairment_Rating_Right_Lower.text = "12";
        }
        if (test1 == 31) {
          edt_Impairment_Rating_Right_Lower.text = "12";
        }
        if (test1 == 32) {
          edt_Impairment_Rating_Right_Lower.text = "13";
        }
        if (test1 == 33) {
          edt_Impairment_Rating_Right_Lower.text = "13";
        }
        if (test1 == 34) {
          edt_Impairment_Rating_Right_Lower.text = "14";
        }
        if (test1 == 35) {
          edt_Impairment_Rating_Right_Lower.text = "14";
        }
        if (test1 == 36) {
          edt_Impairment_Rating_Right_Lower.text = "14";
        }
        if (test1 == 37) {
          edt_Impairment_Rating_Right_Lower.text = "15";
        }
        if (test1 == 38) {
          edt_Impairment_Rating_Right_Lower.text = "15";
        }
        if (test1 == 39) {
          edt_Impairment_Rating_Right_Lower.text = "16";
        }
        if (test1 == 40) {
          edt_Impairment_Rating_Right_Lower.text = "16";
        }
        if (test1 == 41) {
          edt_Impairment_Rating_Right_Lower.text = "16";
        }
        if (test1 == 42) {
          edt_Impairment_Rating_Right_Lower.text = "17";
        }
        if (test1 == 43) {
          edt_Impairment_Rating_Right_Lower.text = "17";
        }
        if (test1 == 44) {
          edt_Impairment_Rating_Right_Lower.text = "18";
        }
        if (test1 == 45) {
          edt_Impairment_Rating_Right_Lower.text = "18";
        }
        if (test1 == 46) {
          edt_Impairment_Rating_Right_Lower.text = "18";
        }
        if (test1 == 47) {
          edt_Impairment_Rating_Right_Lower.text = "19";
        }
        if (test1 == 48) {
          edt_Impairment_Rating_Right_Lower.text = "19";
        }
        if (test1 == 49) {
          edt_Impairment_Rating_Right_Lower.text = "20";
        }
        if (test1 == 50) {
          edt_Impairment_Rating_Right_Lower.text = "20";
        }
        if (test1 == 51) {
          edt_Impairment_Rating_Right_Lower.text = "20";
        }
        if (test1 == 52) {
          edt_Impairment_Rating_Right_Lower.text = "21";
        }
        if (test1 == 53) {
          edt_Impairment_Rating_Right_Lower.text = "21";
        }
        if (test1 == 54) {
          edt_Impairment_Rating_Right_Lower.text = "22";
        }
        if (test1 == 55) {
          edt_Impairment_Rating_Right_Lower.text = "22";
        }
        if (test1 == 56) {
          edt_Impairment_Rating_Right_Lower.text = "22";
        }
        if (test1 == 57) {
          edt_Impairment_Rating_Right_Lower.text = "23";
        }
        if (test1 == 58) {
          edt_Impairment_Rating_Right_Lower.text = "23";
        }
        if (test1 == 59) {
          edt_Impairment_Rating_Right_Lower.text = "24";
        }
        if (test1 == 60) {
          edt_Impairment_Rating_Right_Lower.text = "24";
        }
        if (test1 == 61) {
          edt_Impairment_Rating_Right_Lower.text = "24";
        }
        if (test1 == 62) {
          edt_Impairment_Rating_Right_Lower.text = "25";
        }
        if (test1 == 63) {
          edt_Impairment_Rating_Right_Lower.text = "25";
        }
        if (test1 == 64) {
          edt_Impairment_Rating_Right_Lower.text = "26";
        }
        if (test1 == 65) {
          edt_Impairment_Rating_Right_Lower.text = "26";
        }
        if (test1 == 66) {
          edt_Impairment_Rating_Right_Lower.text = "28";
        }
        if (test1 == 67) {
          edt_Impairment_Rating_Right_Lower.text = "27";
        }
        if (test1 == 68) {
          edt_Impairment_Rating_Right_Lower.text = "27";
        }
        if (test1 == 69) {
          edt_Impairment_Rating_Right_Lower.text = "28";
        }
        if (test1 == 70) {
          edt_Impairment_Rating_Right_Lower.text = "28";
        }
        if (test1 == 71) {
          edt_Impairment_Rating_Right_Lower.text = "28";
        }
        if (test1 == 72) {
          edt_Impairment_Rating_Right_Lower.text = "29";
        }
        if (test1 == 73) {
          edt_Impairment_Rating_Right_Lower.text = "29";
        }
        if (test1 == 74) {
          edt_Impairment_Rating_Right_Lower.text = "30";
        }
        if (test1 == 75) {
          edt_Impairment_Rating_Right_Lower.text = "30";
        }
        if (test1 == 76) {
          edt_Impairment_Rating_Right_Lower.text = "30";
        }
        if (test1 == 77) {
          edt_Impairment_Rating_Right_Lower.text = "31";
        }
        if (test1 == 78) {
          edt_Impairment_Rating_Right_Lower.text = "31";
        }
        if (test1 == 79) {
          edt_Impairment_Rating_Right_Lower.text = "32";
        }
        if (test1 == 80) {
          edt_Impairment_Rating_Right_Lower.text = "32";
        }
        if (test1 == 81) {
          edt_Impairment_Rating_Right_Lower.text = "32";
        }
        if (test1 == 82) {
          edt_Impairment_Rating_Right_Lower.text = "33";
        }
        if (test1 == 83) {
          edt_Impairment_Rating_Right_Lower.text = "33";
        }
        if (test1 == 84) {
          edt_Impairment_Rating_Right_Lower.text = "34";
        }
        if (test1 == 85) {
          edt_Impairment_Rating_Right_Lower.text = "34";
        }
        if (test1 == 86) {
          edt_Impairment_Rating_Right_Lower.text = "34";
        }
        if (test1 == 87) {
          edt_Impairment_Rating_Right_Lower.text = "35";
        }
        if (test1 == 88) {
          edt_Impairment_Rating_Right_Lower.text = "35";
        }
        if (test1 == 89) {
          edt_Impairment_Rating_Right_Lower.text = "36";
        }
        if (test1 == 90) {
          edt_Impairment_Rating_Right_Lower.text = "36";
        }
        if (test1 == 91) {
          edt_Impairment_Rating_Right_Lower.text = "36";
        }
        if (test1 == 92) {
          edt_Impairment_Rating_Right_Lower.text = "37";
        }
        if (test1 == 93) {
          edt_Impairment_Rating_Right_Lower.text = "37";
        }
        if (test1 == 94) {
          edt_Impairment_Rating_Right_Lower.text = "38";
        }
        if (test1 == 95) {
          edt_Impairment_Rating_Right_Lower.text = "38";
        }
        if (test1 == 96) {
          edt_Impairment_Rating_Right_Lower.text = "38";
        }
        if (test1 == 97) {
          edt_Impairment_Rating_Right_Lower.text = "39";
        }
        if (test1 == 98) {
          edt_Impairment_Rating_Right_Lower.text = "39";
        }
        if (test1 == 99) {
          edt_Impairment_Rating_Right_Lower.text = "40";
        }
        if (test1 == 100) {
          edt_Impairment_Rating_Right_Lower.text = "40";
        }

        double a = edt_Impairment_Rating_Right_Lower.text.toString() == ""
            ? 0.00
            : double.parse(edt_Impairment_Rating_Right_Lower.text.toString());
        radio_three_red_per = a;
        double avgweek = edt_avg_weekly_wage.text.toString() == ""
            ? 0.00
            : double.parse(edt_avg_weekly_wage.text);
        double max_aww = edt_MAX_AWW.text.toString() == ""
            ? 0.00
            : double.parse(edt_MAX_AWW.text);
        double compRate = edt_COMP_RATE.text.toString() == ""
            ? 0.00
            : double.parse(edt_COMP_RATE.text);
        if (AgeFactorForInjury == 1.80) {
          TTDRate = (max_aww * 2) / 3;
        } else {
          if (avgweek > max_aww) {
            TTDRate = compRate;
          } else {
            TTDRate = (avgweek * 2) / 3;
          }
        }
        double resultb1 = TTDRate * 400 * AgeFactorForInjury;
        double resultb = (resultb1 * a) / 100;
        edt_Value_of_the_Rating_Right_Lower.text = resultb.toStringAsFixed(2);

        radio_three_red_value = resultb;
        LessMore1 = 0.00;
        LessMore1 = rightLowervalue - resultb;

        ISErrorrightLowervalue = true;
        updatetotalschedule();
        totalawarvaluewithconvertion(TTDRate);
        TotalScheduleRateee();

        /* double rightLowervalue = 0.00;
  double rightUppervalue = 0.00;
  double leftLowervalue = 0.00;
  double leftUppervalue = 0.00;*/
        // rightlowerExtremlyRatecalculation(edt_Impairment_Rating_Right_Lower.text);
      } else {
        print("dfdfeer" + edt_right_lower_extremity_rating.text.toString());

        radio_three_red_per = 0.00;
        radio_three_red_value = 0.00;
        radio_three_red_before_per = 0.00;

        radio_three_red_after_per = edt_right_lower_extremity_rating.text
                    .toString() ==
                ""
            ? 0.00
            : double.parse(edt_right_lower_extremity_rating.text.toString());

        rightlowerExtremlyRatecalculation(
            edt_right_lower_extremity_rating.text);
        ISErrorrightLowervalue = false;
        totalawarvaluewithconvertion(TTDRate);
      }

      updatetotalschedule();
      // totalawarvaluewithconvertion(TTDRate);
      TotalScheduleRateee();
    }
  }

  void LefttLowerExtremlyCovertFormula(bool value) {
    print("sd00dff" + value.toString());
    double TTDRate = 0.00;
    if (edt_left_lower_extremity_rating.text.isNotEmpty) {
      if (value == true) {
        // double a = edt_Impairment_Rating_Right_Lower.text.toString() == "" ? 0.00 : double.parse(edt_Impairment_Rating_Right_Lower.text.toString());

        double test = edt_left_lower_extremity_rating.text.toString() == ""
            ? 0.00
            : double.parse(edt_left_lower_extremity_rating.text.toString());
        radio_four_red_before_per = test;
        int test1 = test.toInt();
        if (test1 == 0) {
          edt_Impairment_Rating_Left_Lower.text = "0";
        }
        if (test1 == 1) {
          edt_Impairment_Rating_Left_Lower.text = "0";
        }
        if (test1 == 2) {
          edt_Impairment_Rating_Left_Lower.text = "1";
        }
        if (test1 == 3) {
          edt_Impairment_Rating_Left_Lower.text = "1";
        }
        if (test1 == 4) {
          edt_Impairment_Rating_Left_Lower.text = "2";
        }
        if (test1 == 5) {
          edt_Impairment_Rating_Left_Lower.text = "2";
        }
        if (test1 == 6) {
          edt_Impairment_Rating_Left_Lower.text = "2";
        }
        if (test1 == 7) {
          edt_Impairment_Rating_Left_Lower.text = "3";
        }
        if (test1 == 8) {
          edt_Impairment_Rating_Left_Lower.text = "3";
        }
        if (test1 == 9) {
          edt_Impairment_Rating_Left_Lower.text = "4";
        }
        if (test1 == 10) {
          edt_Impairment_Rating_Left_Lower.text = "4";
        }
        if (test1 == 11) {
          edt_Impairment_Rating_Left_Lower.text = "4";
        }
        if (test1 == 12) {
          edt_Impairment_Rating_Left_Lower.text = "5";
        }
        if (test1 == 13) {
          edt_Impairment_Rating_Left_Lower.text = "5";
        }
        if (test1 == 14) {
          edt_Impairment_Rating_Left_Lower.text = "6";
        }
        if (test1 == 15) {
          edt_Impairment_Rating_Left_Lower.text = "6";
        }
        if (test1 == 16) {
          edt_Impairment_Rating_Left_Lower.text = "6";
        }
        if (test1 == 17) {
          edt_Impairment_Rating_Left_Lower.text = "7";
        }
        if (test1 == 18) {
          edt_Impairment_Rating_Left_Lower.text = "7";
        }
        if (test1 == 19) {
          edt_Impairment_Rating_Left_Lower.text = "8";
        }
        if (test1 == 20) {
          edt_Impairment_Rating_Left_Lower.text = "8";
        }
        if (test1 == 21) {
          edt_Impairment_Rating_Left_Lower.text = "8";
        }
        if (test1 == 22) {
          edt_Impairment_Rating_Left_Lower.text = "9";
        }
        if (test1 == 23) {
          edt_Impairment_Rating_Left_Lower.text = "9";
        }
        if (test1 == 24) {
          edt_Impairment_Rating_Left_Lower.text = "10";
        }
        if (test1 == 25) {
          edt_Impairment_Rating_Left_Lower.text = "10";
        }
        if (test1 == 26) {
          edt_Impairment_Rating_Left_Lower.text = "10";
        }
        if (test1 == 27) {
          edt_Impairment_Rating_Left_Lower.text = "11";
        }
        if (test1 == 28) {
          edt_Impairment_Rating_Left_Lower.text = "11";
        }
        if (test1 == 29) {
          edt_Impairment_Rating_Left_Lower.text = "12";
        }
        if (test1 == 30) {
          edt_Impairment_Rating_Left_Lower.text = "12";
        }
        if (test1 == 31) {
          edt_Impairment_Rating_Left_Lower.text = "12";
        }
        if (test1 == 32) {
          edt_Impairment_Rating_Left_Lower.text = "13";
        }
        if (test1 == 33) {
          edt_Impairment_Rating_Left_Lower.text = "13";
        }
        if (test1 == 34) {
          edt_Impairment_Rating_Left_Lower.text = "14";
        }
        if (test1 == 35) {
          edt_Impairment_Rating_Left_Lower.text = "14";
        }
        if (test1 == 36) {
          edt_Impairment_Rating_Left_Lower.text = "14";
        }
        if (test1 == 37) {
          edt_Impairment_Rating_Left_Lower.text = "15";
        }
        if (test1 == 38) {
          edt_Impairment_Rating_Left_Lower.text = "15";
        }
        if (test1 == 39) {
          edt_Impairment_Rating_Left_Lower.text = "16";
        }
        if (test1 == 40) {
          edt_Impairment_Rating_Left_Lower.text = "16";
        }
        if (test1 == 41) {
          edt_Impairment_Rating_Left_Lower.text = "16";
        }
        if (test1 == 42) {
          edt_Impairment_Rating_Left_Lower.text = "17";
        }
        if (test1 == 43) {
          edt_Impairment_Rating_Left_Lower.text = "17";
        }
        if (test1 == 44) {
          edt_Impairment_Rating_Left_Lower.text = "18";
        }
        if (test1 == 45) {
          edt_Impairment_Rating_Left_Lower.text = "18";
        }
        if (test1 == 46) {
          edt_Impairment_Rating_Left_Lower.text = "18";
        }
        if (test1 == 47) {
          edt_Impairment_Rating_Left_Lower.text = "19";
        }
        if (test1 == 48) {
          edt_Impairment_Rating_Left_Lower.text = "19";
        }
        if (test1 == 49) {
          edt_Impairment_Rating_Left_Lower.text = "20";
        }
        if (test1 == 50) {
          edt_Impairment_Rating_Left_Lower.text = "20";
        }
        if (test1 == 51) {
          edt_Impairment_Rating_Left_Lower.text = "20";
        }
        if (test1 == 52) {
          edt_Impairment_Rating_Left_Lower.text = "21";
        }
        if (test1 == 53) {
          edt_Impairment_Rating_Left_Lower.text = "21";
        }
        if (test1 == 54) {
          edt_Impairment_Rating_Left_Lower.text = "22";
        }
        if (test1 == 55) {
          edt_Impairment_Rating_Left_Lower.text = "22";
        }
        if (test1 == 56) {
          edt_Impairment_Rating_Left_Lower.text = "22";
        }
        if (test1 == 57) {
          edt_Impairment_Rating_Left_Lower.text = "23";
        }
        if (test1 == 58) {
          edt_Impairment_Rating_Left_Lower.text = "23";
        }
        if (test1 == 59) {
          edt_Impairment_Rating_Left_Lower.text = "24";
        }
        if (test1 == 60) {
          edt_Impairment_Rating_Left_Lower.text = "24";
        }
        if (test1 == 61) {
          edt_Impairment_Rating_Left_Lower.text = "24";
        }
        if (test1 == 62) {
          edt_Impairment_Rating_Left_Lower.text = "25";
        }
        if (test1 == 63) {
          edt_Impairment_Rating_Left_Lower.text = "25";
        }
        if (test1 == 64) {
          edt_Impairment_Rating_Left_Lower.text = "26";
        }
        if (test1 == 65) {
          edt_Impairment_Rating_Left_Lower.text = "26";
        }
        if (test1 == 66) {
          edt_Impairment_Rating_Left_Lower.text = "28";
        }
        if (test1 == 67) {
          edt_Impairment_Rating_Left_Lower.text = "27";
        }
        if (test1 == 68) {
          edt_Impairment_Rating_Left_Lower.text = "27";
        }
        if (test1 == 69) {
          edt_Impairment_Rating_Left_Lower.text = "28";
        }
        if (test1 == 70) {
          edt_Impairment_Rating_Left_Lower.text = "28";
        }
        if (test1 == 71) {
          edt_Impairment_Rating_Left_Lower.text = "28";
        }
        if (test1 == 72) {
          edt_Impairment_Rating_Left_Lower.text = "29";
        }
        if (test1 == 73) {
          edt_Impairment_Rating_Left_Lower.text = "29";
        }
        if (test1 == 74) {
          edt_Impairment_Rating_Left_Lower.text = "30";
        }
        if (test1 == 75) {
          edt_Impairment_Rating_Left_Lower.text = "30";
        }
        if (test1 == 76) {
          edt_Impairment_Rating_Left_Lower.text = "30";
        }
        if (test1 == 77) {
          edt_Impairment_Rating_Left_Lower.text = "31";
        }
        if (test1 == 78) {
          edt_Impairment_Rating_Left_Lower.text = "31";
        }
        if (test1 == 79) {
          edt_Impairment_Rating_Left_Lower.text = "32";
        }
        if (test1 == 80) {
          edt_Impairment_Rating_Left_Lower.text = "32";
        }
        if (test1 == 81) {
          edt_Impairment_Rating_Left_Lower.text = "32";
        }
        if (test1 == 82) {
          edt_Impairment_Rating_Left_Lower.text = "33";
        }
        if (test1 == 83) {
          edt_Impairment_Rating_Left_Lower.text = "33";
        }
        if (test1 == 84) {
          edt_Impairment_Rating_Left_Lower.text = "34";
        }
        if (test1 == 85) {
          edt_Impairment_Rating_Left_Lower.text = "34";
        }
        if (test1 == 86) {
          edt_Impairment_Rating_Left_Lower.text = "34";
        }
        if (test1 == 87) {
          edt_Impairment_Rating_Left_Lower.text = "35";
        }
        if (test1 == 88) {
          edt_Impairment_Rating_Left_Lower.text = "35";
        }
        if (test1 == 89) {
          edt_Impairment_Rating_Left_Lower.text = "36";
        }
        if (test1 == 90) {
          edt_Impairment_Rating_Left_Lower.text = "36";
        }
        if (test1 == 91) {
          edt_Impairment_Rating_Left_Lower.text = "36";
        }
        if (test1 == 92) {
          edt_Impairment_Rating_Left_Lower.text = "37";
        }
        if (test1 == 93) {
          edt_Impairment_Rating_Left_Lower.text = "37";
        }
        if (test1 == 94) {
          edt_Impairment_Rating_Left_Lower.text = "38";
        }
        if (test1 == 95) {
          edt_Impairment_Rating_Left_Lower.text = "38";
        }
        if (test1 == 96) {
          edt_Impairment_Rating_Left_Lower.text = "38";
        }
        if (test1 == 97) {
          edt_Impairment_Rating_Left_Lower.text = "39";
        }
        if (test1 == 98) {
          edt_Impairment_Rating_Left_Lower.text = "39";
        }
        if (test1 == 99) {
          edt_Impairment_Rating_Left_Lower.text = "40";
        }
        if (test1 == 100) {
          edt_Impairment_Rating_Left_Lower.text = "40";
        }

        double a = edt_Impairment_Rating_Left_Lower.text.toString() == ""
            ? 0.00
            : double.parse(edt_Impairment_Rating_Left_Lower.text.toString());
        radio_four_red_per = a;
        double avgweek = edt_avg_weekly_wage.text.toString() == ""
            ? 0.00
            : double.parse(edt_avg_weekly_wage.text);
        double max_aww = edt_MAX_AWW.text.toString() == ""
            ? 0.00
            : double.parse(edt_MAX_AWW.text);
        double compRate = edt_COMP_RATE.text.toString() == ""
            ? 0.00
            : double.parse(edt_COMP_RATE.text);

        if (AgeFactorForInjury == 1.80) {
          TTDRate = (max_aww * 2) / 3;
        } else {
          if (avgweek > max_aww) {
            TTDRate = compRate;
          } else {
            TTDRate = (avgweek * 2) / 3;
          }
        }
        double resultb1 = TTDRate * 400 * AgeFactorForInjury;
        double resultb = (resultb1 * a) / 100;
        edt_Value_of_the_Rating_Left_Lower.text = resultb.toStringAsFixed(2);
        radio_four_red_value = resultb;

        LessMore2 = 0.00;
        LessMore2 = leftLowervalue - resultb;
        ISErrorleftLowervalue = true;
        totalawarvaluewithconvertion(TTDRate);
      } else {
        print("dfdfeer" + edt_left_lower_extremity_rating.text.toString());

        radio_four_red_per = 0.00;
        radio_four_red_value = 0.00;
        radio_four_red_before_per = 0.00;

        radio_four_red_after_per =
            edt_left_lower_extremity_rating.text.toString() == ""
                ? 0.00
                : double.parse(edt_left_lower_extremity_rating.text.toString());
        leftlowerExtremlyRatecalculation(edt_left_lower_extremity_rating.text);
        ISErrorleftLowervalue = false;
      }

      updatetotalschedule();
      totalawarvaluewithconvertion(TTDRate);
      TotalScheduleRateee();
    }
  }

  void LefttUpperExtremlyCovertFormula(bool value) {
    print("sd00dff" + value.toString());
    double TTDRate = 0.00;
    if (edt_left_upper_extremity_rating.text.isNotEmpty) {
      if (value == true) {
        // double a = edt_Impairment_Rating_Right_Lower.text.toString() == "" ? 0.00 : double.parse(edt_Impairment_Rating_Right_Lower.text.toString());

        double test = edt_left_upper_extremity_rating.text.toString() == ""
            ? 0.00
            : double.parse(edt_left_upper_extremity_rating.text.toString());
        radio_two_red_before_per = test;

        int test1 = test.toInt();
        if (test1 == 0) {
          edt_Impairment_Rating_Left_Upper.text = "0";
        }
        if (test1 == 1) {
          edt_Impairment_Rating_Left_Upper.text = "1";
        }
        if (test1 == 2) {
          edt_Impairment_Rating_Left_Upper.text = "1";
        }
        if (test1 == 3) {
          edt_Impairment_Rating_Left_Upper.text = "2";
        }
        if (test1 == 4) {
          edt_Impairment_Rating_Left_Upper.text = "2";
        }
        if (test1 == 5) {
          edt_Impairment_Rating_Left_Upper.text = "3";
        }
        if (test1 == 6) {
          edt_Impairment_Rating_Left_Upper.text = "4";
        }
        if (test1 == 7) {
          edt_Impairment_Rating_Left_Upper.text = "4";
        }
        if (test1 == 8) {
          edt_Impairment_Rating_Left_Upper.text = "5";
        }
        if (test1 == 9) {
          edt_Impairment_Rating_Left_Upper.text = "5";
        }
        if (test1 == 10) {
          edt_Impairment_Rating_Left_Upper.text = "6";
        }
        if (test1 == 11) {
          edt_Impairment_Rating_Left_Upper.text = "7";
        }
        if (test1 == 12) {
          edt_Impairment_Rating_Left_Upper.text = "7";
        }
        if (test1 == 13) {
          edt_Impairment_Rating_Left_Upper.text = "8";
        }
        if (test1 == 14) {
          edt_Impairment_Rating_Left_Upper.text = "8";
        }
        if (test1 == 15) {
          edt_Impairment_Rating_Left_Upper.text = "9";
        }
        if (test1 == 16) {
          edt_Impairment_Rating_Left_Upper.text = "10";
        }
        if (test1 == 17) {
          edt_Impairment_Rating_Left_Upper.text = "10";
        }
        if (test1 == 18) {
          edt_Impairment_Rating_Left_Upper.text = "11";
        }
        if (test1 == 19) {
          edt_Impairment_Rating_Left_Upper.text = "11";
        }
        if (test1 == 20) {
          edt_Impairment_Rating_Left_Upper.text = "12";
        }
        if (test1 == 21) {
          edt_Impairment_Rating_Left_Upper.text = "13";
        }
        if (test1 == 22) {
          edt_Impairment_Rating_Left_Upper.text = "13";
        }
        if (test1 == 23) {
          edt_Impairment_Rating_Left_Upper.text = "14";
        }
        if (test1 == 24) {
          edt_Impairment_Rating_Left_Upper.text = "14";
        }
        if (test1 == 25) {
          edt_Impairment_Rating_Left_Upper.text = "15";
        }
        if (test1 == 26) {
          edt_Impairment_Rating_Left_Upper.text = "16";
        }
        if (test1 == 27) {
          edt_Impairment_Rating_Left_Upper.text = "16";
        }
        if (test1 == 28) {
          edt_Impairment_Rating_Left_Upper.text = "17";
        }
        if (test1 == 29) {
          edt_Impairment_Rating_Left_Upper.text = "17";
        }
        if (test1 == 30) {
          edt_Impairment_Rating_Left_Upper.text = "18";
        }
        if (test1 == 31) {
          edt_Impairment_Rating_Left_Upper.text = "19";
        }
        if (test1 == 32) {
          edt_Impairment_Rating_Left_Upper.text = "19";
        }
        if (test1 == 33) {
          edt_Impairment_Rating_Left_Upper.text = "20";
        }
        if (test1 == 34) {
          edt_Impairment_Rating_Left_Upper.text = "20";
        }
        if (test1 == 35) {
          edt_Impairment_Rating_Left_Upper.text = "21";
        }
        if (test1 == 36) {
          edt_Impairment_Rating_Left_Upper.text = "22";
        }
        if (test1 == 37) {
          edt_Impairment_Rating_Left_Upper.text = "22";
        }
        if (test1 == 38) {
          edt_Impairment_Rating_Left_Upper.text = "23";
        }
        if (test1 == 39) {
          edt_Impairment_Rating_Left_Upper.text = "23";
        }
        if (test1 == 40) {
          edt_Impairment_Rating_Left_Upper.text = "24";
        }
        if (test1 == 41) {
          edt_Impairment_Rating_Left_Upper.text = "25";
        }
        if (test1 == 42) {
          edt_Impairment_Rating_Left_Upper.text = "25";
        }
        if (test1 == 43) {
          edt_Impairment_Rating_Left_Upper.text = "26";
        }
        if (test1 == 44) {
          edt_Impairment_Rating_Left_Upper.text = "26";
        }
        if (test1 == 45) {
          edt_Impairment_Rating_Left_Upper.text = "27";
        }
        if (test1 == 46) {
          edt_Impairment_Rating_Left_Upper.text = "28";
        }
        if (test1 == 47) {
          edt_Impairment_Rating_Left_Upper.text = "28";
        }
        if (test1 == 48) {
          edt_Impairment_Rating_Left_Upper.text = "29";
        }
        if (test1 == 49) {
          edt_Impairment_Rating_Left_Upper.text = "29";
        }
        if (test1 == 50) {
          edt_Impairment_Rating_Left_Upper.text = "30";
        }
        if (test1 == 51) {
          edt_Impairment_Rating_Left_Upper.text = "31";
        }
        if (test1 == 52) {
          edt_Impairment_Rating_Left_Upper.text = "31";
        }
        if (test1 == 53) {
          edt_Impairment_Rating_Left_Upper.text = "32";
        }
        if (test1 == 54) {
          edt_Impairment_Rating_Left_Upper.text = "32";
        }
        if (test1 == 55) {
          edt_Impairment_Rating_Left_Upper.text = "33";
        }
        if (test1 == 56) {
          edt_Impairment_Rating_Left_Upper.text = "34";
        }
        if (test1 == 57) {
          edt_Impairment_Rating_Left_Upper.text = "34";
        }
        if (test1 == 58) {
          edt_Impairment_Rating_Left_Upper.text = "35";
        }
        if (test1 == 59) {
          edt_Impairment_Rating_Left_Upper.text = "35";
        }
        if (test1 == 60) {
          edt_Impairment_Rating_Left_Upper.text = "36";
        }
        if (test1 == 61) {
          edt_Impairment_Rating_Left_Upper.text = "37";
        }
        if (test1 == 62) {
          edt_Impairment_Rating_Left_Upper.text = "37";
        }
        if (test1 == 63) {
          edt_Impairment_Rating_Left_Upper.text = "38";
        }
        if (test1 == 64) {
          edt_Impairment_Rating_Left_Upper.text = "38";
        }
        if (test1 == 65) {
          edt_Impairment_Rating_Left_Upper.text = "39";
        }
        if (test1 == 66) {
          edt_Impairment_Rating_Left_Upper.text = "40";
        }
        if (test1 == 67) {
          edt_Impairment_Rating_Left_Upper.text = "40";
        }
        if (test1 == 68) {
          edt_Impairment_Rating_Left_Upper.text = "41";
        }
        if (test1 == 69) {
          edt_Impairment_Rating_Left_Upper.text = "41";
        }
        if (test1 == 70) {
          edt_Impairment_Rating_Left_Upper.text = "42";
        }
        if (test1 == 71) {
          edt_Impairment_Rating_Left_Upper.text = "43";
        }
        if (test1 == 72) {
          edt_Impairment_Rating_Left_Upper.text = "43";
        }
        if (test1 == 73) {
          edt_Impairment_Rating_Left_Upper.text = "44";
        }
        if (test1 == 74) {
          edt_Impairment_Rating_Left_Upper.text = "44";
        }
        if (test1 == 75) {
          edt_Impairment_Rating_Left_Upper.text = "45";
        }
        if (test1 == 76) {
          edt_Impairment_Rating_Left_Upper.text = "46";
        }
        if (test1 == 77) {
          edt_Impairment_Rating_Left_Upper.text = "46";
        }
        if (test1 == 78) {
          edt_Impairment_Rating_Left_Upper.text = "47";
        }
        if (test1 == 79) {
          edt_Impairment_Rating_Left_Upper.text = "47";
        }
        if (test1 == 80) {
          edt_Impairment_Rating_Left_Upper.text = "48";
        }
        if (test1 == 81) {
          edt_Impairment_Rating_Left_Upper.text = "49";
        }
        if (test1 == 82) {
          edt_Impairment_Rating_Left_Upper.text = "49";
        }
        if (test1 == 83) {
          edt_Impairment_Rating_Left_Upper.text = "50";
        }
        if (test1 == 84) {
          edt_Impairment_Rating_Left_Upper.text = "50";
        }
        if (test1 == 85) {
          edt_Impairment_Rating_Left_Upper.text = "51";
        }
        if (test1 == 86) {
          edt_Impairment_Rating_Left_Upper.text = "52";
        }
        if (test1 == 87) {
          edt_Impairment_Rating_Left_Upper.text = "52";
        }
        if (test1 == 88) {
          edt_Impairment_Rating_Left_Upper.text = "53";
        }
        if (test1 == 89) {
          edt_Impairment_Rating_Left_Upper.text = "53";
        }
        if (test1 == 90) {
          edt_Impairment_Rating_Left_Upper.text = "54";
        }
        if (test1 == 91) {
          edt_Impairment_Rating_Left_Upper.text = "55";
        }
        if (test1 == 92) {
          edt_Impairment_Rating_Left_Upper.text = "55";
        }
        if (test1 == 93) {
          edt_Impairment_Rating_Left_Upper.text = "56";
        }
        if (test1 == 94) {
          edt_Impairment_Rating_Left_Upper.text = "56";
        }
        if (test1 == 95) {
          edt_Impairment_Rating_Left_Upper.text = "57";
        }
        if (test1 == 96) {
          edt_Impairment_Rating_Left_Upper.text = "58";
        }
        if (test1 == 97) {
          edt_Impairment_Rating_Left_Upper.text = "58";
        }
        if (test1 == 98) {
          edt_Impairment_Rating_Left_Upper.text = "59";
        }
        if (test1 == 99) {
          edt_Impairment_Rating_Left_Upper.text = "59";
        }
        if (test1 == 100) {
          edt_Impairment_Rating_Left_Upper.text = "60";
        }

        double a = edt_Impairment_Rating_Left_Upper.text.toString() == ""
            ? 0.00
            : double.parse(edt_Impairment_Rating_Left_Upper.text.toString());
        radio_two_red_per = a;

        double avgweek = edt_avg_weekly_wage.text.toString() == ""
            ? 0.00
            : double.parse(edt_avg_weekly_wage.text);
        double max_aww = edt_MAX_AWW.text.toString() == ""
            ? 0.00
            : double.parse(edt_MAX_AWW.text);
        double compRate = edt_COMP_RATE.text.toString() == ""
            ? 0.00
            : double.parse(edt_COMP_RATE.text);
        if (AgeFactorForInjury == 1.80) {
          TTDRate = (max_aww * 2) / 3;
        } else {
          if (avgweek > max_aww) {
            TTDRate = compRate;
          } else {
            TTDRate = (avgweek * 2) / 3;
          }
        }
        double resultb1 = TTDRate * 400 * AgeFactorForInjury;
        double resultb = (resultb1 * a) / 100;
        edt_Value_of_the_Rating_Left_Upper.text = resultb.toStringAsFixed(2);

        radio_two_red_value = resultb;

        LessMore3 = 0.00;
        LessMore3 = leftUppervalue - resultb;
        ISErrorleftUppervalue = true;
        totalawarvaluewithconvertion(TTDRate);
      } else {
        print("dfdfeer" + edt_left_upper_extremity_rating.text.toString());

        radio_two_red_per = 0.00;
        radio_two_red_value = 0.00;
        radio_two_red_before_per = 0.00;

        radio_two_red_after_per =
            edt_left_upper_extremity_rating.text.toString() == ""
                ? 0.00
                : double.parse(edt_left_upper_extremity_rating.text.toString());

        leftupperExtremlyRatecalculation(edt_left_upper_extremity_rating.text);
        ISErrorleftUppervalue = false;
      }

      updatetotalschedule();
      totalawarvaluewithconvertion(TTDRate);
      TotalScheduleRateee();
    }
  }

  void RightUpperExtremlyCovertFormula(bool value) {
    print("sd00dff" + value.toString());
    double TTDRate = 0.00;
    if (edt_right_upper_extremity_rating.text.isNotEmpty) {
      if (value == true) {
        // double a = edt_Impairment_Rating_Right_Lower.text.toString() == "" ? 0.00 : double.parse(edt_Impairment_Rating_Right_Lower.text.toString());

        double test = edt_right_upper_extremity_rating.text.toString() == ""
            ? 0.00
            : double.parse(edt_right_upper_extremity_rating.text.toString());
        radio_one_red_before_per = test;
        int test1 = test.toInt();

        if (test1 == 0) {
          edt_Impairment_Rating_Right_Upper.text = "0";
        }
        if (test1 == 1) {
          edt_Impairment_Rating_Right_Upper.text = "1";
        }
        if (test1 == 2) {
          edt_Impairment_Rating_Right_Upper.text = "1";
        }
        if (test1 == 3) {
          edt_Impairment_Rating_Right_Upper.text = "2";
        }
        if (test1 == 4) {
          edt_Impairment_Rating_Right_Upper.text = "2";
        }
        if (test1 == 5) {
          edt_Impairment_Rating_Right_Upper.text = "3";
        }
        if (test1 == 6) {
          edt_Impairment_Rating_Right_Upper.text = "4";
        }
        if (test1 == 7) {
          edt_Impairment_Rating_Right_Upper.text = "4";
        }
        if (test1 == 8) {
          edt_Impairment_Rating_Right_Upper.text = "5";
        }
        if (test1 == 9) {
          edt_Impairment_Rating_Right_Upper.text = "5";
        }
        if (test1 == 10) {
          edt_Impairment_Rating_Right_Upper.text = "6";
        }
        if (test1 == 11) {
          edt_Impairment_Rating_Right_Upper.text = "7";
        }
        if (test1 == 12) {
          edt_Impairment_Rating_Right_Upper.text = "7";
        }
        if (test1 == 13) {
          edt_Impairment_Rating_Right_Upper.text = "8";
        }
        if (test1 == 14) {
          edt_Impairment_Rating_Right_Upper.text = "8";
        }
        if (test1 == 15) {
          edt_Impairment_Rating_Right_Upper.text = "9";
        }
        if (test1 == 16) {
          edt_Impairment_Rating_Right_Upper.text = "10";
        }
        if (test1 == 17) {
          edt_Impairment_Rating_Right_Upper.text = "10";
        }
        if (test1 == 18) {
          edt_Impairment_Rating_Right_Upper.text = "11";
        }
        if (test1 == 19) {
          edt_Impairment_Rating_Right_Upper.text = "11";
        }
        if (test1 == 20) {
          edt_Impairment_Rating_Right_Upper.text = "12";
        }
        if (test1 == 21) {
          edt_Impairment_Rating_Right_Upper.text = "13";
        }
        if (test1 == 22) {
          edt_Impairment_Rating_Right_Upper.text = "13";
        }
        if (test1 == 23) {
          edt_Impairment_Rating_Right_Upper.text = "14";
        }
        if (test1 == 24) {
          edt_Impairment_Rating_Right_Upper.text = "14";
        }
        if (test1 == 25) {
          edt_Impairment_Rating_Right_Upper.text = "15";
        }
        if (test1 == 26) {
          edt_Impairment_Rating_Right_Upper.text = "16";
        }
        if (test1 == 27) {
          edt_Impairment_Rating_Right_Upper.text = "16";
        }
        if (test1 == 28) {
          edt_Impairment_Rating_Right_Upper.text = "17";
        }
        if (test1 == 29) {
          edt_Impairment_Rating_Right_Upper.text = "17";
        }
        if (test1 == 30) {
          edt_Impairment_Rating_Right_Upper.text = "18";
        }
        if (test1 == 31) {
          edt_Impairment_Rating_Right_Upper.text = "19";
        }
        if (test1 == 32) {
          edt_Impairment_Rating_Right_Upper.text = "19";
        }
        if (test1 == 33) {
          edt_Impairment_Rating_Right_Upper.text = "20";
        }
        if (test1 == 34) {
          edt_Impairment_Rating_Right_Upper.text = "20";
        }
        if (test1 == 35) {
          edt_Impairment_Rating_Right_Upper.text = "21";
        }
        if (test1 == 36) {
          edt_Impairment_Rating_Right_Upper.text = "22";
        }
        if (test1 == 37) {
          edt_Impairment_Rating_Right_Upper.text = "22";
        }
        if (test1 == 38) {
          edt_Impairment_Rating_Right_Upper.text = "23";
        }
        if (test1 == 39) {
          edt_Impairment_Rating_Right_Upper.text = "23";
        }
        if (test1 == 40) {
          edt_Impairment_Rating_Right_Upper.text = "24";
        }
        if (test1 == 41) {
          edt_Impairment_Rating_Right_Upper.text = "25";
        }
        if (test1 == 42) {
          edt_Impairment_Rating_Right_Upper.text = "25";
        }
        if (test1 == 43) {
          edt_Impairment_Rating_Right_Upper.text = "26";
        }
        if (test1 == 44) {
          edt_Impairment_Rating_Right_Upper.text = "26";
        }
        if (test1 == 45) {
          edt_Impairment_Rating_Right_Upper.text = "27";
        }
        if (test1 == 46) {
          edt_Impairment_Rating_Right_Upper.text = "28";
        }
        if (test1 == 47) {
          edt_Impairment_Rating_Right_Upper.text = "28";
        }
        if (test1 == 48) {
          edt_Impairment_Rating_Right_Upper.text = "29";
        }
        if (test1 == 49) {
          edt_Impairment_Rating_Right_Upper.text = "29";
        }
        if (test1 == 50) {
          edt_Impairment_Rating_Right_Upper.text = "30";
        }
        if (test1 == 51) {
          edt_Impairment_Rating_Right_Upper.text = "31";
        }
        if (test1 == 52) {
          edt_Impairment_Rating_Right_Upper.text = "31";
        }
        if (test1 == 53) {
          edt_Impairment_Rating_Right_Upper.text = "32";
        }
        if (test1 == 54) {
          edt_Impairment_Rating_Right_Upper.text = "32";
        }
        if (test1 == 55) {
          edt_Impairment_Rating_Right_Upper.text = "33";
        }
        if (test1 == 56) {
          edt_Impairment_Rating_Right_Upper.text = "34";
        }
        if (test1 == 57) {
          edt_Impairment_Rating_Right_Upper.text = "34";
        }
        if (test1 == 58) {
          edt_Impairment_Rating_Right_Upper.text = "35";
        }
        if (test1 == 59) {
          edt_Impairment_Rating_Right_Upper.text = "35";
        }
        if (test1 == 60) {
          edt_Impairment_Rating_Right_Upper.text = "36";
        }
        if (test1 == 61) {
          edt_Impairment_Rating_Right_Upper.text = "37";
        }
        if (test1 == 62) {
          edt_Impairment_Rating_Right_Upper.text = "37";
        }
        if (test1 == 63) {
          edt_Impairment_Rating_Right_Upper.text = "38";
        }
        if (test1 == 64) {
          edt_Impairment_Rating_Right_Upper.text = "38";
        }
        if (test1 == 65) {
          edt_Impairment_Rating_Right_Upper.text = "39";
        }
        if (test1 == 66) {
          edt_Impairment_Rating_Right_Upper.text = "40";
        }
        if (test1 == 67) {
          edt_Impairment_Rating_Right_Upper.text = "40";
        }
        if (test1 == 68) {
          edt_Impairment_Rating_Right_Upper.text = "41";
        }
        if (test1 == 69) {
          edt_Impairment_Rating_Right_Upper.text = "41";
        }
        if (test1 == 70) {
          edt_Impairment_Rating_Right_Upper.text = "42";
        }
        if (test1 == 71) {
          edt_Impairment_Rating_Right_Upper.text = "43";
        }
        if (test1 == 72) {
          edt_Impairment_Rating_Right_Upper.text = "43";
        }
        if (test1 == 73) {
          edt_Impairment_Rating_Right_Upper.text = "44";
        }
        if (test1 == 74) {
          edt_Impairment_Rating_Right_Upper.text = "44";
        }
        if (test1 == 75) {
          edt_Impairment_Rating_Right_Upper.text = "45";
        }
        if (test1 == 76) {
          edt_Impairment_Rating_Right_Upper.text = "46";
        }
        if (test1 == 77) {
          edt_Impairment_Rating_Right_Upper.text = "46";
        }
        if (test1 == 78) {
          edt_Impairment_Rating_Right_Upper.text = "47";
        }
        if (test1 == 79) {
          edt_Impairment_Rating_Right_Upper.text = "47";
        }
        if (test1 == 80) {
          edt_Impairment_Rating_Right_Upper.text = "48";
        }
        if (test1 == 81) {
          edt_Impairment_Rating_Right_Upper.text = "49";
        }
        if (test1 == 82) {
          edt_Impairment_Rating_Right_Upper.text = "49";
        }
        if (test1 == 83) {
          edt_Impairment_Rating_Right_Upper.text = "50";
        }
        if (test1 == 84) {
          edt_Impairment_Rating_Right_Upper.text = "50";
        }
        if (test1 == 85) {
          edt_Impairment_Rating_Right_Upper.text = "51";
        }
        if (test1 == 86) {
          edt_Impairment_Rating_Right_Upper.text = "52";
        }
        if (test1 == 87) {
          edt_Impairment_Rating_Right_Upper.text = "52";
        }
        if (test1 == 88) {
          edt_Impairment_Rating_Right_Upper.text = "53";
        }
        if (test1 == 89) {
          edt_Impairment_Rating_Right_Upper.text = "53";
        }
        if (test1 == 90) {
          edt_Impairment_Rating_Right_Upper.text = "54";
        }
        if (test1 == 91) {
          edt_Impairment_Rating_Right_Upper.text = "55";
        }
        if (test1 == 92) {
          edt_Impairment_Rating_Right_Upper.text = "55";
        }
        if (test1 == 93) {
          edt_Impairment_Rating_Right_Upper.text = "56";
        }
        if (test1 == 94) {
          edt_Impairment_Rating_Right_Upper.text = "56";
        }
        if (test1 == 95) {
          edt_Impairment_Rating_Right_Upper.text = "57";
        }
        if (test1 == 96) {
          edt_Impairment_Rating_Right_Upper.text = "58";
        }
        if (test1 == 97) {
          edt_Impairment_Rating_Right_Upper.text = "58";
        }
        if (test1 == 98) {
          edt_Impairment_Rating_Right_Upper.text = "59";
        }
        if (test1 == 99) {
          edt_Impairment_Rating_Right_Upper.text = "59";
        }
        if (test1 == 100) {
          edt_Impairment_Rating_Right_Upper.text = "60";
        }

        double a = edt_Impairment_Rating_Right_Upper.text.toString() == ""
            ? 0.00
            : double.parse(edt_Impairment_Rating_Right_Upper.text.toString());

        radio_one_red_per = a;
        print("Scenario_eight : max_aww : " +
            edt_MAX_AWW.text.toString() +
            " CompRate : " +
            edt_COMP_RATE.text.toString() +
            " Age Factor : " +
            AgeFactorForInjury.toString());

        double avgweek = edt_avg_weekly_wage.text.toString() == ""
            ? 0.00
            : double.parse(edt_avg_weekly_wage.text);
        double max_aww = edt_MAX_AWW.text.toString() == ""
            ? 0.00
            : double.parse(edt_MAX_AWW.text);
        double compRate = edt_COMP_RATE.text.toString() == ""
            ? 0.00
            : double.parse(edt_COMP_RATE.text);
        if (AgeFactorForInjury == 1.80) {
          TTDRate = (max_aww * 2) / 3;
        } else {
          if (avgweek > max_aww) {
            TTDRate = compRate;
          } else {
            TTDRate = (avgweek * 2) / 3;
          }
        }

        double resultb1 = TTDRate * 400 * AgeFactorForInjury;
        double resultb = (resultb1 * a) / 100;
        edt_Value_of_the_Rating_Right_Upper.text = resultb.toStringAsFixed(2);

        radio_one_red_value = resultb;

        LessMore4 = 0.00;
        LessMore4 = rightUppervalue - resultb;
        ISErrorrightUppervalue = true;
        totalawarvaluewithconvertion(TTDRate);
      } else {
        print("dfdfeer" + edt_right_upper_extremity_rating.text.toString());

        radio_one_red_per = 0.00;
        radio_one_red_value = 0.00;
        radio_one_red_before_per = 0.00;

        radio_one_red_after_per = edt_right_upper_extremity_rating.text
                    .toString() ==
                ""
            ? 0.00
            : double.parse(edt_right_upper_extremity_rating.text.toString());

        rightupperExtremlyRatecalculation(
            edt_right_upper_extremity_rating.text);
        ISErrorrightUppervalue = false;
      }
      updatetotalschedule();
      totalawarvaluewithconvertion(TTDRate);
      TotalScheduleRateee();
    }
  }

  void updatetotalschedule() {
    /*  double d = edt_Impairment_Rating_Right_Upper.text.toString() == "" ? 0.00 : double.parse(edt_Impairment_Rating_Right_Upper.text.toString());
    double e = edt_Impairment_Rating_Left_Upper.text.toString() == "" ? 0.00 : double.parse(edt_Impairment_Rating_Left_Upper.text.toString());
    double f = edt_Impairment_Rating_Right_Lower.text.toString() == "" ? 0.00 : double.parse(edt_Impairment_Rating_Right_Lower.text.toString());
    double g = edt_Impairment_Rating_Left_Lower.text.toString() == "" ? 0.00 : double.parse(edt_Impairment_Rating_Left_Lower.text.toString());*/

    double Totalrate = 0.00;

    // double Totalrate = radio_one_red_per +
    //     radio_two_red_per +
    //     radio_three_red_per +
    //     radio_four_red_per;
    // print("ddfdff34" + " Total : " + Totalrate.toString());
    //
    // edt_Combined_Whole_Person_Rate.text = Totalrate.toStringAsFixed(2);

    // Array<> first;
    int first = 0;

    //

    if (radio_one_red_per != 0.00) {
      first = 1;
      row = radio_one_red_per;
      print("one input");
    } else if (radio_two_red_per != 0.00 && first == 0) {
      print("two input");
      first = 2;
      row = radio_two_red_per;
    } else if (radio_three_red_per != 0.00 && first == 0) {
      print("three input");
      first = 3;
      row = radio_three_red_per;
    } else if (radio_four_red_after_per != 0.00 && first == 0) {
      print("four input");
      first = 4;
      row = radio_four_red_per;
    }
    if (radio_two_red_per != 0.00 && first != 0 && first != 2) {
      print("Column two input");
      column = radio_two_red_per;
    } else if (radio_three_red_per != 0.00 && first != 0 && first != 3) {
      print("Column three input");
      column = radio_three_red_per;
    } else if (radio_four_red_after_per != 0.00 && first != 0 && first != 4) {
      print("Column four input");
      column = radio_four_red_per;
    }

//
    bool isRow_1 = false,
        isRow_2 = false,
        isRow_3 = false,
        isRow_4 = false,
        notRepeat = false;
    if (radio_one_red_per != 0.00) {
      isRow_1 = true;
    } else if (radio_two_red_per != 0.00) {
      isRow_2 = true;
    } else if (radio_three_red_per != 0.00) {
      isRow_3 = true;
    } else if (radio_four_red_per != 0.00) {
      isRow_4 = true;
    }
    if (radio_one_red_per != 0.00 &&
        radio_two_red_per != 0.00 &&
        radio_three_red_per != 0.00 &&
        radio_four_red_per != 0.00) {
      notRepeat = true;
      Totalrate = 0.00;
      edt_Combined_Whole_Person_Rate.text = "";
    }
    if (isRow_1 == true && isRow_2 == true && isRow_3 == true) {
      notRepeat = true;
      Totalrate = 0.00;
      edt_Combined_Whole_Person_Rate.text = "";
    } else if (isRow_2 == true && isRow_3 == true && isRow_4 == true) {
      notRepeat = true;
      Totalrate = 0.00;
      edt_Combined_Whole_Person_Rate.text = "";
    } else if (isRow_3 == true && isRow_4 == true && isRow_1 == true) {
      notRepeat = true;
      Totalrate = 0.00;
      edt_Combined_Whole_Person_Rate.text = "";
    } else if (isRow_4 == true && isRow_1 == true && isRow_2 == true) {
      notRepeat = true;
      Totalrate = 0.00;
      edt_Combined_Whole_Person_Rate.text = "";
    } else {
      notRepeat = false;
    }
    List<dynamic> list = [
      {"row": 1, "column": 1, "value": 2},
      {"row": 2, "column": 1, "value": 3},
      {"row": 3, "column": 1, "value": 4},
      {"row": 4, "column": 1, "value": 5},
      {"row": 5, "column": 1, "value": 6},
      {"row": 6, "column": 1, "value": 7},
      {"row": 7, "column": 1, "value": 8},
      {"row": 8, "column": 1, "value": 9},
      {"row": 9, "column": 1, "value": 10},
      {"row": 10, "column": 1, "value": 11},
      {"row": 11, "column": 1, "value": 12},
      {"row": 12, "column": 1, "value": 13},
      {"row": 13, "column": 1, "value": 14},
      {"row": 14, "column": 1, "value": 15},
      {"row": 15, "column": 1, "value": 16},
      {"row": 16, "column": 1, "value": 17},
      {"row": 17, "column": 1, "value": 18},
      {"row": 18, "column": 1, "value": 19},
      {"row": 19, "column": 1, "value": 20},
      {"row": 20, "column": 1, "value": 21},
      {"row": 21, "column": 1, "value": 22},
      {"row": 22, "column": 1, "value": 23},
      {"row": 23, "column": 1, "value": 24},
      {"row": 24, "column": 1, "value": 25},
      {"row": 25, "column": 1, "value": 26},
      {"row": 26, "column": 1, "value": 27},
      {"row": 27, "column": 1, "value": 28},
      {"row": 28, "column": 1, "value": 29},
      {"row": 29, "column": 1, "value": 30},
      {"row": 30, "column": 1, "value": 31},
      {"row": 31, "column": 1, "value": 32},
      {"row": 32, "column": 1, "value": 33},
      {"row": 33, "column": 1, "value": 34},
      {"row": 34, "column": 1, "value": 35},
      {"row": 35, "column": 1, "value": 36},
      {"row": 36, "column": 1, "value": 37},
      {"row": 37, "column": 1, "value": 38},
      {"row": 38, "column": 1, "value": 39},
      {"row": 39, "column": 1, "value": 40},
      {"row": 40, "column": 1, "value": 41},
      {"row": 41, "column": 1, "value": 42},
      {"row": 42, "column": 1, "value": 43},
      {"row": 43, "column": 1, "value": 44},
      {"row": 44, "column": 1, "value": 45},
      {"row": 45, "column": 1, "value": 46},
      {"row": 46, "column": 1, "value": 47},
      {"row": 47, "column": 1, "value": 48},
      {"row": 48, "column": 1, "value": 49},
      {"row": 49, "column": 1, "value": 50},
      {"row": 50, "column": 1, "value": 51},
      {"row": 51, "column": 1, "value": 51},
      {"row": 52, "column": 1, "value": 52},
      {"row": 53, "column": 1, "value": 53},
      {"row": 54, "column": 1, "value": 54},
      {"row": 55, "column": 1, "value": 55},
      {"row": 56, "column": 1, "value": 56},
      {"row": 57, "column": 1, "value": 57},
      {"row": 58, "column": 1, "value": 58},
      {"row": 59, "column": 1, "value": 59},
      {"row": 60, "column": 1, "value": 60},
      {"row": 61, "column": 1, "value": 61},
      {"row": 62, "column": 1, "value": 62},
      {"row": 63, "column": 1, "value": 63},
      {"row": 64, "column": 1, "value": 64},
      {"row": 65, "column": 1, "value": 65},
      {"row": 66, "column": 1, "value": 66},
      {"row": 67, "column": 1, "value": 67},
      {"row": 68, "column": 1, "value": 68},
      {"row": 69, "column": 1, "value": 69},
      {"row": 70, "column": 1, "value": 70},
      {"row": 71, "column": 1, "value": 71},
      {"row": 72, "column": 1, "value": 72},
      {"row": 73, "column": 1, "value": 73},
      {"row": 74, "column": 1, "value": 74},
      {"row": 75, "column": 1, "value": 75},
      {"row": 76, "column": 1, "value": 76},
      {"row": 77, "column": 1, "value": 77},
      {"row": 78, "column": 1, "value": 78},
      {"row": 79, "column": 1, "value": 79},
      {"row": 80, "column": 1, "value": 80},
      {"row": 81, "column": 1, "value": 81},
      {"row": 82, "column": 1, "value": 82},
      {"row": 83, "column": 1, "value": 83},
      {"row": 84, "column": 1, "value": 84},
      {"row": 85, "column": 1, "value": 85},
      {"row": 86, "column": 1, "value": 86},
      {"row": 87, "column": 1, "value": 87},
      {"row": 88, "column": 1, "value": 88},
      {"row": 89, "column": 1, "value": 89},
      {"row": 90, "column": 1, "value": 90},
      {"row": 91, "column": 1, "value": 91},
      {"row": 92, "column": 1, "value": 92},
      {"row": 93, "column": 1, "value": 93},
      {"row": 94, "column": 1, "value": 94},
      {"row": 95, "column": 1, "value": 95},
      {"row": 96, "column": 1, "value": 96},
      {"row": 97, "column": 1, "value": 97},
      {"row": 98, "column": 1, "value": 98},
      {"row": 99, "column": 1, "value": 99},
      {"row": 2, "column": 2, "value": 4},
      {"row": 3, "column": 2, "value": 5},
      {"row": 4, "column": 2, "value": 6},
      {"row": 5, "column": 2, "value": 7},
      {"row": 6, "column": 2, "value": 8},
      {"row": 7, "column": 2, "value": 9},
      {"row": 8, "column": 2, "value": 10},
      {"row": 9, "column": 2, "value": 11},
      {"row": 10, "column": 2, "value": 12},
      {"row": 11, "column": 2, "value": 13},
      {"row": 12, "column": 2, "value": 14},
      {"row": 13, "column": 2, "value": 15},
      {"row": 14, "column": 2, "value": 16},
      {"row": 15, "column": 2, "value": 17},
      {"row": 16, "column": 2, "value": 18},
      {"row": 17, "column": 2, "value": 19},
      {"row": 18, "column": 2, "value": 20},
      {"row": 19, "column": 2, "value": 21},
      {"row": 20, "column": 2, "value": 22},
      {"row": 21, "column": 2, "value": 23},
      {"row": 22, "column": 2, "value": 24},
      {"row": 23, "column": 2, "value": 25},
      {"row": 24, "column": 2, "value": 26},
      {"row": 25, "column": 2, "value": 27},
      {"row": 26, "column": 2, "value": 27},
      {"row": 27, "column": 2, "value": 28},
      {"row": 28, "column": 2, "value": 29},
      {"row": 29, "column": 2, "value": 30},
      {"row": 30, "column": 2, "value": 31},
      {"row": 31, "column": 2, "value": 32},
      {"row": 32, "column": 2, "value": 33},
      {"row": 33, "column": 2, "value": 34},
      {"row": 34, "column": 2, "value": 35},
      {"row": 35, "column": 2, "value": 36},
      {"row": 36, "column": 2, "value": 37},
      {"row": 37, "column": 2, "value": 38},
      {"row": 38, "column": 2, "value": 39},
      {"row": 39, "column": 2, "value": 40},
      {"row": 40, "column": 2, "value": 41},
      {"row": 41, "column": 2, "value": 42},
      {"row": 42, "column": 2, "value": 43},
      {"row": 43, "column": 2, "value": 44},
      {"row": 44, "column": 2, "value": 45},
      {"row": 45, "column": 2, "value": 46},
      {"row": 46, "column": 2, "value": 47},
      {"row": 47, "column": 2, "value": 48},
      {"row": 48, "column": 2, "value": 49},
      {"row": 49, "column": 2, "value": 50},
      {"row": 50, "column": 2, "value": 51},
      {"row": 51, "column": 2, "value": 52},
      {"row": 52, "column": 2, "value": 53},
      {"row": 53, "column": 2, "value": 54},
      {"row": 54, "column": 2, "value": 55},
      {"row": 55, "column": 2, "value": 56},
      {"row": 56, "column": 2, "value": 57},
      {"row": 57, "column": 2, "value": 58},
      {"row": 58, "column": 2, "value": 59},
      {"row": 59, "column": 2, "value": 60},
      {"row": 60, "column": 2, "value": 61},
      {"row": 61, "column": 2, "value": 62},
      {"row": 62, "column": 2, "value": 63},
      {"row": 63, "column": 2, "value": 64},
      {"row": 64, "column": 2, "value": 65},
      {"row": 65, "column": 2, "value": 66},
      {"row": 66, "column": 2, "value": 67},
      {"row": 67, "column": 2, "value": 68},
      {"row": 68, "column": 2, "value": 69},
      {"row": 69, "column": 2, "value": 70},
      {"row": 70, "column": 2, "value": 71},
      {"row": 71, "column": 2, "value": 72},
      {"row": 72, "column": 2, "value": 73},
      {"row": 73, "column": 2, "value": 74},
      {"row": 74, "column": 2, "value": 75},
      {"row": 75, "column": 2, "value": 76},
      {"row": 76, "column": 2, "value": 76},
      {"row": 77, "column": 2, "value": 77},
      {"row": 78, "column": 2, "value": 78},
      {"row": 79, "column": 2, "value": 79},
      {"row": 80, "column": 2, "value": 80},
      {"row": 81, "column": 2, "value": 81},
      {"row": 82, "column": 2, "value": 82},
      {"row": 83, "column": 2, "value": 83},
      {"row": 84, "column": 2, "value": 84},
      {"row": 85, "column": 2, "value": 85},
      {"row": 86, "column": 2, "value": 86},
      {"row": 87, "column": 2, "value": 87},
      {"row": 88, "column": 2, "value": 88},
      {"row": 89, "column": 2, "value": 89},
      {"row": 90, "column": 2, "value": 90},
      {"row": 91, "column": 2, "value": 91},
      {"row": 92, "column": 2, "value": 92},
      {"row": 93, "column": 2, "value": 93},
      {"row": 94, "column": 2, "value": 94},
      {"row": 95, "column": 2, "value": 95},
      {"row": 96, "column": 2, "value": 96},
      {"row": 97, "column": 2, "value": 97},
      {"row": 98, "column": 2, "value": 98},
      {"row": 99, "column": 2, "value": 99},
      {"row": 3, "column": 3, "value": 6},
      {"row": 4, "column": 3, "value": 7},
      {"row": 5, "column": 3, "value": 8},
      {"row": 6, "column": 3, "value": 9},
      {"row": 7, "column": 3, "value": 10},
      {"row": 8, "column": 3, "value": 11},
      {"row": 9, "column": 3, "value": 12},
      {"row": 10, "column": 3, "value": 13},
      {"row": 11, "column": 3, "value": 14},
      {"row": 12, "column": 3, "value": 15},
      {"row": 13, "column": 3, "value": 16},
      {"row": 14, "column": 3, "value": 17},
      {"row": 15, "column": 3, "value": 18},
      {"row": 16, "column": 3, "value": 19},
      {"row": 17, "column": 3, "value": 19},
      {"row": 18, "column": 3, "value": 20},
      {"row": 19, "column": 3, "value": 21},
      {"row": 20, "column": 3, "value": 22},
      {"row": 21, "column": 3, "value": 23},
      {"row": 22, "column": 3, "value": 24},
      {"row": 23, "column": 3, "value": 25},
      {"row": 24, "column": 3, "value": 26},
      {"row": 25, "column": 3, "value": 27},
      {"row": 26, "column": 3, "value": 28},
      {"row": 27, "column": 3, "value": 29},
      {"row": 28, "column": 3, "value": 30},
      {"row": 29, "column": 3, "value": 31},
      {"row": 30, "column": 3, "value": 32},
      {"row": 31, "column": 3, "value": 33},
      {"row": 32, "column": 3, "value": 34},
      {"row": 33, "column": 3, "value": 35},
      {"row": 34, "column": 3, "value": 36},
      {"row": 35, "column": 3, "value": 37},
      {"row": 36, "column": 3, "value": 38},
      {"row": 37, "column": 3, "value": 39},
      {"row": 38, "column": 3, "value": 40},
      {"row": 39, "column": 3, "value": 41},
      {"row": 40, "column": 3, "value": 42},
      {"row": 41, "column": 3, "value": 43},
      {"row": 42, "column": 3, "value": 44},
      {"row": 43, "column": 3, "value": 45},
      {"row": 44, "column": 3, "value": 46},
      {"row": 45, "column": 3, "value": 47},
      {"row": 46, "column": 3, "value": 48},
      {"row": 47, "column": 3, "value": 49},
      {"row": 48, "column": 3, "value": 50},
      {"row": 49, "column": 3, "value": 51},
      {"row": 50, "column": 3, "value": 52},
      {"row": 51, "column": 3, "value": 52},
      {"row": 52, "column": 3, "value": 53},
      {"row": 53, "column": 3, "value": 54},
      {"row": 54, "column": 3, "value": 55},
      {"row": 55, "column": 3, "value": 56},
      {"row": 56, "column": 3, "value": 57},
      {"row": 57, "column": 3, "value": 58},
      {"row": 58, "column": 3, "value": 59},
      {"row": 59, "column": 3, "value": 60},
      {"row": 60, "column": 3, "value": 61},
      {"row": 61, "column": 3, "value": 62},
      {"row": 62, "column": 3, "value": 63},
      {"row": 63, "column": 3, "value": 64},
      {"row": 64, "column": 3, "value": 65},
      {"row": 65, "column": 3, "value": 66},
      {"row": 66, "column": 3, "value": 67},
      {"row": 67, "column": 3, "value": 68},
      {"row": 68, "column": 3, "value": 69},
      {"row": 69, "column": 3, "value": 70},
      {"row": 70, "column": 3, "value": 71},
      {"row": 71, "column": 3, "value": 72},
      {"row": 72, "column": 3, "value": 73},
      {"row": 73, "column": 3, "value": 74},
      {"row": 74, "column": 3, "value": 75},
      {"row": 75, "column": 3, "value": 76},
      {"row": 76, "column": 3, "value": 77},
      {"row": 77, "column": 3, "value": 78},
      {"row": 78, "column": 3, "value": 79},
      {"row": 79, "column": 3, "value": 80},
      {"row": 80, "column": 3, "value": 81},
      {"row": 81, "column": 3, "value": 82},
      {"row": 82, "column": 3, "value": 83},
      {"row": 83, "column": 3, "value": 84},
      {"row": 84, "column": 3, "value": 84},
      {"row": 85, "column": 3, "value": 85},
      {"row": 86, "column": 3, "value": 86},
      {"row": 87, "column": 3, "value": 87},
      {"row": 88, "column": 3, "value": 88},
      {"row": 89, "column": 3, "value": 89},
      {"row": 90, "column": 3, "value": 90},
      {"row": 91, "column": 3, "value": 91},
      {"row": 92, "column": 3, "value": 92},
      {"row": 93, "column": 3, "value": 93},
      {"row": 94, "column": 3, "value": 94},
      {"row": 95, "column": 3, "value": 95},
      {"row": 96, "column": 3, "value": 96},
      {"row": 97, "column": 3, "value": 97},
      {"row": 98, "column": 3, "value": 98},
      {"row": 99, "column": 3, "value": 99},
      {"row": 4, "column": 4, "value": 8},
      {"row": 5, "column": 4, "value": 9},
      {"row": 6, "column": 4, "value": 10},
      {"row": 7, "column": 4, "value": 11},
      {"row": 8, "column": 4, "value": 12},
      {"row": 9, "column": 4, "value": 13},
      {"row": 10, "column": 4, "value": 14},
      {"row": 11, "column": 4, "value": 15},
      {"row": 12, "column": 4, "value": 16},
      {"row": 13, "column": 4, "value": 16},
      {"row": 14, "column": 4, "value": 17},
      {"row": 15, "column": 4, "value": 18},
      {"row": 16, "column": 4, "value": 19},
      {"row": 17, "column": 4, "value": 20},
      {"row": 18, "column": 4, "value": 21},
      {"row": 19, "column": 4, "value": 22},
      {"row": 20, "column": 4, "value": 23},
      {"row": 21, "column": 4, "value": 24},
      {"row": 22, "column": 4, "value": 25},
      {"row": 23, "column": 4, "value": 26},
      {"row": 24, "column": 4, "value": 27},
      {"row": 25, "column": 4, "value": 28},
      {"row": 26, "column": 4, "value": 29},
      {"row": 27, "column": 4, "value": 30},
      {"row": 28, "column": 4, "value": 31},
      {"row": 29, "column": 4, "value": 32},
      {"row": 30, "column": 4, "value": 33},
      {"row": 31, "column": 4, "value": 34},
      {"row": 32, "column": 4, "value": 35},
      {"row": 33, "column": 4, "value": 36},
      {"row": 34, "column": 4, "value": 37},
      {"row": 35, "column": 4, "value": 38},
      {"row": 36, "column": 4, "value": 39},
      {"row": 37, "column": 4, "value": 40},
      {"row": 38, "column": 4, "value": 40},
      {"row": 39, "column": 4, "value": 41},
      {"row": 40, "column": 4, "value": 42},
      {"row": 41, "column": 4, "value": 43},
      {"row": 42, "column": 4, "value": 44},
      {"row": 43, "column": 4, "value": 45},
      {"row": 44, "column": 4, "value": 46},
      {"row": 45, "column": 4, "value": 47},
      {"row": 46, "column": 4, "value": 48},
      {"row": 47, "column": 4, "value": 49},
      {"row": 48, "column": 4, "value": 50},
      {"row": 49, "column": 4, "value": 51},
      {"row": 50, "column": 4, "value": 52},
      {"row": 51, "column": 4, "value": 53},
      {"row": 52, "column": 4, "value": 54},
      {"row": 53, "column": 4, "value": 55},
      {"row": 54, "column": 4, "value": 56},
      {"row": 55, "column": 4, "value": 57},
      {"row": 56, "column": 4, "value": 58},
      {"row": 57, "column": 4, "value": 59},
      {"row": 58, "column": 4, "value": 60},
      {"row": 59, "column": 4, "value": 61},
      {"row": 60, "column": 4, "value": 62},
      {"row": 61, "column": 4, "value": 63},
      {"row": 62, "column": 4, "value": 64},
      {"row": 63, "column": 4, "value": 64},
      {"row": 64, "column": 4, "value": 65},
      {"row": 65, "column": 4, "value": 66},
      {"row": 66, "column": 4, "value": 67},
      {"row": 67, "column": 4, "value": 68},
      {"row": 68, "column": 4, "value": 69},
      {"row": 69, "column": 4, "value": 70},
      {"row": 70, "column": 4, "value": 71},
      {"row": 71, "column": 4, "value": 72},
      {"row": 72, "column": 4, "value": 73},
      {"row": 73, "column": 4, "value": 74},
      {"row": 74, "column": 4, "value": 75},
      {"row": 75, "column": 4, "value": 76},
      {"row": 76, "column": 4, "value": 77},
      {"row": 77, "column": 4, "value": 78},
      {"row": 78, "column": 4, "value": 79},
      {"row": 79, "column": 4, "value": 80},
      {"row": 80, "column": 4, "value": 81},
      {"row": 81, "column": 4, "value": 82},
      {"row": 82, "column": 4, "value": 83},
      {"row": 83, "column": 4, "value": 84},
      {"row": 84, "column": 4, "value": 85},
      {"row": 85, "column": 4, "value": 86},
      {"row": 86, "column": 4, "value": 87},
      {"row": 87, "column": 4, "value": 88},
      {"row": 88, "column": 4, "value": 88},
      {"row": 89, "column": 4, "value": 89},
      {"row": 90, "column": 4, "value": 90},
      {"row": 91, "column": 4, "value": 91},
      {"row": 92, "column": 4, "value": 92},
      {"row": 93, "column": 4, "value": 93},
      {"row": 94, "column": 4, "value": 94},
      {"row": 95, "column": 4, "value": 95},
      {"row": 96, "column": 4, "value": 96},
      {"row": 97, "column": 4, "value": 97},
      {"row": 98, "column": 4, "value": 98},
      {"row": 99, "column": 4, "value": 99},
      {"row": 5, "column": 5, "value": 10},
      {"row": 6, "column": 5, "value": 11},
      {"row": 7, "column": 5, "value": 12},
      {"row": 8, "column": 5, "value": 13},
      {"row": 9, "column": 5, "value": 14},
      {"row": 10, "column": 5, "value": 15},
      {"row": 11, "column": 5, "value": 15},
      {"row": 12, "column": 5, "value": 16},
      {"row": 13, "column": 5, "value": 17},
      {"row": 14, "column": 5, "value": 18},
      {"row": 15, "column": 5, "value": 19},
      {"row": 16, "column": 5, "value": 20},
      {"row": 17, "column": 5, "value": 21},
      {"row": 18, "column": 5, "value": 22},
      {"row": 19, "column": 5, "value": 23},
      {"row": 20, "column": 5, "value": 24},
      {"row": 21, "column": 5, "value": 25},
      {"row": 22, "column": 5, "value": 26},
      {"row": 23, "column": 5, "value": 27},
      {"row": 24, "column": 5, "value": 28},
      {"row": 25, "column": 5, "value": 29},
      {"row": 26, "column": 5, "value": 30},
      {"row": 27, "column": 5, "value": 31},
      {"row": 28, "column": 5, "value": 32},
      {"row": 29, "column": 5, "value": 33},
      {"row": 30, "column": 5, "value": 34},
      {"row": 31, "column": 5, "value": 34},
      {"row": 32, "column": 5, "value": 35},
      {"row": 33, "column": 5, "value": 36},
      {"row": 34, "column": 5, "value": 37},
      {"row": 35, "column": 5, "value": 38},
      {"row": 36, "column": 5, "value": 39},
      {"row": 37, "column": 5, "value": 40},
      {"row": 38, "column": 5, "value": 41},
      {"row": 39, "column": 5, "value": 42},
      {"row": 40, "column": 5, "value": 43},
      {"row": 41, "column": 5, "value": 44},
      {"row": 42, "column": 5, "value": 45},
      {"row": 43, "column": 5, "value": 46},
      {"row": 44, "column": 5, "value": 47},
      {"row": 45, "column": 5, "value": 48},
      {"row": 46, "column": 5, "value": 49},
      {"row": 47, "column": 5, "value": 50},
      {"row": 48, "column": 5, "value": 51},
      {"row": 49, "column": 5, "value": 52},
      {"row": 50, "column": 5, "value": 53},
      {"row": 51, "column": 5, "value": 53},
      {"row": 52, "column": 5, "value": 54},
      {"row": 53, "column": 5, "value": 55},
      {"row": 54, "column": 5, "value": 56},
      {"row": 55, "column": 5, "value": 57},
      {"row": 56, "column": 5, "value": 58},
      {"row": 57, "column": 5, "value": 59},
      {"row": 58, "column": 5, "value": 60},
      {"row": 59, "column": 5, "value": 61},
      {"row": 60, "column": 5, "value": 62},
      {"row": 61, "column": 5, "value": 63},
      {"row": 62, "column": 5, "value": 64},
      {"row": 63, "column": 5, "value": 65},
      {"row": 64, "column": 5, "value": 66},
      {"row": 65, "column": 5, "value": 67},
      {"row": 66, "column": 5, "value": 68},
      {"row": 67, "column": 5, "value": 69},
      {"row": 68, "column": 5, "value": 70},
      {"row": 69, "column": 5, "value": 71},
      {"row": 70, "column": 5, "value": 72},
      {"row": 71, "column": 5, "value": 72},
      {"row": 72, "column": 5, "value": 73},
      {"row": 73, "column": 5, "value": 74},
      {"row": 74, "column": 5, "value": 75},
      {"row": 75, "column": 5, "value": 76},
      {"row": 76, "column": 5, "value": 77},
      {"row": 77, "column": 5, "value": 78},
      {"row": 78, "column": 5, "value": 79},
      {"row": 79, "column": 5, "value": 80},
      {"row": 80, "column": 5, "value": 81},
      {"row": 81, "column": 5, "value": 82},
      {"row": 82, "column": 5, "value": 83},
      {"row": 83, "column": 5, "value": 84},
      {"row": 84, "column": 5, "value": 85},
      {"row": 85, "column": 5, "value": 86},
      {"row": 86, "column": 5, "value": 87},
      {"row": 87, "column": 5, "value": 88},
      {"row": 88, "column": 5, "value": 89},
      {"row": 89, "column": 5, "value": 90},
      {"row": 90, "column": 5, "value": 91},
      {"row": 91, "column": 5, "value": 91},
      {"row": 92, "column": 5, "value": 92},
      {"row": 93, "column": 5, "value": 93},
      {"row": 94, "column": 5, "value": 94},
      {"row": 95, "column": 5, "value": 95},
      {"row": 96, "column": 5, "value": 96},
      {"row": 97, "column": 5, "value": 97},
      {"row": 98, "column": 5, "value": 98},
      {"row": 99, "column": 5, "value": 99},
      {"row": 6, "column": 6, "value": 12},
      {"row": 7, "column": 6, "value": 13},
      {"row": 8, "column": 6, "value": 14},
      {"row": 9, "column": 6, "value": 14},
      {"row": 10, "column": 6, "value": 15},
      {"row": 11, "column": 6, "value": 16},
      {"row": 12, "column": 6, "value": 17},
      {"row": 13, "column": 6, "value": 18},
      {"row": 14, "column": 6, "value": 19},
      {"row": 15, "column": 6, "value": 20},
      {"row": 16, "column": 6, "value": 21},
      {"row": 17, "column": 6, "value": 22},
      {"row": 18, "column": 6, "value": 23},
      {"row": 19, "column": 6, "value": 24},
      {"row": 20, "column": 6, "value": 25},
      {"row": 21, "column": 6, "value": 26},
      {"row": 22, "column": 6, "value": 27},
      {"row": 23, "column": 6, "value": 28},
      {"row": 24, "column": 6, "value": 29},
      {"row": 25, "column": 6, "value": 30},
      {"row": 26, "column": 6, "value": 30},
      {"row": 27, "column": 6, "value": 31},
      {"row": 28, "column": 6, "value": 32},
      {"row": 29, "column": 6, "value": 33},
      {"row": 30, "column": 6, "value": 34},
      {"row": 31, "column": 6, "value": 35},
      {"row": 32, "column": 6, "value": 36},
      {"row": 33, "column": 6, "value": 37},
      {"row": 34, "column": 6, "value": 38},
      {"row": 35, "column": 6, "value": 39},
      {"row": 36, "column": 6, "value": 40},
      {"row": 37, "column": 6, "value": 41},
      {"row": 38, "column": 6, "value": 42},
      {"row": 39, "column": 6, "value": 43},
      {"row": 40, "column": 6, "value": 44},
      {"row": 41, "column": 6, "value": 45},
      {"row": 42, "column": 6, "value": 45},
      {"row": 43, "column": 6, "value": 46},
      {"row": 44, "column": 6, "value": 47},
      {"row": 45, "column": 6, "value": 48},
      {"row": 46, "column": 6, "value": 49},
      {"row": 47, "column": 6, "value": 50},
      {"row": 48, "column": 6, "value": 51},
      {"row": 49, "column": 6, "value": 52},
      {"row": 50, "column": 6, "value": 53},
      {"row": 51, "column": 6, "value": 54},
      {"row": 52, "column": 6, "value": 55},
      {"row": 53, "column": 6, "value": 56},
      {"row": 54, "column": 6, "value": 57},
      {"row": 55, "column": 6, "value": 58},
      {"row": 56, "column": 6, "value": 59},
      {"row": 57, "column": 6, "value": 60},
      {"row": 58, "column": 6, "value": 61},
      {"row": 59, "column": 6, "value": 61},
      {"row": 60, "column": 6, "value": 62},
      {"row": 61, "column": 6, "value": 63},
      {"row": 62, "column": 6, "value": 64},
      {"row": 63, "column": 6, "value": 65},
      {"row": 64, "column": 6, "value": 66},
      {"row": 65, "column": 6, "value": 67},
      {"row": 66, "column": 6, "value": 68},
      {"row": 67, "column": 6, "value": 69},
      {"row": 68, "column": 6, "value": 70},
      {"row": 69, "column": 6, "value": 71},
      {"row": 70, "column": 6, "value": 72},
      {"row": 71, "column": 6, "value": 73},
      {"row": 72, "column": 6, "value": 74},
      {"row": 73, "column": 6, "value": 75},
      {"row": 74, "column": 6, "value": 76},
      {"row": 75, "column": 6, "value": 77},
      {"row": 76, "column": 6, "value": 77},
      {"row": 77, "column": 6, "value": 78},
      {"row": 78, "column": 6, "value": 79},
      {"row": 79, "column": 6, "value": 80},
      {"row": 80, "column": 6, "value": 81},
      {"row": 81, "column": 6, "value": 82},
      {"row": 82, "column": 6, "value": 83},
      {"row": 83, "column": 6, "value": 84},
      {"row": 84, "column": 6, "value": 85},
      {"row": 85, "column": 6, "value": 86},
      {"row": 86, "column": 6, "value": 87},
      {"row": 87, "column": 6, "value": 88},
      {"row": 88, "column": 6, "value": 89},
      {"row": 89, "column": 6, "value": 90},
      {"row": 90, "column": 6, "value": 91},
      {"row": 91, "column": 6, "value": 92},
      {"row": 92, "column": 6, "value": 92},
      {"row": 93, "column": 6, "value": 93},
      {"row": 94, "column": 6, "value": 94},
      {"row": 95, "column": 6, "value": 95},
      {"row": 96, "column": 6, "value": 96},
      {"row": 97, "column": 6, "value": 97},
      {"row": 98, "column": 6, "value": 98},
      {"row": 99, "column": 6, "value": 99},
      {"row": 7, "column": 7, "value": 14},
      {"row": 8, "column": 7, "value": 14},
      {"row": 9, "column": 7, "value": 15},
      {"row": 10, "column": 7, "value": 16},
      {"row": 11, "column": 7, "value": 17},
      {"row": 12, "column": 7, "value": 18},
      {"row": 13, "column": 7, "value": 19},
      {"row": 14, "column": 7, "value": 20},
      {"row": 15, "column": 7, "value": 21},
      {"row": 16, "column": 7, "value": 22},
      {"row": 17, "column": 7, "value": 23},
      {"row": 18, "column": 7, "value": 24},
      {"row": 19, "column": 7, "value": 25},
      {"row": 20, "column": 7, "value": 26},
      {"row": 21, "column": 7, "value": 27},
      {"row": 22, "column": 7, "value": 27},
      {"row": 23, "column": 7, "value": 28},
      {"row": 24, "column": 7, "value": 29},
      {"row": 25, "column": 7, "value": 30},
      {"row": 26, "column": 7, "value": 31},
      {"row": 27, "column": 7, "value": 32},
      {"row": 28, "column": 7, "value": 33},
      {"row": 29, "column": 7, "value": 34},
      {"row": 30, "column": 7, "value": 35},
      {"row": 31, "column": 7, "value": 36},
      {"row": 32, "column": 7, "value": 37},
      {"row": 33, "column": 7, "value": 38},
      {"row": 34, "column": 7, "value": 39},
      {"row": 35, "column": 7, "value": 40},
      {"row": 36, "column": 7, "value": 40},
      {"row": 37, "column": 7, "value": 41},
      {"row": 38, "column": 7, "value": 42},
      {"row": 39, "column": 7, "value": 43},
      {"row": 40, "column": 7, "value": 44},
      {"row": 41, "column": 7, "value": 45},
      {"row": 42, "column": 7, "value": 46},
      {"row": 43, "column": 7, "value": 47},
      {"row": 44, "column": 7, "value": 48},
      {"row": 45, "column": 7, "value": 49},
      {"row": 46, "column": 7, "value": 50},
      {"row": 47, "column": 7, "value": 51},
      {"row": 48, "column": 7, "value": 52},
      {"row": 49, "column": 7, "value": 53},
      {"row": 50, "column": 7, "value": 54},
      {"row": 51, "column": 7, "value": 54},
      {"row": 52, "column": 7, "value": 55},
      {"row": 53, "column": 7, "value": 56},
      {"row": 54, "column": 7, "value": 57},
      {"row": 55, "column": 7, "value": 58},
      {"row": 56, "column": 7, "value": 59},
      {"row": 57, "column": 7, "value": 60},
      {"row": 58, "column": 7, "value": 61},
      {"row": 59, "column": 7, "value": 62},
      {"row": 60, "column": 7, "value": 63},
      {"row": 61, "column": 7, "value": 64},
      {"row": 62, "column": 7, "value": 65},
      {"row": 63, "column": 7, "value": 66},
      {"row": 64, "column": 7, "value": 67},
      {"row": 65, "column": 7, "value": 67},
      {"row": 66, "column": 7, "value": 68},
      {"row": 67, "column": 7, "value": 69},
      {"row": 68, "column": 7, "value": 70},
      {"row": 69, "column": 7, "value": 71},
      {"row": 70, "column": 7, "value": 72},
      {"row": 71, "column": 7, "value": 73},
      {"row": 72, "column": 7, "value": 74},
      {"row": 73, "column": 7, "value": 75},
      {"row": 74, "column": 7, "value": 76},
      {"row": 75, "column": 7, "value": 77},
      {"row": 76, "column": 7, "value": 78},
      {"row": 77, "column": 7, "value": 79},
      {"row": 78, "column": 7, "value": 80},
      {"row": 79, "column": 7, "value": 80},
      {"row": 80, "column": 7, "value": 81},
      {"row": 81, "column": 7, "value": 82},
      {"row": 82, "column": 7, "value": 83},
      {"row": 83, "column": 7, "value": 84},
      {"row": 84, "column": 7, "value": 85},
      {"row": 85, "column": 7, "value": 86},
      {"row": 86, "column": 7, "value": 87},
      {"row": 87, "column": 7, "value": 88},
      {"row": 88, "column": 7, "value": 89},
      {"row": 89, "column": 7, "value": 90},
      {"row": 90, "column": 7, "value": 91},
      {"row": 91, "column": 7, "value": 92},
      {"row": 92, "column": 7, "value": 93},
      {"row": 93, "column": 7, "value": 93},
      {"row": 94, "column": 7, "value": 94},
      {"row": 95, "column": 7, "value": 95},
      {"row": 96, "column": 7, "value": 96},
      {"row": 97, "column": 7, "value": 97},
      {"row": 98, "column": 7, "value": 98},
      {"row": 99, "column": 7, "value": 99},
      {"row": 8, "column": 8, "value": 15},
      {"row": 9, "column": 8, "value": 16},
      {"row": 10, "column": 8, "value": 17},
      {"row": 11, "column": 8, "value": 18},
      {"row": 12, "column": 8, "value": 19},
      {"row": 13, "column": 8, "value": 20},
      {"row": 14, "column": 8, "value": 21},
      {"row": 15, "column": 8, "value": 22},
      {"row": 16, "column": 8, "value": 23},
      {"row": 17, "column": 8, "value": 24},
      {"row": 18, "column": 8, "value": 25},
      {"row": 19, "column": 8, "value": 25},
      {"row": 20, "column": 8, "value": 26},
      {"row": 21, "column": 8, "value": 27},
      {"row": 22, "column": 8, "value": 28},
      {"row": 23, "column": 8, "value": 29},
      {"row": 24, "column": 8, "value": 30},
      {"row": 25, "column": 8, "value": 31},
      {"row": 26, "column": 8, "value": 32},
      {"row": 27, "column": 8, "value": 33},
      {"row": 28, "column": 8, "value": 34},
      {"row": 29, "column": 8, "value": 35},
      {"row": 30, "column": 8, "value": 36},
      {"row": 31, "column": 8, "value": 37},
      {"row": 32, "column": 8, "value": 37},
      {"row": 33, "column": 8, "value": 38},
      {"row": 34, "column": 8, "value": 39},
      {"row": 35, "column": 8, "value": 40},
      {"row": 36, "column": 8, "value": 41},
      {"row": 37, "column": 8, "value": 42},
      {"row": 38, "column": 8, "value": 43},
      {"row": 39, "column": 8, "value": 44},
      {"row": 40, "column": 8, "value": 45},
      {"row": 41, "column": 8, "value": 46},
      {"row": 42, "column": 8, "value": 47},
      {"row": 43, "column": 8, "value": 48},
      {"row": 44, "column": 8, "value": 48},
      {"row": 45, "column": 8, "value": 49},
      {"row": 46, "column": 8, "value": 50},
      {"row": 47, "column": 8, "value": 51},
      {"row": 48, "column": 8, "value": 52},
      {"row": 49, "column": 8, "value": 53},
      {"row": 50, "column": 8, "value": 54},
      {"row": 51, "column": 8, "value": 55},
      {"row": 52, "column": 8, "value": 56},
      {"row": 53, "column": 8, "value": 57},
      {"row": 54, "column": 8, "value": 58},
      {"row": 55, "column": 8, "value": 59},
      {"row": 56, "column": 8, "value": 60},
      {"row": 57, "column": 8, "value": 60},
      {"row": 58, "column": 8, "value": 61},
      {"row": 59, "column": 8, "value": 62},
      {"row": 60, "column": 8, "value": 63},
      {"row": 61, "column": 8, "value": 64},
      {"row": 62, "column": 8, "value": 65},
      {"row": 63, "column": 8, "value": 66},
      {"row": 64, "column": 8, "value": 67},
      {"row": 65, "column": 8, "value": 68},
      {"row": 66, "column": 8, "value": 69},
      {"row": 67, "column": 8, "value": 70},
      {"row": 68, "column": 8, "value": 71},
      {"row": 69, "column": 8, "value": 71},
      {"row": 70, "column": 8, "value": 72},
      {"row": 71, "column": 8, "value": 73},
      {"row": 72, "column": 8, "value": 74},
      {"row": 73, "column": 8, "value": 75},
      {"row": 74, "column": 8, "value": 76},
      {"row": 75, "column": 8, "value": 77},
      {"row": 76, "column": 8, "value": 78},
      {"row": 77, "column": 8, "value": 79},
      {"row": 78, "column": 8, "value": 80},
      {"row": 79, "column": 8, "value": 81},
      {"row": 80, "column": 8, "value": 82},
      {"row": 81, "column": 8, "value": 83},
      {"row": 82, "column": 8, "value": 83},
      {"row": 83, "column": 8, "value": 84},
      {"row": 84, "column": 8, "value": 85},
      {"row": 85, "column": 8, "value": 86},
      {"row": 86, "column": 8, "value": 87},
      {"row": 87, "column": 8, "value": 88},
      {"row": 88, "column": 8, "value": 89},
      {"row": 89, "column": 8, "value": 90},
      {"row": 90, "column": 8, "value": 91},
      {"row": 91, "column": 8, "value": 92},
      {"row": 92, "column": 8, "value": 93},
      {"row": 93, "column": 8, "value": 94},
      {"row": 94, "column": 8, "value": 94},
      {"row": 95, "column": 8, "value": 95},
      {"row": 96, "column": 8, "value": 96},
      {"row": 97, "column": 8, "value": 97},
      {"row": 98, "column": 8, "value": 98},
      {"row": 99, "column": 8, "value": 99},
      {"row": 9, "column": 9, "value": 17},
      {"row": 10, "column": 9, "value": 18},
      {"row": 11, "column": 9, "value": 19},
      {"row": 12, "column": 9, "value": 20},
      {"row": 13, "column": 9, "value": 21},
      {"row": 14, "column": 9, "value": 22},
      {"row": 15, "column": 9, "value": 23},
      {"row": 16, "column": 9, "value": 24},
      {"row": 17, "column": 9, "value": 24},
      {"row": 18, "column": 9, "value": 25},
      {"row": 19, "column": 9, "value": 26},
      {"row": 20, "column": 9, "value": 27},
      {"row": 21, "column": 9, "value": 28},
      {"row": 22, "column": 9, "value": 29},
      {"row": 23, "column": 9, "value": 30},
      {"row": 24, "column": 9, "value": 31},
      {"row": 25, "column": 9, "value": 32},
      {"row": 26, "column": 9, "value": 33},
      {"row": 27, "column": 9, "value": 34},
      {"row": 28, "column": 9, "value": 34},
      {"row": 29, "column": 9, "value": 35},
      {"row": 30, "column": 9, "value": 36},
      {"row": 31, "column": 9, "value": 37},
      {"row": 32, "column": 9, "value": 38},
      {"row": 33, "column": 9, "value": 39},
      {"row": 34, "column": 9, "value": 40},
      {"row": 35, "column": 9, "value": 41},
      {"row": 36, "column": 9, "value": 42},
      {"row": 37, "column": 9, "value": 43},
      {"row": 38, "column": 9, "value": 44},
      {"row": 39, "column": 9, "value": 44},
      {"row": 40, "column": 9, "value": 45},
      {"row": 41, "column": 9, "value": 46},
      {"row": 42, "column": 9, "value": 47},
      {"row": 43, "column": 9, "value": 48},
      {"row": 44, "column": 9, "value": 49},
      {"row": 45, "column": 9, "value": 50},
      {"row": 46, "column": 9, "value": 51},
      {"row": 47, "column": 9, "value": 52},
      {"row": 48, "column": 9, "value": 53},
      {"row": 49, "column": 9, "value": 54},
      {"row": 50, "column": 9, "value": 55},
      {"row": 51, "column": 9, "value": 55},
      {"row": 52, "column": 9, "value": 56},
      {"row": 53, "column": 9, "value": 57},
      {"row": 54, "column": 9, "value": 58},
      {"row": 55, "column": 9, "value": 59},
      {"row": 56, "column": 9, "value": 60},
      {"row": 57, "column": 9, "value": 61},
      {"row": 58, "column": 9, "value": 62},
      {"row": 59, "column": 9, "value": 63},
      {"row": 60, "column": 9, "value": 64},
      {"row": 61, "column": 9, "value": 65},
      {"row": 62, "column": 9, "value": 65},
      {"row": 63, "column": 9, "value": 66},
      {"row": 64, "column": 9, "value": 67},
      {"row": 65, "column": 9, "value": 68},
      {"row": 66, "column": 9, "value": 69},
      {"row": 67, "column": 9, "value": 70},
      {"row": 68, "column": 9, "value": 71},
      {"row": 69, "column": 9, "value": 72},
      {"row": 70, "column": 9, "value": 73},
      {"row": 71, "column": 9, "value": 74},
      {"row": 72, "column": 9, "value": 75},
      {"row": 73, "column": 9, "value": 75},
      {"row": 74, "column": 9, "value": 76},
      {"row": 75, "column": 9, "value": 77},
      {"row": 76, "column": 9, "value": 78},
      {"row": 77, "column": 9, "value": 79},
      {"row": 78, "column": 9, "value": 80},
      {"row": 79, "column": 9, "value": 81},
      {"row": 80, "column": 9, "value": 82},
      {"row": 81, "column": 9, "value": 83},
      {"row": 82, "column": 9, "value": 84},
      {"row": 83, "column": 9, "value": 85},
      {"row": 84, "column": 9, "value": 85},
      {"row": 85, "column": 9, "value": 86},
      {"row": 86, "column": 9, "value": 87},
      {"row": 87, "column": 9, "value": 88},
      {"row": 88, "column": 9, "value": 89},
      {"row": 89, "column": 9, "value": 90},
      {"row": 90, "column": 9, "value": 91},
      {"row": 91, "column": 9, "value": 92},
      {"row": 92, "column": 9, "value": 93},
      {"row": 93, "column": 9, "value": 94},
      {"row": 94, "column": 9, "value": 95},
      {"row": 95, "column": 9, "value": 95},
      {"row": 96, "column": 9, "value": 96},
      {"row": 97, "column": 9, "value": 97},
      {"row": 98, "column": 9, "value": 98},
      {"row": 99, "column": 9, "value": 99},
      {"row": 10, "column": 10, "value": 19},
      {"row": 11, "column": 10, "value": 20},
      {"row": 12, "column": 10, "value": 21},
      {"row": 13, "column": 10, "value": 22},
      {"row": 14, "column": 10, "value": 23},
      {"row": 15, "column": 10, "value": 24},
      {"row": 16, "column": 10, "value": 24},
      {"row": 17, "column": 10, "value": 25},
      {"row": 18, "column": 10, "value": 26},
      {"row": 19, "column": 10, "value": 27},
      {"row": 20, "column": 10, "value": 28},
      {"row": 21, "column": 10, "value": 29},
      {"row": 22, "column": 10, "value": 30},
      {"row": 23, "column": 10, "value": 31},
      {"row": 24, "column": 10, "value": 32},
      {"row": 25, "column": 10, "value": 33},
      {"row": 26, "column": 10, "value": 33},
      {"row": 27, "column": 10, "value": 34},
      {"row": 28, "column": 10, "value": 35},
      {"row": 29, "column": 10, "value": 36},
      {"row": 30, "column": 10, "value": 37},
      {"row": 31, "column": 10, "value": 38},
      {"row": 32, "column": 10, "value": 39},
      {"row": 33, "column": 10, "value": 40},
      {"row": 34, "column": 10, "value": 41},
      {"row": 35, "column": 10, "value": 42},
      {"row": 36, "column": 10, "value": 42},
      {"row": 37, "column": 10, "value": 43},
      {"row": 38, "column": 10, "value": 44},
      {"row": 39, "column": 10, "value": 45},
      {"row": 40, "column": 10, "value": 46},
      {"row": 41, "column": 10, "value": 47},
      {"row": 42, "column": 10, "value": 48},
      {"row": 43, "column": 10, "value": 49},
      {"row": 44, "column": 10, "value": 50},
      {"row": 45, "column": 10, "value": 51},
      {"row": 46, "column": 10, "value": 51},
      {"row": 47, "column": 10, "value": 52},
      {"row": 48, "column": 10, "value": 53},
      {"row": 49, "column": 10, "value": 54},
      {"row": 50, "column": 10, "value": 55},
      {"row": 51, "column": 10, "value": 56},
      {"row": 52, "column": 10, "value": 57},
      {"row": 53, "column": 10, "value": 58},
      {"row": 54, "column": 10, "value": 59},
      {"row": 55, "column": 10, "value": 60},
      {"row": 56, "column": 10, "value": 60},
      {"row": 57, "column": 10, "value": 61},
      {"row": 58, "column": 10, "value": 62},
      {"row": 59, "column": 10, "value": 63},
      {"row": 60, "column": 10, "value": 64},
      {"row": 61, "column": 10, "value": 65},
      {"row": 62, "column": 10, "value": 66},
      {"row": 63, "column": 10, "value": 67},
      {"row": 64, "column": 10, "value": 68},
      {"row": 65, "column": 10, "value": 69},
      {"row": 66, "column": 10, "value": 69},
      {"row": 67, "column": 10, "value": 70},
      {"row": 68, "column": 10, "value": 71},
      {"row": 69, "column": 10, "value": 72},
      {"row": 70, "column": 10, "value": 73},
      {"row": 71, "column": 10, "value": 74},
      {"row": 72, "column": 10, "value": 75},
      {"row": 73, "column": 10, "value": 76},
      {"row": 74, "column": 10, "value": 77},
      {"row": 75, "column": 10, "value": 78},
      {"row": 76, "column": 10, "value": 78},
      {"row": 77, "column": 10, "value": 79},
      {"row": 78, "column": 10, "value": 80},
      {"row": 79, "column": 10, "value": 81},
      {"row": 80, "column": 10, "value": 82},
      {"row": 81, "column": 10, "value": 83},
      {"row": 82, "column": 10, "value": 84},
      {"row": 83, "column": 10, "value": 85},
      {"row": 84, "column": 10, "value": 86},
      {"row": 85, "column": 10, "value": 87},
      {"row": 86, "column": 10, "value": 87},
      {"row": 87, "column": 10, "value": 88},
      {"row": 88, "column": 10, "value": 89},
      {"row": 89, "column": 10, "value": 90},
      {"row": 90, "column": 10, "value": 91},
      {"row": 91, "column": 10, "value": 92},
      {"row": 92, "column": 10, "value": 93},
      {"row": 93, "column": 10, "value": 94},
      {"row": 94, "column": 10, "value": 95},
      {"row": 95, "column": 10, "value": 96},
      {"row": 96, "column": 10, "value": 96},
      {"row": 97, "column": 10, "value": 97},
      {"row": 98, "column": 10, "value": 98},
      {"row": 99, "column": 10, "value": 99},
      {"row": 11, "column": 11, "value": 21},
      {"row": 12, "column": 11, "value": 22},
      {"row": 13, "column": 11, "value": 23},
      {"row": 14, "column": 11, "value": 23},
      {"row": 15, "column": 11, "value": 24},
      {"row": 16, "column": 11, "value": 25},
      {"row": 17, "column": 11, "value": 26},
      {"row": 18, "column": 11, "value": 27},
      {"row": 19, "column": 11, "value": 28},
      {"row": 20, "column": 11, "value": 29},
      {"row": 21, "column": 11, "value": 30},
      {"row": 22, "column": 11, "value": 31},
      {"row": 23, "column": 11, "value": 31},
      {"row": 24, "column": 11, "value": 32},
      {"row": 25, "column": 11, "value": 33},
      {"row": 26, "column": 11, "value": 34},
      {"row": 27, "column": 11, "value": 35},
      {"row": 28, "column": 11, "value": 36},
      {"row": 29, "column": 11, "value": 37},
      {"row": 30, "column": 11, "value": 38},
      {"row": 31, "column": 11, "value": 39},
      {"row": 32, "column": 11, "value": 39},
      {"row": 33, "column": 11, "value": 40},
      {"row": 34, "column": 11, "value": 41},
      {"row": 35, "column": 11, "value": 42},
      {"row": 36, "column": 11, "value": 43},
      {"row": 37, "column": 11, "value": 44},
      {"row": 38, "column": 11, "value": 45},
      {"row": 39, "column": 11, "value": 46},
      {"row": 40, "column": 11, "value": 47},
      {"row": 41, "column": 11, "value": 47},
      {"row": 42, "column": 11, "value": 48},
      {"row": 43, "column": 11, "value": 49},
      {"row": 44, "column": 11, "value": 50},
      {"row": 45, "column": 11, "value": 51},
      {"row": 46, "column": 11, "value": 52},
      {"row": 47, "column": 11, "value": 53},
      {"row": 48, "column": 11, "value": 54},
      {"row": 49, "column": 11, "value": 55},
      {"row": 50, "column": 11, "value": 56},
      {"row": 51, "column": 11, "value": 56},
      {"row": 52, "column": 11, "value": 57},
      {"row": 53, "column": 11, "value": 58},
      {"row": 54, "column": 11, "value": 59},
      {"row": 55, "column": 11, "value": 60},
      {"row": 56, "column": 11, "value": 61},
      {"row": 57, "column": 11, "value": 62},
      {"row": 58, "column": 11, "value": 63},
      {"row": 59, "column": 11, "value": 64},
      {"row": 60, "column": 11, "value": 64},
      {"row": 61, "column": 11, "value": 65},
      {"row": 62, "column": 11, "value": 66},
      {"row": 63, "column": 11, "value": 67},
      {"row": 64, "column": 11, "value": 68},
      {"row": 65, "column": 11, "value": 69},
      {"row": 66, "column": 11, "value": 70},
      {"row": 67, "column": 11, "value": 71},
      {"row": 68, "column": 11, "value": 72},
      {"row": 69, "column": 11, "value": 72},
      {"row": 70, "column": 11, "value": 73},
      {"row": 71, "column": 11, "value": 74},
      {"row": 72, "column": 11, "value": 75},
      {"row": 73, "column": 11, "value": 76},
      {"row": 74, "column": 11, "value": 77},
      {"row": 75, "column": 11, "value": 78},
      {"row": 76, "column": 11, "value": 79},
      {"row": 77, "column": 11, "value": 80},
      {"row": 78, "column": 11, "value": 80},
      {"row": 79, "column": 11, "value": 81},
      {"row": 80, "column": 11, "value": 82},
      {"row": 81, "column": 11, "value": 83},
      {"row": 82, "column": 11, "value": 84},
      {"row": 83, "column": 11, "value": 85},
      {"row": 84, "column": 11, "value": 86},
      {"row": 85, "column": 11, "value": 87},
      {"row": 86, "column": 11, "value": 88},
      {"row": 87, "column": 11, "value": 88},
      {"row": 88, "column": 11, "value": 89},
      {"row": 89, "column": 11, "value": 90},
      {"row": 90, "column": 11, "value": 91},
      {"row": 91, "column": 11, "value": 92},
      {"row": 92, "column": 11, "value": 93},
      {"row": 93, "column": 11, "value": 94},
      {"row": 94, "column": 11, "value": 95},
      {"row": 95, "column": 11, "value": 96},
      {"row": 96, "column": 11, "value": 97},
      {"row": 97, "column": 11, "value": 97},
      {"row": 98, "column": 11, "value": 98},
      {"row": 99, "column": 11, "value": 99},
      {"row": 12, "column": 12, "value": 23},
      {"row": 13, "column": 12, "value": 23},
      {"row": 14, "column": 12, "value": 24},
      {"row": 15, "column": 12, "value": 25},
      {"row": 16, "column": 12, "value": 26},
      {"row": 17, "column": 12, "value": 27},
      {"row": 18, "column": 12, "value": 28},
      {"row": 19, "column": 12, "value": 29},
      {"row": 20, "column": 12, "value": 30},
      {"row": 21, "column": 12, "value": 30},
      {"row": 22, "column": 12, "value": 31},
      {"row": 23, "column": 12, "value": 32},
      {"row": 24, "column": 12, "value": 33},
      {"row": 25, "column": 12, "value": 34},
      {"row": 26, "column": 12, "value": 35},
      {"row": 27, "column": 12, "value": 36},
      {"row": 28, "column": 12, "value": 37},
      {"row": 29, "column": 12, "value": 38},
      {"row": 30, "column": 12, "value": 38},
      {"row": 31, "column": 12, "value": 39},
      {"row": 32, "column": 12, "value": 40},
      {"row": 33, "column": 12, "value": 41},
      {"row": 34, "column": 12, "value": 42},
      {"row": 35, "column": 12, "value": 43},
      {"row": 36, "column": 12, "value": 44},
      {"row": 37, "column": 12, "value": 45},
      {"row": 38, "column": 12, "value": 45},
      {"row": 39, "column": 12, "value": 46},
      {"row": 40, "column": 12, "value": 47},
      {"row": 41, "column": 12, "value": 48},
      {"row": 42, "column": 12, "value": 49},
      {"row": 43, "column": 12, "value": 50},
      {"row": 44, "column": 12, "value": 51},
      {"row": 45, "column": 12, "value": 52},
      {"row": 46, "column": 12, "value": 52},
      {"row": 47, "column": 12, "value": 53},
      {"row": 48, "column": 12, "value": 54},
      {"row": 49, "column": 12, "value": 55},
      {"row": 50, "column": 12, "value": 56},
      {"row": 51, "column": 12, "value": 57},
      {"row": 52, "column": 12, "value": 58},
      {"row": 53, "column": 12, "value": 59},
      {"row": 54, "column": 12, "value": 59},
      {"row": 55, "column": 12, "value": 60},
      {"row": 56, "column": 12, "value": 61},
      {"row": 57, "column": 12, "value": 62},
      {"row": 58, "column": 12, "value": 63},
      {"row": 59, "column": 12, "value": 64},
      {"row": 60, "column": 12, "value": 65},
      {"row": 61, "column": 12, "value": 66},
      {"row": 62, "column": 12, "value": 67},
      {"row": 63, "column": 12, "value": 67},
      {"row": 64, "column": 12, "value": 68},
      {"row": 65, "column": 12, "value": 69},
      {"row": 66, "column": 12, "value": 70},
      {"row": 67, "column": 12, "value": 71},
      {"row": 68, "column": 12, "value": 72},
      {"row": 69, "column": 12, "value": 73},
      {"row": 70, "column": 12, "value": 74},
      {"row": 71, "column": 12, "value": 74},
      {"row": 72, "column": 12, "value": 75},
      {"row": 73, "column": 12, "value": 76},
      {"row": 74, "column": 12, "value": 77},
      {"row": 75, "column": 12, "value": 78},
      {"row": 76, "column": 12, "value": 79},
      {"row": 77, "column": 12, "value": 80},
      {"row": 78, "column": 12, "value": 81},
      {"row": 79, "column": 12, "value": 82},
      {"row": 80, "column": 12, "value": 82},
      {"row": 81, "column": 12, "value": 83},
      {"row": 82, "column": 12, "value": 84},
      {"row": 83, "column": 12, "value": 85},
      {"row": 84, "column": 12, "value": 86},
      {"row": 85, "column": 12, "value": 87},
      {"row": 86, "column": 12, "value": 88},
      {"row": 87, "column": 12, "value": 89},
      {"row": 88, "column": 12, "value": 89},
      {"row": 89, "column": 12, "value": 90},
      {"row": 90, "column": 12, "value": 91},
      {"row": 91, "column": 12, "value": 92},
      {"row": 92, "column": 12, "value": 93},
      {"row": 93, "column": 12, "value": 94},
      {"row": 94, "column": 12, "value": 95},
      {"row": 95, "column": 12, "value": 96},
      {"row": 96, "column": 12, "value": 96},
      {"row": 97, "column": 12, "value": 97},
      {"row": 98, "column": 12, "value": 98},
      {"row": 99, "column": 12, "value": 99},
      {"row": 13, "column": 13, "value": 24},
      {"row": 14, "column": 13, "value": 25},
      {"row": 15, "column": 13, "value": 26},
      {"row": 16, "column": 13, "value": 27},
      {"row": 17, "column": 13, "value": 28},
      {"row": 18, "column": 13, "value": 29},
      {"row": 19, "column": 13, "value": 30},
      {"row": 20, "column": 13, "value": 30},
      {"row": 21, "column": 13, "value": 31},
      {"row": 22, "column": 13, "value": 32},
      {"row": 23, "column": 13, "value": 33},
      {"row": 24, "column": 13, "value": 34},
      {"row": 25, "column": 13, "value": 35},
      {"row": 26, "column": 13, "value": 36},
      {"row": 27, "column": 13, "value": 36},
      {"row": 28, "column": 13, "value": 37},
      {"row": 29, "column": 13, "value": 38},
      {"row": 30, "column": 13, "value": 39},
      {"row": 31, "column": 13, "value": 40},
      {"row": 32, "column": 13, "value": 41},
      {"row": 33, "column": 13, "value": 42},
      {"row": 34, "column": 13, "value": 43},
      {"row": 35, "column": 13, "value": 43},
      {"row": 36, "column": 13, "value": 44},
      {"row": 37, "column": 13, "value": 45},
      {"row": 38, "column": 13, "value": 46},
      {"row": 39, "column": 13, "value": 47},
      {"row": 40, "column": 13, "value": 48},
      {"row": 41, "column": 13, "value": 49},
      {"row": 42, "column": 13, "value": 50},
      {"row": 43, "column": 13, "value": 50},
      {"row": 44, "column": 13, "value": 51},
      {"row": 45, "column": 13, "value": 52},
      {"row": 46, "column": 13, "value": 53},
      {"row": 47, "column": 13, "value": 54},
      {"row": 48, "column": 13, "value": 55},
      {"row": 49, "column": 13, "value": 56},
      {"row": 50, "column": 13, "value": 57},
      {"row": 51, "column": 13, "value": 57},
      {"row": 52, "column": 13, "value": 58},
      {"row": 53, "column": 13, "value": 59},
      {"row": 54, "column": 13, "value": 60},
      {"row": 55, "column": 13, "value": 61},
      {"row": 56, "column": 13, "value": 62},
      {"row": 57, "column": 13, "value": 63},
      {"row": 58, "column": 13, "value": 63},
      {"row": 59, "column": 13, "value": 64},
      {"row": 60, "column": 13, "value": 65},
      {"row": 61, "column": 13, "value": 66},
      {"row": 62, "column": 13, "value": 67},
      {"row": 63, "column": 13, "value": 68},
      {"row": 64, "column": 13, "value": 69},
      {"row": 65, "column": 13, "value": 70},
      {"row": 66, "column": 13, "value": 70},
      {"row": 67, "column": 13, "value": 71},
      {"row": 68, "column": 13, "value": 72},
      {"row": 69, "column": 13, "value": 73},
      {"row": 70, "column": 13, "value": 74},
      {"row": 71, "column": 13, "value": 75},
      {"row": 72, "column": 13, "value": 76},
      {"row": 73, "column": 13, "value": 77},
      {"row": 74, "column": 13, "value": 77},
      {"row": 75, "column": 13, "value": 78},
      {"row": 76, "column": 13, "value": 79},
      {"row": 77, "column": 13, "value": 80},
      {"row": 78, "column": 13, "value": 81},
      {"row": 79, "column": 13, "value": 82},
      {"row": 80, "column": 13, "value": 83},
      {"row": 81, "column": 13, "value": 83},
      {"row": 82, "column": 13, "value": 84},
      {"row": 83, "column": 13, "value": 85},
      {"row": 84, "column": 13, "value": 86},
      {"row": 85, "column": 13, "value": 87},
      {"row": 86, "column": 13, "value": 88},
      {"row": 87, "column": 13, "value": 89},
      {"row": 88, "column": 13, "value": 90},
      {"row": 89, "column": 13, "value": 90},
      {"row": 90, "column": 13, "value": 91},
      {"row": 91, "column": 13, "value": 92},
      {"row": 92, "column": 13, "value": 93},
      {"row": 93, "column": 13, "value": 94},
      {"row": 94, "column": 13, "value": 95},
      {"row": 95, "column": 13, "value": 96},
      {"row": 96, "column": 13, "value": 97},
      {"row": 97, "column": 13, "value": 97},
      {"row": 98, "column": 13, "value": 98},
      {"row": 99, "column": 13, "value": 99},
      {"row": 14, "column": 14, "value": 26},
      {"row": 15, "column": 14, "value": 27},
      {"row": 16, "column": 14, "value": 28},
      {"row": 17, "column": 14, "value": 29},
      {"row": 18, "column": 14, "value": 29},
      {"row": 19, "column": 14, "value": 30},
      {"row": 20, "column": 14, "value": 31},
      {"row": 21, "column": 14, "value": 32},
      {"row": 22, "column": 14, "value": 33},
      {"row": 23, "column": 14, "value": 34},
      {"row": 24, "column": 14, "value": 35},
      {"row": 25, "column": 14, "value": 36},
      {"row": 26, "column": 14, "value": 36},
      {"row": 27, "column": 14, "value": 37},
      {"row": 28, "column": 14, "value": 38},
      {"row": 29, "column": 14, "value": 39},
      {"row": 30, "column": 14, "value": 40},
      {"row": 31, "column": 14, "value": 41},
      {"row": 32, "column": 14, "value": 42},
      {"row": 33, "column": 14, "value": 42},
      {"row": 34, "column": 14, "value": 43},
      {"row": 35, "column": 14, "value": 44},
      {"row": 36, "column": 14, "value": 45},
      {"row": 37, "column": 14, "value": 46},
      {"row": 38, "column": 14, "value": 47},
      {"row": 39, "column": 14, "value": 48},
      {"row": 40, "column": 14, "value": 48},
      {"row": 41, "column": 14, "value": 49},
      {"row": 42, "column": 14, "value": 50},
      {"row": 43, "column": 14, "value": 51},
      {"row": 44, "column": 14, "value": 52},
      {"row": 45, "column": 14, "value": 53},
      {"row": 46, "column": 14, "value": 54},
      {"row": 47, "column": 14, "value": 54},
      {"row": 48, "column": 14, "value": 55},
      {"row": 49, "column": 14, "value": 56},
      {"row": 50, "column": 14, "value": 57},
      {"row": 51, "column": 14, "value": 58},
      {"row": 52, "column": 14, "value": 59},
      {"row": 53, "column": 14, "value": 60},
      {"row": 54, "column": 14, "value": 60},
      {"row": 55, "column": 14, "value": 61},
      {"row": 56, "column": 14, "value": 62},
      {"row": 57, "column": 14, "value": 63},
      {"row": 58, "column": 14, "value": 64},
      {"row": 59, "column": 14, "value": 65},
      {"row": 60, "column": 14, "value": 66},
      {"row": 61, "column": 14, "value": 66},
      {"row": 62, "column": 14, "value": 67},
      {"row": 63, "column": 14, "value": 68},
      {"row": 64, "column": 14, "value": 69},
      {"row": 65, "column": 14, "value": 70},
      {"row": 66, "column": 14, "value": 71},
      {"row": 67, "column": 14, "value": 72},
      {"row": 68, "column": 14, "value": 72},
      {"row": 69, "column": 14, "value": 73},
      {"row": 70, "column": 14, "value": 74},
      {"row": 71, "column": 14, "value": 75},
      {"row": 72, "column": 14, "value": 76},
      {"row": 73, "column": 14, "value": 77},
      {"row": 74, "column": 14, "value": 78},
      {"row": 75, "column": 14, "value": 79},
      {"row": 76, "column": 14, "value": 79},
      {"row": 77, "column": 14, "value": 80},
      {"row": 78, "column": 14, "value": 81},
      {"row": 79, "column": 14, "value": 82},
      {"row": 80, "column": 14, "value": 83},
      {"row": 81, "column": 14, "value": 84},
      {"row": 82, "column": 14, "value": 85},
      {"row": 83, "column": 14, "value": 85},
      {"row": 84, "column": 14, "value": 86},
      {"row": 85, "column": 14, "value": 87},
      {"row": 86, "column": 14, "value": 88},
      {"row": 87, "column": 14, "value": 89},
      {"row": 88, "column": 14, "value": 90},
      {"row": 89, "column": 14, "value": 91},
      {"row": 90, "column": 14, "value": 91},
      {"row": 91, "column": 14, "value": 92},
      {"row": 92, "column": 14, "value": 93},
      {"row": 93, "column": 14, "value": 94},
      {"row": 94, "column": 14, "value": 95},
      {"row": 95, "column": 14, "value": 96},
      {"row": 96, "column": 14, "value": 97},
      {"row": 97, "column": 14, "value": 97},
      {"row": 98, "column": 14, "value": 98},
      {"row": 99, "column": 14, "value": 99},
      {"row": 15, "column": 15, "value": 28},
      {"row": 16, "column": 15, "value": 29},
      {"row": 17, "column": 15, "value": 29},
      {"row": 18, "column": 15, "value": 30},
      {"row": 19, "column": 15, "value": 31},
      {"row": 20, "column": 15, "value": 32},
      {"row": 21, "column": 15, "value": 33},
      {"row": 22, "column": 15, "value": 34},
      {"row": 23, "column": 15, "value": 35},
      {"row": 24, "column": 15, "value": 35},
      {"row": 25, "column": 15, "value": 36},
      {"row": 26, "column": 15, "value": 37},
      {"row": 27, "column": 15, "value": 38},
      {"row": 28, "column": 15, "value": 39},
      {"row": 29, "column": 15, "value": 40},
      {"row": 30, "column": 15, "value": 41},
      {"row": 31, "column": 15, "value": 41},
      {"row": 32, "column": 15, "value": 42},
      {"row": 33, "column": 15, "value": 43},
      {"row": 34, "column": 15, "value": 44},
      {"row": 35, "column": 15, "value": 45},
      {"row": 36, "column": 15, "value": 46},
      {"row": 37, "column": 15, "value": 46},
      {"row": 38, "column": 15, "value": 47},
      {"row": 39, "column": 15, "value": 48},
      {"row": 40, "column": 15, "value": 49},
      {"row": 41, "column": 15, "value": 50},
      {"row": 42, "column": 15, "value": 51},
      {"row": 43, "column": 15, "value": 52},
      {"row": 44, "column": 15, "value": 52},
      {"row": 45, "column": 15, "value": 53},
      {"row": 46, "column": 15, "value": 54},
      {"row": 47, "column": 15, "value": 55},
      {"row": 48, "column": 15, "value": 56},
      {"row": 49, "column": 15, "value": 57},
      {"row": 50, "column": 15, "value": 58},
      {"row": 51, "column": 15, "value": 58},
      {"row": 52, "column": 15, "value": 59},
      {"row": 53, "column": 15, "value": 60},
      {"row": 54, "column": 15, "value": 61},
      {"row": 55, "column": 15, "value": 62},
      {"row": 56, "column": 15, "value": 63},
      {"row": 57, "column": 15, "value": 63},
      {"row": 58, "column": 15, "value": 64},
      {"row": 59, "column": 15, "value": 65},
      {"row": 60, "column": 15, "value": 66},
      {"row": 61, "column": 15, "value": 67},
      {"row": 62, "column": 15, "value": 68},
      {"row": 63, "column": 15, "value": 69},
      {"row": 64, "column": 15, "value": 69},
      {"row": 65, "column": 15, "value": 70},
      {"row": 66, "column": 15, "value": 71},
      {"row": 67, "column": 15, "value": 72},
      {"row": 68, "column": 15, "value": 73},
      {"row": 69, "column": 15, "value": 74},
      {"row": 70, "column": 15, "value": 75},
      {"row": 71, "column": 15, "value": 75},
      {"row": 72, "column": 15, "value": 76},
      {"row": 73, "column": 15, "value": 77},
      {"row": 74, "column": 15, "value": 78},
      {"row": 75, "column": 15, "value": 79},
      {"row": 76, "column": 15, "value": 80},
      {"row": 77, "column": 15, "value": 80},
      {"row": 78, "column": 15, "value": 81},
      {"row": 79, "column": 15, "value": 82},
      {"row": 80, "column": 15, "value": 83},
      {"row": 81, "column": 15, "value": 84},
      {"row": 82, "column": 15, "value": 85},
      {"row": 83, "column": 15, "value": 86},
      {"row": 84, "column": 15, "value": 86},
      {"row": 85, "column": 15, "value": 87},
      {"row": 86, "column": 15, "value": 88},
      {"row": 87, "column": 15, "value": 89},
      {"row": 88, "column": 15, "value": 90},
      {"row": 89, "column": 15, "value": 91},
      {"row": 90, "column": 15, "value": 92},
      {"row": 91, "column": 15, "value": 92},
      {"row": 92, "column": 15, "value": 93},
      {"row": 93, "column": 15, "value": 94},
      {"row": 94, "column": 15, "value": 95},
      {"row": 95, "column": 15, "value": 96},
      {"row": 96, "column": 15, "value": 97},
      {"row": 97, "column": 15, "value": 97},
      {"row": 98, "column": 15, "value": 98},
      {"row": 99, "column": 15, "value": 99},
      {"row": 16, "column": 16, "value": 29},
      {"row": 17, "column": 16, "value": 30},
      {"row": 18, "column": 16, "value": 31},
      {"row": 19, "column": 16, "value": 32},
      {"row": 20, "column": 16, "value": 33},
      {"row": 21, "column": 16, "value": 34},
      {"row": 22, "column": 16, "value": 34},
      {"row": 23, "column": 16, "value": 35},
      {"row": 24, "column": 16, "value": 36},
      {"row": 25, "column": 16, "value": 37},
      {"row": 26, "column": 16, "value": 38},
      {"row": 27, "column": 16, "value": 39},
      {"row": 28, "column": 16, "value": 40},
      {"row": 29, "column": 16, "value": 40},
      {"row": 30, "column": 16, "value": 41},
      {"row": 31, "column": 16, "value": 42},
      {"row": 32, "column": 16, "value": 43},
      {"row": 33, "column": 16, "value": 44},
      {"row": 34, "column": 16, "value": 45},
      {"row": 35, "column": 16, "value": 45},
      {"row": 36, "column": 16, "value": 46},
      {"row": 37, "column": 16, "value": 47},
      {"row": 38, "column": 16, "value": 48},
      {"row": 39, "column": 16, "value": 49},
      {"row": 40, "column": 16, "value": 50},
      {"row": 41, "column": 16, "value": 50},
      {"row": 42, "column": 16, "value": 51},
      {"row": 43, "column": 16, "value": 52},
      {"row": 44, "column": 16, "value": 53},
      {"row": 45, "column": 16, "value": 54},
      {"row": 46, "column": 16, "value": 55},
      {"row": 47, "column": 16, "value": 55},
      {"row": 48, "column": 16, "value": 56},
      {"row": 49, "column": 16, "value": 57},
      {"row": 50, "column": 16, "value": 58},
      {"row": 51, "column": 16, "value": 59},
      {"row": 52, "column": 16, "value": 60},
      {"row": 53, "column": 16, "value": 61},
      {"row": 54, "column": 16, "value": 61},
      {"row": 55, "column": 16, "value": 62},
      {"row": 56, "column": 16, "value": 63},
      {"row": 57, "column": 16, "value": 64},
      {"row": 58, "column": 16, "value": 65},
      {"row": 59, "column": 16, "value": 66},
      {"row": 60, "column": 16, "value": 66},
      {"row": 61, "column": 16, "value": 67},
      {"row": 62, "column": 16, "value": 68},
      {"row": 63, "column": 16, "value": 69},
      {"row": 64, "column": 16, "value": 70},
      {"row": 65, "column": 16, "value": 71},
      {"row": 66, "column": 16, "value": 71},
      {"row": 67, "column": 16, "value": 72},
      {"row": 68, "column": 16, "value": 73},
      {"row": 69, "column": 16, "value": 74},
      {"row": 70, "column": 16, "value": 75},
      {"row": 71, "column": 16, "value": 76},
      {"row": 72, "column": 16, "value": 76},
      {"row": 73, "column": 16, "value": 77},
      {"row": 74, "column": 16, "value": 78},
      {"row": 75, "column": 16, "value": 79},
      {"row": 76, "column": 16, "value": 80},
      {"row": 77, "column": 16, "value": 81},
      {"row": 78, "column": 16, "value": 82},
      {"row": 79, "column": 16, "value": 82},
      {"row": 80, "column": 16, "value": 83},
      {"row": 81, "column": 16, "value": 84},
      {"row": 82, "column": 16, "value": 85},
      {"row": 83, "column": 16, "value": 86},
      {"row": 84, "column": 16, "value": 87},
      {"row": 85, "column": 16, "value": 87},
      {"row": 86, "column": 16, "value": 88},
      {"row": 87, "column": 16, "value": 89},
      {"row": 88, "column": 16, "value": 90},
      {"row": 89, "column": 16, "value": 91},
      {"row": 90, "column": 16, "value": 92},
      {"row": 91, "column": 16, "value": 92},
      {"row": 92, "column": 16, "value": 93},
      {"row": 93, "column": 16, "value": 94},
      {"row": 94, "column": 16, "value": 95},
      {"row": 95, "column": 16, "value": 96},
      {"row": 96, "column": 16, "value": 97},
      {"row": 97, "column": 16, "value": 97},
      {"row": 98, "column": 16, "value": 98},
      {"row": 99, "column": 16, "value": 99},
      {"row": 17, "column": 17, "value": 31},
      {"row": 18, "column": 17, "value": 32},
      {"row": 19, "column": 17, "value": 33},
      {"row": 20, "column": 17, "value": 34},
      {"row": 21, "column": 17, "value": 34},
      {"row": 22, "column": 17, "value": 35},
      {"row": 23, "column": 17, "value": 36},
      {"row": 24, "column": 17, "value": 37},
      {"row": 25, "column": 17, "value": 38},
      {"row": 26, "column": 17, "value": 39},
      {"row": 27, "column": 17, "value": 39},
      {"row": 28, "column": 17, "value": 40},
      {"row": 29, "column": 17, "value": 41},
      {"row": 30, "column": 17, "value": 42},
      {"row": 31, "column": 17, "value": 43},
      {"row": 32, "column": 17, "value": 44},
      {"row": 33, "column": 17, "value": 44},
      {"row": 34, "column": 17, "value": 45},
      {"row": 35, "column": 17, "value": 46},
      {"row": 36, "column": 17, "value": 47},
      {"row": 37, "column": 17, "value": 48},
      {"row": 38, "column": 17, "value": 49},
      {"row": 39, "column": 17, "value": 49},
      {"row": 40, "column": 17, "value": 50},
      {"row": 41, "column": 17, "value": 51},
      {"row": 42, "column": 17, "value": 52},
      {"row": 43, "column": 17, "value": 53},
      {"row": 44, "column": 17, "value": 54},
      {"row": 45, "column": 17, "value": 54},
      {"row": 46, "column": 17, "value": 55},
      {"row": 47, "column": 17, "value": 56},
      {"row": 48, "column": 17, "value": 57},
      {"row": 49, "column": 17, "value": 58},
      {"row": 50, "column": 17, "value": 59},
      {"row": 51, "column": 17, "value": 59},
      {"row": 52, "column": 17, "value": 60},
      {"row": 53, "column": 17, "value": 61},
      {"row": 54, "column": 17, "value": 62},
      {"row": 55, "column": 17, "value": 63},
      {"row": 56, "column": 17, "value": 63},
      {"row": 57, "column": 17, "value": 64},
      {"row": 58, "column": 17, "value": 65},
      {"row": 59, "column": 17, "value": 66},
      {"row": 60, "column": 17, "value": 67},
      {"row": 61, "column": 17, "value": 68},
      {"row": 62, "column": 17, "value": 68},
      {"row": 63, "column": 17, "value": 69},
      {"row": 64, "column": 17, "value": 70},
      {"row": 65, "column": 17, "value": 71},
      {"row": 66, "column": 17, "value": 72},
      {"row": 67, "column": 17, "value": 73},
      {"row": 68, "column": 17, "value": 73},
      {"row": 69, "column": 17, "value": 74},
      {"row": 70, "column": 17, "value": 75},
      {"row": 71, "column": 17, "value": 76},
      {"row": 72, "column": 17, "value": 77},
      {"row": 73, "column": 17, "value": 78},
      {"row": 74, "column": 17, "value": 78},
      {"row": 75, "column": 17, "value": 79},
      {"row": 76, "column": 17, "value": 80},
      {"row": 77, "column": 17, "value": 81},
      {"row": 78, "column": 17, "value": 82},
      {"row": 79, "column": 17, "value": 83},
      {"row": 80, "column": 17, "value": 83},
      {"row": 81, "column": 17, "value": 84},
      {"row": 82, "column": 17, "value": 85},
      {"row": 83, "column": 17, "value": 86},
      {"row": 84, "column": 17, "value": 87},
      {"row": 85, "column": 17, "value": 88},
      {"row": 86, "column": 17, "value": 88},
      {"row": 87, "column": 17, "value": 89},
      {"row": 88, "column": 17, "value": 90},
      {"row": 89, "column": 17, "value": 91},
      {"row": 90, "column": 17, "value": 92},
      {"row": 91, "column": 17, "value": 93},
      {"row": 92, "column": 17, "value": 93},
      {"row": 93, "column": 17, "value": 94},
      {"row": 94, "column": 17, "value": 95},
      {"row": 95, "column": 17, "value": 96},
      {"row": 96, "column": 17, "value": 97},
      {"row": 97, "column": 17, "value": 98},
      {"row": 98, "column": 17, "value": 98},
      {"row": 99, "column": 17, "value": 99},
      {"row": 18, "column": 18, "value": 33},
      {"row": 19, "column": 18, "value": 34},
      {"row": 20, "column": 18, "value": 34},
      {"row": 21, "column": 18, "value": 35},
      {"row": 22, "column": 18, "value": 36},
      {"row": 23, "column": 18, "value": 37},
      {"row": 24, "column": 18, "value": 38},
      {"row": 25, "column": 18, "value": 39},
      {"row": 26, "column": 18, "value": 39},
      {"row": 27, "column": 18, "value": 40},
      {"row": 28, "column": 18, "value": 41},
      {"row": 29, "column": 18, "value": 42},
      {"row": 30, "column": 18, "value": 43},
      {"row": 31, "column": 18, "value": 43},
      {"row": 32, "column": 18, "value": 44},
      {"row": 33, "column": 18, "value": 45},
      {"row": 34, "column": 18, "value": 46},
      {"row": 35, "column": 18, "value": 47},
      {"row": 36, "column": 18, "value": 48},
      {"row": 37, "column": 18, "value": 48},
      {"row": 38, "column": 18, "value": 49},
      {"row": 39, "column": 18, "value": 50},
      {"row": 40, "column": 18, "value": 51},
      {"row": 41, "column": 18, "value": 52},
      {"row": 42, "column": 18, "value": 52},
      {"row": 43, "column": 18, "value": 53},
      {"row": 44, "column": 18, "value": 54},
      {"row": 45, "column": 18, "value": 55},
      {"row": 46, "column": 18, "value": 56},
      {"row": 47, "column": 18, "value": 57},
      {"row": 48, "column": 18, "value": 57},
      {"row": 49, "column": 18, "value": 58},
      {"row": 50, "column": 18, "value": 59},
      {"row": 51, "column": 18, "value": 60},
      {"row": 52, "column": 18, "value": 61},
      {"row": 53, "column": 18, "value": 61},
      {"row": 54, "column": 18, "value": 62},
      {"row": 55, "column": 18, "value": 63},
      {"row": 56, "column": 18, "value": 64},
      {"row": 57, "column": 18, "value": 65},
      {"row": 58, "column": 18, "value": 66},
      {"row": 59, "column": 18, "value": 66},
      {"row": 60, "column": 18, "value": 67},
      {"row": 61, "column": 18, "value": 68},
      {"row": 62, "column": 18, "value": 69},
      {"row": 63, "column": 18, "value": 70},
      {"row": 64, "column": 18, "value": 70},
      {"row": 65, "column": 18, "value": 71},
      {"row": 66, "column": 18, "value": 72},
      {"row": 67, "column": 18, "value": 73},
      {"row": 68, "column": 18, "value": 74},
      {"row": 69, "column": 18, "value": 75},
      {"row": 70, "column": 18, "value": 75},
      {"row": 71, "column": 18, "value": 76},
      {"row": 72, "column": 18, "value": 77},
      {"row": 73, "column": 18, "value": 78},
      {"row": 74, "column": 18, "value": 79},
      {"row": 75, "column": 18, "value": 80},
      {"row": 76, "column": 18, "value": 80},
      {"row": 77, "column": 18, "value": 81},
      {"row": 78, "column": 18, "value": 82},
      {"row": 79, "column": 18, "value": 83},
      {"row": 80, "column": 18, "value": 84},
      {"row": 81, "column": 18, "value": 84},
      {"row": 82, "column": 18, "value": 85},
      {"row": 83, "column": 18, "value": 86},
      {"row": 84, "column": 18, "value": 87},
      {"row": 85, "column": 18, "value": 88},
      {"row": 86, "column": 18, "value": 89},
      {"row": 87, "column": 18, "value": 89},
      {"row": 88, "column": 18, "value": 90},
      {"row": 89, "column": 18, "value": 91},
      {"row": 90, "column": 18, "value": 92},
      {"row": 91, "column": 18, "value": 93},
      {"row": 92, "column": 18, "value": 93},
      {"row": 93, "column": 18, "value": 94},
      {"row": 94, "column": 18, "value": 95},
      {"row": 95, "column": 18, "value": 96},
      {"row": 96, "column": 18, "value": 97},
      {"row": 97, "column": 18, "value": 98},
      {"row": 98, "column": 18, "value": 98},
      {"row": 99, "column": 18, "value": 99},
      {"row": 19, "column": 19, "value": 34},
      {"row": 20, "column": 19, "value": 35},
      {"row": 21, "column": 19, "value": 36},
      {"row": 22, "column": 19, "value": 37},
      {"row": 23, "column": 19, "value": 38},
      {"row": 24, "column": 19, "value": 38},
      {"row": 25, "column": 19, "value": 39},
      {"row": 26, "column": 19, "value": 40},
      {"row": 27, "column": 19, "value": 41},
      {"row": 28, "column": 19, "value": 42},
      {"row": 29, "column": 19, "value": 42},
      {"row": 30, "column": 19, "value": 43},
      {"row": 31, "column": 19, "value": 44},
      {"row": 32, "column": 19, "value": 45},
      {"row": 33, "column": 19, "value": 46},
      {"row": 34, "column": 19, "value": 47},
      {"row": 35, "column": 19, "value": 47},
      {"row": 36, "column": 19, "value": 48},
      {"row": 37, "column": 19, "value": 49},
      {"row": 38, "column": 19, "value": 50},
      {"row": 39, "column": 19, "value": 51},
      {"row": 40, "column": 19, "value": 51},
      {"row": 41, "column": 19, "value": 52},
      {"row": 42, "column": 19, "value": 53},
      {"row": 43, "column": 19, "value": 54},
      {"row": 44, "column": 19, "value": 55},
      {"row": 45, "column": 19, "value": 55},
      {"row": 46, "column": 19, "value": 56},
      {"row": 47, "column": 19, "value": 57},
      {"row": 48, "column": 19, "value": 58},
      {"row": 49, "column": 19, "value": 59},
      {"row": 50, "column": 19, "value": 60},
      {"row": 51, "column": 19, "value": 60},
      {"row": 52, "column": 19, "value": 61},
      {"row": 53, "column": 19, "value": 62},
      {"row": 54, "column": 19, "value": 63},
      {"row": 55, "column": 19, "value": 64},
      {"row": 56, "column": 19, "value": 64},
      {"row": 57, "column": 19, "value": 65},
      {"row": 58, "column": 19, "value": 66},
      {"row": 59, "column": 19, "value": 67},
      {"row": 60, "column": 19, "value": 68},
      {"row": 61, "column": 19, "value": 68},
      {"row": 62, "column": 19, "value": 69},
      {"row": 63, "column": 19, "value": 70},
      {"row": 64, "column": 19, "value": 71},
      {"row": 65, "column": 19, "value": 72},
      {"row": 66, "column": 19, "value": 72},
      {"row": 67, "column": 19, "value": 73},
      {"row": 68, "column": 19, "value": 74},
      {"row": 69, "column": 19, "value": 75},
      {"row": 70, "column": 19, "value": 76},
      {"row": 71, "column": 19, "value": 77},
      {"row": 72, "column": 19, "value": 77},
      {"row": 73, "column": 19, "value": 78},
      {"row": 74, "column": 19, "value": 79},
      {"row": 75, "column": 19, "value": 80},
      {"row": 76, "column": 19, "value": 81},
      {"row": 77, "column": 19, "value": 81},
      {"row": 78, "column": 19, "value": 82},
      {"row": 79, "column": 19, "value": 83},
      {"row": 80, "column": 19, "value": 84},
      {"row": 81, "column": 19, "value": 85},
      {"row": 82, "column": 19, "value": 85},
      {"row": 83, "column": 19, "value": 86},
      {"row": 84, "column": 19, "value": 87},
      {"row": 85, "column": 19, "value": 88},
      {"row": 86, "column": 19, "value": 89},
      {"row": 87, "column": 19, "value": 89},
      {"row": 88, "column": 19, "value": 90},
      {"row": 89, "column": 19, "value": 91},
      {"row": 90, "column": 19, "value": 92},
      {"row": 91, "column": 19, "value": 93},
      {"row": 92, "column": 19, "value": 94},
      {"row": 93, "column": 19, "value": 94},
      {"row": 94, "column": 19, "value": 95},
      {"row": 95, "column": 19, "value": 96},
      {"row": 96, "column": 19, "value": 97},
      {"row": 97, "column": 19, "value": 98},
      {"row": 98, "column": 19, "value": 98},
      {"row": 99, "column": 19, "value": 99},
      {"row": 20, "column": 20, "value": 36},
      {"row": 21, "column": 20, "value": 37},
      {"row": 22, "column": 20, "value": 38},
      {"row": 23, "column": 20, "value": 38},
      {"row": 24, "column": 20, "value": 39},
      {"row": 25, "column": 20, "value": 40},
      {"row": 26, "column": 20, "value": 41},
      {"row": 27, "column": 20, "value": 42},
      {"row": 28, "column": 20, "value": 42},
      {"row": 29, "column": 20, "value": 43},
      {"row": 30, "column": 20, "value": 44},
      {"row": 31, "column": 20, "value": 45},
      {"row": 32, "column": 20, "value": 46},
      {"row": 33, "column": 20, "value": 46},
      {"row": 34, "column": 20, "value": 47},
      {"row": 35, "column": 20, "value": 48},
      {"row": 36, "column": 20, "value": 49},
      {"row": 37, "column": 20, "value": 50},
      {"row": 38, "column": 20, "value": 50},
      {"row": 39, "column": 20, "value": 51},
      {"row": 40, "column": 20, "value": 52},
      {"row": 41, "column": 20, "value": 53},
      {"row": 42, "column": 20, "value": 54},
      {"row": 43, "column": 20, "value": 54},
      {"row": 44, "column": 20, "value": 55},
      {"row": 45, "column": 20, "value": 56},
      {"row": 46, "column": 20, "value": 57},
      {"row": 47, "column": 20, "value": 58},
      {"row": 48, "column": 20, "value": 58},
      {"row": 49, "column": 20, "value": 59},
      {"row": 50, "column": 20, "value": 60},
      {"row": 51, "column": 20, "value": 61},
      {"row": 52, "column": 20, "value": 62},
      {"row": 53, "column": 20, "value": 62},
      {"row": 54, "column": 20, "value": 63},
      {"row": 55, "column": 20, "value": 64},
      {"row": 56, "column": 20, "value": 65},
      {"row": 57, "column": 20, "value": 66},
      {"row": 58, "column": 20, "value": 66},
      {"row": 59, "column": 20, "value": 67},
      {"row": 60, "column": 20, "value": 68},
      {"row": 61, "column": 20, "value": 69},
      {"row": 62, "column": 20, "value": 70},
      {"row": 63, "column": 20, "value": 70},
      {"row": 64, "column": 20, "value": 71},
      {"row": 65, "column": 20, "value": 72},
      {"row": 66, "column": 20, "value": 73},
      {"row": 67, "column": 20, "value": 74},
      {"row": 68, "column": 20, "value": 74},
      {"row": 69, "column": 20, "value": 75},
      {"row": 70, "column": 20, "value": 76},
      {"row": 71, "column": 20, "value": 77},
      {"row": 72, "column": 20, "value": 78},
      {"row": 73, "column": 20, "value": 78},
      {"row": 74, "column": 20, "value": 79},
      {"row": 75, "column": 20, "value": 80},
      {"row": 76, "column": 20, "value": 81},
      {"row": 77, "column": 20, "value": 82},
      {"row": 78, "column": 20, "value": 82},
      {"row": 79, "column": 20, "value": 83},
      {"row": 80, "column": 20, "value": 84},
      {"row": 81, "column": 20, "value": 85},
      {"row": 82, "column": 20, "value": 86},
      {"row": 83, "column": 20, "value": 86},
      {"row": 84, "column": 20, "value": 87},
      {"row": 85, "column": 20, "value": 88},
      {"row": 86, "column": 20, "value": 89},
      {"row": 87, "column": 20, "value": 90},
      {"row": 88, "column": 20, "value": 90},
      {"row": 89, "column": 20, "value": 91},
      {"row": 90, "column": 20, "value": 92},
      {"row": 91, "column": 20, "value": 93},
      {"row": 92, "column": 20, "value": 94},
      {"row": 93, "column": 20, "value": 94},
      {"row": 94, "column": 20, "value": 95},
      {"row": 95, "column": 20, "value": 96},
      {"row": 96, "column": 20, "value": 97},
      {"row": 97, "column": 20, "value": 98},
      {"row": 98, "column": 20, "value": 98},
      {"row": 99, "column": 20, "value": 99},
      {"row": 21, "column": 21, "value": 38},
      {"row": 22, "column": 21, "value": 38},
      {"row": 23, "column": 21, "value": 39},
      {"row": 24, "column": 21, "value": 40},
      {"row": 25, "column": 21, "value": 41},
      {"row": 26, "column": 21, "value": 42},
      {"row": 27, "column": 21, "value": 42},
      {"row": 28, "column": 21, "value": 43},
      {"row": 29, "column": 21, "value": 44},
      {"row": 30, "column": 21, "value": 45},
      {"row": 31, "column": 21, "value": 45},
      {"row": 32, "column": 21, "value": 46},
      {"row": 33, "column": 21, "value": 47},
      {"row": 34, "column": 21, "value": 48},
      {"row": 35, "column": 21, "value": 49},
      {"row": 36, "column": 21, "value": 49},
      {"row": 37, "column": 21, "value": 50},
      {"row": 38, "column": 21, "value": 51},
      {"row": 39, "column": 21, "value": 52},
      {"row": 40, "column": 21, "value": 53},
      {"row": 41, "column": 21, "value": 53},
      {"row": 42, "column": 21, "value": 54},
      {"row": 43, "column": 21, "value": 55},
      {"row": 44, "column": 21, "value": 56},
      {"row": 45, "column": 21, "value": 57},
      {"row": 46, "column": 21, "value": 57},
      {"row": 47, "column": 21, "value": 58},
      {"row": 48, "column": 21, "value": 59},
      {"row": 49, "column": 21, "value": 60},
      {"row": 50, "column": 21, "value": 61},
      {"row": 51, "column": 21, "value": 61},
      {"row": 52, "column": 21, "value": 62},
      {"row": 53, "column": 21, "value": 63},
      {"row": 54, "column": 21, "value": 64},
      {"row": 55, "column": 21, "value": 64},
      {"row": 56, "column": 21, "value": 65},
      {"row": 57, "column": 21, "value": 66},
      {"row": 58, "column": 21, "value": 67},
      {"row": 59, "column": 21, "value": 68},
      {"row": 60, "column": 21, "value": 68},
      {"row": 61, "column": 21, "value": 69},
      {"row": 62, "column": 21, "value": 70},
      {"row": 63, "column": 21, "value": 71},
      {"row": 64, "column": 21, "value": 72},
      {"row": 65, "column": 21, "value": 72},
      {"row": 66, "column": 21, "value": 73},
      {"row": 67, "column": 21, "value": 74},
      {"row": 68, "column": 21, "value": 75},
      {"row": 69, "column": 21, "value": 76},
      {"row": 70, "column": 21, "value": 76},
      {"row": 71, "column": 21, "value": 77},
      {"row": 72, "column": 21, "value": 78},
      {"row": 73, "column": 21, "value": 79},
      {"row": 74, "column": 21, "value": 79},
      {"row": 75, "column": 21, "value": 80},
      {"row": 76, "column": 21, "value": 81},
      {"row": 77, "column": 21, "value": 82},
      {"row": 78, "column": 21, "value": 83},
      {"row": 79, "column": 21, "value": 83},
      {"row": 80, "column": 21, "value": 84},
      {"row": 81, "column": 21, "value": 85},
      {"row": 82, "column": 21, "value": 86},
      {"row": 83, "column": 21, "value": 87},
      {"row": 84, "column": 21, "value": 87},
      {"row": 85, "column": 21, "value": 88},
      {"row": 86, "column": 21, "value": 89},
      {"row": 87, "column": 21, "value": 90},
      {"row": 88, "column": 21, "value": 91},
      {"row": 89, "column": 21, "value": 91},
      {"row": 90, "column": 21, "value": 92},
      {"row": 91, "column": 21, "value": 93},
      {"row": 92, "column": 21, "value": 94},
      {"row": 93, "column": 21, "value": 94},
      {"row": 94, "column": 21, "value": 95},
      {"row": 95, "column": 21, "value": 96},
      {"row": 96, "column": 21, "value": 97},
      {"row": 97, "column": 21, "value": 98},
      {"row": 98, "column": 21, "value": 98},
      {"row": 99, "column": 21, "value": 99},
      {"row": 22, "column": 22, "value": 39},
      {"row": 23, "column": 22, "value": 40},
      {"row": 24, "column": 22, "value": 41},
      {"row": 25, "column": 22, "value": 42},
      {"row": 26, "column": 22, "value": 42},
      {"row": 27, "column": 22, "value": 43},
      {"row": 28, "column": 22, "value": 44},
      {"row": 29, "column": 22, "value": 45},
      {"row": 30, "column": 22, "value": 45},
      {"row": 31, "column": 22, "value": 46},
      {"row": 32, "column": 22, "value": 47},
      {"row": 33, "column": 22, "value": 48},
      {"row": 34, "column": 22, "value": 49},
      {"row": 35, "column": 22, "value": 49},
      {"row": 36, "column": 22, "value": 50},
      {"row": 37, "column": 22, "value": 51},
      {"row": 38, "column": 22, "value": 52},
      {"row": 39, "column": 22, "value": 52},
      {"row": 40, "column": 22, "value": 53},
      {"row": 41, "column": 22, "value": 54},
      {"row": 42, "column": 22, "value": 55},
      {"row": 43, "column": 22, "value": 56},
      {"row": 44, "column": 22, "value": 56},
      {"row": 45, "column": 22, "value": 57},
      {"row": 46, "column": 22, "value": 58},
      {"row": 47, "column": 22, "value": 59},
      {"row": 48, "column": 22, "value": 59},
      {"row": 49, "column": 22, "value": 60},
      {"row": 50, "column": 22, "value": 61},
      {"row": 51, "column": 22, "value": 62},
      {"row": 52, "column": 22, "value": 63},
      {"row": 53, "column": 22, "value": 63},
      {"row": 54, "column": 22, "value": 64},
      {"row": 55, "column": 22, "value": 65},
      {"row": 56, "column": 22, "value": 66},
      {"row": 57, "column": 22, "value": 66},
      {"row": 58, "column": 22, "value": 67},
      {"row": 59, "column": 22, "value": 68},
      {"row": 60, "column": 22, "value": 69},
      {"row": 61, "column": 22, "value": 70},
      {"row": 62, "column": 22, "value": 70},
      {"row": 63, "column": 22, "value": 71},
      {"row": 64, "column": 22, "value": 72},
      {"row": 65, "column": 22, "value": 73},
      {"row": 66, "column": 22, "value": 73},
      {"row": 67, "column": 22, "value": 74},
      {"row": 68, "column": 22, "value": 75},
      {"row": 69, "column": 22, "value": 76},
      {"row": 70, "column": 22, "value": 77},
      {"row": 71, "column": 22, "value": 77},
      {"row": 72, "column": 22, "value": 78},
      {"row": 73, "column": 22, "value": 79},
      {"row": 74, "column": 22, "value": 80},
      {"row": 75, "column": 22, "value": 81},
      {"row": 76, "column": 22, "value": 81},
      {"row": 77, "column": 22, "value": 82},
      {"row": 78, "column": 22, "value": 83},
      {"row": 79, "column": 22, "value": 84},
      {"row": 80, "column": 22, "value": 84},
      {"row": 81, "column": 22, "value": 85},
      {"row": 82, "column": 22, "value": 86},
      {"row": 83, "column": 22, "value": 87},
      {"row": 84, "column": 22, "value": 88},
      {"row": 85, "column": 22, "value": 88},
      {"row": 86, "column": 22, "value": 89},
      {"row": 87, "column": 22, "value": 90},
      {"row": 88, "column": 22, "value": 91},
      {"row": 89, "column": 22, "value": 91},
      {"row": 90, "column": 22, "value": 92},
      {"row": 91, "column": 22, "value": 93},
      {"row": 92, "column": 22, "value": 94},
      {"row": 93, "column": 22, "value": 95},
      {"row": 94, "column": 22, "value": 95},
      {"row": 95, "column": 22, "value": 96},
      {"row": 96, "column": 22, "value": 97},
      {"row": 97, "column": 22, "value": 98},
      {"row": 98, "column": 22, "value": 98},
      {"row": 99, "column": 22, "value": 99},
      {"row": 23, "column": 23, "value": 41},
      {"row": 24, "column": 23, "value": 41},
      {"row": 25, "column": 23, "value": 42},
      {"row": 26, "column": 23, "value": 43},
      {"row": 27, "column": 23, "value": 44},
      {"row": 28, "column": 23, "value": 45},
      {"row": 29, "column": 23, "value": 45},
      {"row": 30, "column": 23, "value": 46},
      {"row": 31, "column": 23, "value": 47},
      {"row": 32, "column": 23, "value": 48},
      {"row": 33, "column": 23, "value": 48},
      {"row": 34, "column": 23, "value": 49},
      {"row": 35, "column": 23, "value": 50},
      {"row": 36, "column": 23, "value": 51},
      {"row": 37, "column": 23, "value": 51},
      {"row": 38, "column": 23, "value": 52},
      {"row": 39, "column": 23, "value": 53},
      {"row": 40, "column": 23, "value": 54},
      {"row": 41, "column": 23, "value": 55},
      {"row": 42, "column": 23, "value": 55},
      {"row": 43, "column": 23, "value": 56},
      {"row": 44, "column": 23, "value": 57},
      {"row": 45, "column": 23, "value": 58},
      {"row": 46, "column": 23, "value": 58},
      {"row": 47, "column": 23, "value": 59},
      {"row": 48, "column": 23, "value": 60},
      {"row": 49, "column": 23, "value": 61},
      {"row": 50, "column": 23, "value": 62},
      {"row": 51, "column": 23, "value": 62},
      {"row": 52, "column": 23, "value": 63},
      {"row": 53, "column": 23, "value": 64},
      {"row": 54, "column": 23, "value": 65},
      {"row": 55, "column": 23, "value": 65},
      {"row": 56, "column": 23, "value": 66},
      {"row": 57, "column": 23, "value": 67},
      {"row": 58, "column": 23, "value": 68},
      {"row": 59, "column": 23, "value": 68},
      {"row": 60, "column": 23, "value": 69},
      {"row": 61, "column": 23, "value": 70},
      {"row": 62, "column": 23, "value": 71},
      {"row": 63, "column": 23, "value": 72},
      {"row": 64, "column": 23, "value": 72},
      {"row": 65, "column": 23, "value": 83},
      {"row": 66, "column": 23, "value": 74},
      {"row": 67, "column": 23, "value": 75},
      {"row": 68, "column": 23, "value": 75},
      {"row": 69, "column": 23, "value": 76},
      {"row": 70, "column": 23, "value": 77},
      {"row": 71, "column": 23, "value": 78},
      {"row": 72, "column": 23, "value": 78},
      {"row": 73, "column": 23, "value": 79},
      {"row": 74, "column": 23, "value": 80},
      {"row": 75, "column": 23, "value": 81},
      {"row": 76, "column": 23, "value": 82},
      {"row": 77, "column": 23, "value": 82},
      {"row": 78, "column": 23, "value": 83},
      {"row": 79, "column": 23, "value": 84},
      {"row": 80, "column": 23, "value": 85},
      {"row": 81, "column": 23, "value": 85},
      {"row": 82, "column": 23, "value": 86},
      {"row": 83, "column": 23, "value": 87},
      {"row": 84, "column": 23, "value": 88},
      {"row": 85, "column": 23, "value": 88},
      {"row": 86, "column": 23, "value": 89},
      {"row": 87, "column": 23, "value": 90},
      {"row": 88, "column": 23, "value": 91},
      {"row": 89, "column": 23, "value": 92},
      {"row": 90, "column": 23, "value": 92},
      {"row": 91, "column": 23, "value": 93},
      {"row": 92, "column": 23, "value": 94},
      {"row": 93, "column": 23, "value": 95},
      {"row": 94, "column": 23, "value": 95},
      {"row": 95, "column": 23, "value": 96},
      {"row": 96, "column": 23, "value": 97},
      {"row": 97, "column": 23, "value": 98},
      {"row": 98, "column": 23, "value": 98},
      {"row": 99, "column": 23, "value": 99},
      {"row": 24, "column": 24, "value": 42},
      {"row": 25, "column": 24, "value": 43},
      {"row": 26, "column": 24, "value": 44},
      {"row": 27, "column": 24, "value": 45},
      {"row": 28, "column": 24, "value": 45},
      {"row": 29, "column": 24, "value": 46},
      {"row": 30, "column": 24, "value": 47},
      {"row": 31, "column": 24, "value": 48},
      {"row": 32, "column": 24, "value": 48},
      {"row": 33, "column": 24, "value": 49},
      {"row": 34, "column": 24, "value": 50},
      {"row": 35, "column": 24, "value": 51},
      {"row": 36, "column": 24, "value": 51},
      {"row": 37, "column": 24, "value": 52},
      {"row": 38, "column": 24, "value": 53},
      {"row": 39, "column": 24, "value": 54},
      {"row": 40, "column": 24, "value": 54},
      {"row": 41, "column": 24, "value": 55},
      {"row": 42, "column": 24, "value": 56},
      {"row": 43, "column": 24, "value": 57},
      {"row": 44, "column": 24, "value": 57},
      {"row": 45, "column": 24, "value": 58},
      {"row": 46, "column": 24, "value": 59},
      {"row": 47, "column": 24, "value": 60},
      {"row": 48, "column": 24, "value": 60},
      {"row": 49, "column": 24, "value": 61},
      {"row": 50, "column": 24, "value": 62},
      {"row": 51, "column": 24, "value": 63},
      {"row": 52, "column": 24, "value": 64},
      {"row": 53, "column": 24, "value": 64},
      {"row": 54, "column": 24, "value": 65},
      {"row": 55, "column": 24, "value": 66},
      {"row": 56, "column": 24, "value": 67},
      {"row": 57, "column": 24, "value": 67},
      {"row": 58, "column": 24, "value": 68},
      {"row": 59, "column": 24, "value": 69},
      {"row": 60, "column": 24, "value": 70},
      {"row": 61, "column": 24, "value": 70},
      {"row": 62, "column": 24, "value": 71},
      {"row": 63, "column": 24, "value": 72},
      {"row": 64, "column": 24, "value": 73},
      {"row": 65, "column": 24, "value": 73},
      {"row": 66, "column": 24, "value": 74},
      {"row": 67, "column": 24, "value": 75},
      {"row": 68, "column": 24, "value": 76},
      {"row": 69, "column": 24, "value": 76},
      {"row": 70, "column": 24, "value": 77},
      {"row": 71, "column": 24, "value": 78},
      {"row": 72, "column": 24, "value": 79},
      {"row": 73, "column": 24, "value": 79},
      {"row": 74, "column": 24, "value": 80},
      {"row": 75, "column": 24, "value": 81},
      {"row": 76, "column": 24, "value": 82},
      {"row": 77, "column": 24, "value": 83},
      {"row": 78, "column": 24, "value": 83},
      {"row": 79, "column": 24, "value": 84},
      {"row": 80, "column": 24, "value": 85},
      {"row": 81, "column": 24, "value": 86},
      {"row": 82, "column": 24, "value": 86},
      {"row": 83, "column": 24, "value": 87},
      {"row": 84, "column": 24, "value": 88},
      {"row": 85, "column": 24, "value": 89},
      {"row": 86, "column": 24, "value": 89},
      {"row": 87, "column": 24, "value": 90},
      {"row": 88, "column": 24, "value": 91},
      {"row": 89, "column": 24, "value": 92},
      {"row": 90, "column": 24, "value": 92},
      {"row": 91, "column": 24, "value": 93},
      {"row": 92, "column": 24, "value": 94},
      {"row": 93, "column": 24, "value": 95},
      {"row": 94, "column": 24, "value": 95},
      {"row": 95, "column": 24, "value": 96},
      {"row": 96, "column": 24, "value": 97},
      {"row": 97, "column": 24, "value": 98},
      {"row": 98, "column": 24, "value": 98},
      {"row": 99, "column": 24, "value": 99},
      {"row": 25, "column": 25, "value": 44},
      {"row": 26, "column": 25, "value": 45},
      {"row": 27, "column": 25, "value": 45},
      {"row": 28, "column": 25, "value": 46},
      {"row": 29, "column": 25, "value": 47},
      {"row": 30, "column": 25, "value": 48},
      {"row": 31, "column": 25, "value": 48},
      {"row": 32, "column": 25, "value": 49},
      {"row": 33, "column": 25, "value": 50},
      {"row": 34, "column": 25, "value": 51},
      {"row": 35, "column": 25, "value": 51},
      {"row": 36, "column": 25, "value": 52},
      {"row": 37, "column": 25, "value": 53},
      {"row": 38, "column": 25, "value": 54},
      {"row": 39, "column": 25, "value": 54},
      {"row": 40, "column": 25, "value": 55},
      {"row": 41, "column": 25, "value": 56},
      {"row": 42, "column": 25, "value": 57},
      {"row": 43, "column": 25, "value": 57},
      {"row": 44, "column": 25, "value": 58},
      {"row": 45, "column": 25, "value": 59},
      {"row": 46, "column": 25, "value": 60},
      {"row": 47, "column": 25, "value": 60},
      {"row": 48, "column": 25, "value": 61},
      {"row": 49, "column": 25, "value": 62},
      {"row": 50, "column": 25, "value": 63},
      {"row": 51, "column": 25, "value": 63},
      {"row": 52, "column": 25, "value": 64},
      {"row": 53, "column": 25, "value": 65},
      {"row": 54, "column": 25, "value": 66},
      {"row": 55, "column": 25, "value": 66},
      {"row": 56, "column": 25, "value": 67},
      {"row": 57, "column": 25, "value": 68},
      {"row": 58, "column": 25, "value": 68},
      {"row": 59, "column": 25, "value": 69},
      {"row": 60, "column": 25, "value": 70},
      {"row": 61, "column": 25, "value": 71},
      {"row": 62, "column": 25, "value": 72},
      {"row": 63, "column": 25, "value": 72},
      {"row": 64, "column": 25, "value": 73},
      {"row": 65, "column": 25, "value": 74},
      {"row": 66, "column": 25, "value": 75},
      {"row": 67, "column": 25, "value": 75},
      {"row": 68, "column": 25, "value": 76},
      {"row": 69, "column": 25, "value": 77},
      {"row": 70, "column": 25, "value": 78},
      {"row": 71, "column": 25, "value": 78},
      {"row": 72, "column": 25, "value": 79},
      {"row": 73, "column": 25, "value": 80},
      {"row": 74, "column": 25, "value": 81},
      {"row": 75, "column": 25, "value": 81},
      {"row": 76, "column": 25, "value": 82},
      {"row": 77, "column": 25, "value": 83},
      {"row": 78, "column": 25, "value": 84},
      {"row": 79, "column": 25, "value": 84},
      {"row": 80, "column": 25, "value": 85},
      {"row": 81, "column": 25, "value": 86},
      {"row": 82, "column": 25, "value": 87},
      {"row": 83, "column": 25, "value": 87},
      {"row": 84, "column": 25, "value": 88},
      {"row": 85, "column": 25, "value": 89},
      {"row": 86, "column": 25, "value": 90},
      {"row": 87, "column": 25, "value": 90},
      {"row": 88, "column": 25, "value": 91},
      {"row": 89, "column": 25, "value": 92},
      {"row": 90, "column": 25, "value": 93},
      {"row": 91, "column": 25, "value": 93},
      {"row": 92, "column": 25, "value": 94},
      {"row": 93, "column": 25, "value": 95},
      {"row": 94, "column": 25, "value": 96},
      {"row": 95, "column": 25, "value": 96},
      {"row": 96, "column": 25, "value": 97},
      {"row": 97, "column": 25, "value": 98},
      {"row": 98, "column": 25, "value": 99},
      {"row": 99, "column": 25, "value": 99},
      {"row": 26, "column": 26, "value": 45},
      {"row": 27, "column": 26, "value": 46},
      {"row": 28, "column": 26, "value": 47},
      {"row": 29, "column": 26, "value": 47},
      {"row": 30, "column": 26, "value": 48},
      {"row": 31, "column": 26, "value": 49},
      {"row": 32, "column": 26, "value": 50},
      {"row": 33, "column": 26, "value": 50},
      {"row": 34, "column": 26, "value": 51},
      {"row": 35, "column": 26, "value": 52},
      {"row": 36, "column": 26, "value": 53},
      {"row": 37, "column": 26, "value": 53},
      {"row": 38, "column": 26, "value": 54},
      {"row": 39, "column": 26, "value": 55},
      {"row": 40, "column": 26, "value": 56},
      {"row": 41, "column": 26, "value": 56},
      {"row": 42, "column": 26, "value": 57},
      {"row": 43, "column": 26, "value": 58},
      {"row": 44, "column": 26, "value": 59},
      {"row": 45, "column": 26, "value": 59},
      {"row": 46, "column": 26, "value": 60},
      {"row": 47, "column": 26, "value": 61},
      {"row": 48, "column": 26, "value": 62},
      {"row": 49, "column": 26, "value": 62},
      {"row": 50, "column": 26, "value": 63},
      {"row": 51, "column": 26, "value": 64},
      {"row": 52, "column": 26, "value": 64},
      {"row": 53, "column": 26, "value": 65},
      {"row": 54, "column": 26, "value": 66},
      {"row": 55, "column": 26, "value": 67},
      {"row": 56, "column": 26, "value": 67},
      {"row": 57, "column": 26, "value": 68},
      {"row": 58, "column": 26, "value": 69},
      {"row": 59, "column": 26, "value": 70},
      {"row": 60, "column": 26, "value": 70},
      {"row": 61, "column": 26, "value": 71},
      {"row": 62, "column": 26, "value": 72},
      {"row": 63, "column": 26, "value": 73},
      {"row": 64, "column": 26, "value": 73},
      {"row": 65, "column": 26, "value": 74},
      {"row": 66, "column": 26, "value": 75},
      {"row": 67, "column": 26, "value": 76},
      {"row": 68, "column": 26, "value": 76},
      {"row": 69, "column": 26, "value": 77},
      {"row": 70, "column": 26, "value": 78},
      {"row": 71, "column": 26, "value": 79},
      {"row": 72, "column": 26, "value": 79},
      {"row": 73, "column": 26, "value": 80},
      {"row": 74, "column": 26, "value": 81},
      {"row": 75, "column": 26, "value": 82},
      {"row": 76, "column": 26, "value": 82},
      {"row": 77, "column": 26, "value": 83},
      {"row": 78, "column": 26, "value": 84},
      {"row": 79, "column": 26, "value": 84},
      {"row": 80, "column": 26, "value": 85},
      {"row": 81, "column": 26, "value": 86},
      {"row": 82, "column": 26, "value": 87},
      {"row": 83, "column": 26, "value": 87},
      {"row": 84, "column": 26, "value": 88},
      {"row": 85, "column": 26, "value": 89},
      {"row": 86, "column": 26, "value": 90},
      {"row": 87, "column": 26, "value": 90},
      {"row": 88, "column": 26, "value": 91},
      {"row": 89, "column": 26, "value": 92},
      {"row": 90, "column": 26, "value": 93},
      {"row": 91, "column": 26, "value": 93},
      {"row": 92, "column": 26, "value": 94},
      {"row": 93, "column": 26, "value": 95},
      {"row": 94, "column": 26, "value": 96},
      {"row": 95, "column": 26, "value": 96},
      {"row": 96, "column": 26, "value": 97},
      {"row": 97, "column": 26, "value": 98},
      {"row": 98, "column": 26, "value": 99},
      {"row": 99, "column": 26, "value": 99},
      {"row": 27, "column": 27, "value": 47},
      {"row": 28, "column": 27, "value": 47},
      {"row": 29, "column": 27, "value": 48},
      {"row": 30, "column": 27, "value": 49},
      {"row": 31, "column": 27, "value": 50},
      {"row": 32, "column": 27, "value": 50},
      {"row": 33, "column": 27, "value": 51},
      {"row": 34, "column": 27, "value": 52},
      {"row": 35, "column": 27, "value": 53},
      {"row": 36, "column": 27, "value": 53},
      {"row": 37, "column": 27, "value": 54},
      {"row": 38, "column": 27, "value": 55},
      {"row": 39, "column": 27, "value": 55},
      {"row": 40, "column": 27, "value": 56},
      {"row": 41, "column": 27, "value": 57},
      {"row": 42, "column": 27, "value": 58},
      {"row": 43, "column": 27, "value": 58},
      {"row": 44, "column": 27, "value": 59},
      {"row": 45, "column": 27, "value": 60},
      {"row": 46, "column": 27, "value": 61},
      {"row": 47, "column": 27, "value": 61},
      {"row": 48, "column": 27, "value": 62},
      {"row": 49, "column": 27, "value": 63},
      {"row": 50, "column": 27, "value": 64},
      {"row": 51, "column": 27, "value": 64},
      {"row": 52, "column": 27, "value": 62},
      {"row": 53, "column": 27, "value": 66},
      {"row": 54, "column": 27, "value": 66},
      {"row": 55, "column": 27, "value": 67},
      {"row": 56, "column": 27, "value": 68},
      {"row": 57, "column": 27, "value": 69},
      {"row": 58, "column": 27, "value": 69},
      {"row": 59, "column": 27, "value": 70},
      {"row": 60, "column": 27, "value": 71},
      {"row": 61, "column": 27, "value": 72},
      {"row": 62, "column": 27, "value": 72},
      {"row": 63, "column": 27, "value": 73},
      {"row": 64, "column": 27, "value": 73},
      {"row": 65, "column": 27, "value": 74},
      {"row": 66, "column": 27, "value": 74},
      {"row": 67, "column": 27, "value": 75},
      {"row": 68, "column": 27, "value": 76},
      {"row": 69, "column": 27, "value": 77},
      {"row": 70, "column": 27, "value": 77},
      {"row": 71, "column": 27, "value": 78},
      {"row": 72, "column": 27, "value": 79},
      {"row": 73, "column": 27, "value": 80},
      {"row": 74, "column": 27, "value": 80},
      {"row": 75, "column": 27, "value": 81},
      {"row": 76, "column": 27, "value": 82},
      {"row": 77, "column": 27, "value": 82},
      {"row": 78, "column": 27, "value": 83},
      {"row": 79, "column": 27, "value": 84},
      {"row": 80, "column": 27, "value": 85},
      {"row": 81, "column": 27, "value": 85},
      {"row": 82, "column": 27, "value": 86},
      {"row": 83, "column": 27, "value": 87},
      {"row": 84, "column": 27, "value": 88},
      {"row": 85, "column": 27, "value": 88},
      {"row": 86, "column": 27, "value": 89},
      {"row": 87, "column": 27, "value": 90},
      {"row": 88, "column": 27, "value": 91},
      {"row": 89, "column": 27, "value": 91},
      {"row": 90, "column": 27, "value": 92},
      {"row": 91, "column": 27, "value": 93},
      {"row": 92, "column": 27, "value": 94},
      {"row": 93, "column": 27, "value": 95},
      {"row": 94, "column": 27, "value": 96},
      {"row": 95, "column": 27, "value": 96},
      {"row": 96, "column": 27, "value": 97},
      {"row": 97, "column": 27, "value": 98},
      {"row": 98, "column": 27, "value": 99},
      {"row": 99, "column": 27, "value": 99},
      {"row": 28, "column": 28, "value": 48},
      {"row": 29, "column": 28, "value": 49},
      {"row": 30, "column": 28, "value": 50},
      {"row": 31, "column": 28, "value": 50},
      {"row": 32, "column": 28, "value": 51},
      {"row": 33, "column": 28, "value": 52},
      {"row": 34, "column": 28, "value": 52},
      {"row": 35, "column": 28, "value": 53},
      {"row": 36, "column": 28, "value": 54},
      {"row": 37, "column": 28, "value": 55},
      {"row": 38, "column": 28, "value": 55},
      {"row": 39, "column": 28, "value": 56},
      {"row": 40, "column": 28, "value": 57},
      {"row": 41, "column": 28, "value": 58},
      {"row": 42, "column": 28, "value": 58},
      {"row": 43, "column": 28, "value": 59},
      {"row": 44, "column": 28, "value": 60},
      {"row": 45, "column": 28, "value": 60},
      {"row": 46, "column": 28, "value": 61},
      {"row": 47, "column": 28, "value": 62},
      {"row": 48, "column": 28, "value": 63},
      {"row": 49, "column": 28, "value": 63},
      {"row": 50, "column": 28, "value": 64},
      {"row": 51, "column": 28, "value": 65},
      {"row": 52, "column": 28, "value": 65},
      {"row": 53, "column": 28, "value": 66},
      {"row": 54, "column": 28, "value": 67},
      {"row": 55, "column": 28, "value": 68},
      {"row": 56, "column": 28, "value": 68},
      {"row": 57, "column": 28, "value": 69},
      {"row": 58, "column": 28, "value": 70},
      {"row": 59, "column": 28, "value": 70},
      {"row": 60, "column": 28, "value": 71},
      {"row": 61, "column": 28, "value": 72},
      {"row": 62, "column": 28, "value": 73},
      {"row": 63, "column": 28, "value": 73},
      {"row": 64, "column": 28, "value": 74},
      {"row": 65, "column": 28, "value": 75},
      {"row": 66, "column": 28, "value": 76},
      {"row": 67, "column": 28, "value": 76},
      {"row": 68, "column": 28, "value": 77},
      {"row": 69, "column": 28, "value": 78},
      {"row": 70, "column": 28, "value": 78},
      {"row": 71, "column": 28, "value": 79},
      {"row": 72, "column": 28, "value": 80},
      {"row": 73, "column": 28, "value": 81},
      {"row": 74, "column": 28, "value": 81},
      {"row": 75, "column": 28, "value": 82},
      {"row": 76, "column": 28, "value": 83},
      {"row": 77, "column": 28, "value": 83},
      {"row": 78, "column": 28, "value": 84},
      {"row": 79, "column": 28, "value": 85},
      {"row": 80, "column": 28, "value": 86},
      {"row": 81, "column": 28, "value": 86},
      {"row": 82, "column": 28, "value": 87},
      {"row": 83, "column": 28, "value": 88},
      {"row": 84, "column": 28, "value": 88},
      {"row": 85, "column": 28, "value": 89},
      {"row": 86, "column": 28, "value": 90},
      {"row": 87, "column": 28, "value": 91},
      {"row": 88, "column": 28, "value": 91},
      {"row": 89, "column": 28, "value": 92},
      {"row": 90, "column": 28, "value": 93},
      {"row": 91, "column": 28, "value": 94},
      {"row": 92, "column": 28, "value": 94},
      {"row": 93, "column": 28, "value": 95},
      {"row": 94, "column": 28, "value": 96},
      {"row": 95, "column": 28, "value": 96},
      {"row": 96, "column": 28, "value": 97},
      {"row": 97, "column": 28, "value": 98},
      {"row": 98, "column": 28, "value": 99},
      {"row": 99, "column": 28, "value": 99},
      {"row": 29, "column": 29, "value": 50},
      {"row": 30, "column": 29, "value": 50},
      {"row": 31, "column": 29, "value": 51},
      {"row": 32, "column": 29, "value": 52},
      {"row": 33, "column": 29, "value": 52},
      {"row": 34, "column": 29, "value": 53},
      {"row": 35, "column": 29, "value": 54},
      {"row": 36, "column": 29, "value": 55},
      {"row": 37, "column": 29, "value": 55},
      {"row": 38, "column": 29, "value": 56},
      {"row": 39, "column": 29, "value": 57},
      {"row": 40, "column": 29, "value": 57},
      {"row": 41, "column": 29, "value": 58},
      {"row": 42, "column": 29, "value": 59},
      {"row": 43, "column": 29, "value": 60},
      {"row": 44, "column": 29, "value": 60},
      {"row": 45, "column": 29, "value": 61},
      {"row": 46, "column": 29, "value": 62},
      {"row": 47, "column": 29, "value": 62},
      {"row": 48, "column": 29, "value": 63},
      {"row": 49, "column": 29, "value": 64},
      {"row": 50, "column": 29, "value": 65},
      {"row": 51, "column": 29, "value": 65},
      {"row": 52, "column": 29, "value": 66},
      {"row": 53, "column": 29, "value": 67},
      {"row": 54, "column": 29, "value": 67},
      {"row": 55, "column": 29, "value": 68},
      {"row": 56, "column": 29, "value": 69},
      {"row": 57, "column": 29, "value": 69},
      {"row": 58, "column": 29, "value": 70},
      {"row": 59, "column": 29, "value": 71},
      {"row": 60, "column": 29, "value": 72},
      {"row": 61, "column": 29, "value": 72},
      {"row": 62, "column": 29, "value": 73},
      {"row": 63, "column": 29, "value": 74},
      {"row": 64, "column": 29, "value": 74},
      {"row": 65, "column": 29, "value": 75},
      {"row": 66, "column": 29, "value": 76},
      {"row": 67, "column": 29, "value": 77},
      {"row": 68, "column": 29, "value": 77},
      {"row": 69, "column": 29, "value": 78},
      {"row": 70, "column": 29, "value": 79},
      {"row": 71, "column": 29, "value": 79},
      {"row": 72, "column": 29, "value": 80},
      {"row": 73, "column": 29, "value": 80},
      {"row": 74, "column": 29, "value": 81},
      {"row": 75, "column": 29, "value": 82},
      {"row": 76, "column": 29, "value": 82},
      {"row": 77, "column": 29, "value": 83},
      {"row": 78, "column": 29, "value": 84},
      {"row": 79, "column": 29, "value": 84},
      {"row": 80, "column": 29, "value": 85},
      {"row": 81, "column": 29, "value": 86},
      {"row": 82, "column": 29, "value": 87},
      {"row": 83, "column": 29, "value": 87},
      {"row": 84, "column": 29, "value": 88},
      {"row": 85, "column": 29, "value": 89},
      {"row": 86, "column": 29, "value": 89},
      {"row": 87, "column": 29, "value": 90},
      {"row": 88, "column": 29, "value": 91},
      {"row": 89, "column": 29, "value": 91},
      {"row": 90, "column": 29, "value": 92},
      {"row": 91, "column": 29, "value": 93},
      {"row": 92, "column": 29, "value": 94},
      {"row": 93, "column": 29, "value": 94},
      {"row": 94, "column": 29, "value": 95},
      {"row": 95, "column": 29, "value": 96},
      {"row": 96, "column": 29, "value": 97},
      {"row": 97, "column": 29, "value": 98},
      {"row": 98, "column": 29, "value": 99},
      {"row": 99, "column": 29, "value": 99},
      {"row": 30, "column": 30, "value": 51},
      {"row": 31, "column": 30, "value": 52},
      {"row": 32, "column": 30, "value": 52},
      {"row": 33, "column": 30, "value": 53},
      {"row": 34, "column": 30, "value": 54},
      {"row": 35, "column": 30, "value": 55},
      {"row": 36, "column": 30, "value": 55},
      {"row": 37, "column": 30, "value": 56},
      {"row": 38, "column": 30, "value": 57},
      {"row": 39, "column": 30, "value": 57},
      {"row": 40, "column": 30, "value": 58},
      {"row": 41, "column": 30, "value": 59},
      {"row": 42, "column": 30, "value": 59},
      {"row": 43, "column": 30, "value": 60},
      {"row": 44, "column": 30, "value": 61},
      {"row": 45, "column": 30, "value": 62},
      {"row": 46, "column": 30, "value": 62},
      {"row": 47, "column": 30, "value": 63},
      {"row": 48, "column": 30, "value": 64},
      {"row": 49, "column": 30, "value": 64},
      {"row": 50, "column": 30, "value": 65},
      {"row": 51, "column": 30, "value": 66},
      {"row": 52, "column": 30, "value": 66},
      {"row": 53, "column": 30, "value": 67},
      {"row": 54, "column": 30, "value": 68},
      {"row": 55, "column": 30, "value": 69},
      {"row": 56, "column": 30, "value": 69},
      {"row": 57, "column": 30, "value": 70},
      {"row": 58, "column": 30, "value": 71},
      {"row": 59, "column": 30, "value": 71},
      {"row": 60, "column": 30, "value": 72},
      {"row": 61, "column": 30, "value": 73},
      {"row": 62, "column": 30, "value": 73},
      {"row": 63, "column": 30, "value": 74},
      {"row": 64, "column": 30, "value": 75},
      {"row": 65, "column": 30, "value": 76},
      {"row": 66, "column": 30, "value": 76},
      {"row": 67, "column": 30, "value": 77},
      {"row": 68, "column": 30, "value": 78},
      {"row": 69, "column": 30, "value": 78},
      {"row": 70, "column": 30, "value": 79},
      {"row": 71, "column": 30, "value": 80},
      {"row": 72, "column": 30, "value": 80},
      {"row": 73, "column": 30, "value": 81},
      {"row": 74, "column": 30, "value": 82},
      {"row": 75, "column": 30, "value": 83},
      {"row": 76, "column": 30, "value": 83},
      {"row": 77, "column": 30, "value": 84},
      {"row": 78, "column": 30, "value": 85},
      {"row": 79, "column": 30, "value": 85},
      {"row": 80, "column": 30, "value": 86},
      {"row": 81, "column": 30, "value": 87},
      {"row": 82, "column": 30, "value": 87},
      {"row": 83, "column": 30, "value": 88},
      {"row": 84, "column": 30, "value": 89},
      {"row": 85, "column": 30, "value": 90},
      {"row": 86, "column": 30, "value": 90},
      {"row": 87, "column": 30, "value": 91},
      {"row": 88, "column": 30, "value": 92},
      {"row": 89, "column": 30, "value": 92},
      {"row": 90, "column": 30, "value": 93},
      {"row": 91, "column": 30, "value": 94},
      {"row": 92, "column": 30, "value": 94},
      {"row": 93, "column": 30, "value": 95},
      {"row": 94, "column": 30, "value": 96},
      {"row": 95, "column": 30, "value": 96},
      {"row": 96, "column": 30, "value": 97},
      {"row": 97, "column": 30, "value": 98},
      {"row": 98, "column": 30, "value": 99},
      {"row": 99, "column": 30, "value": 99},
      {"row": 31, "column": 31, "value": 52},
      {"row": 32, "column": 31, "value": 53},
      {"row": 33, "column": 31, "value": 54},
      {"row": 34, "column": 31, "value": 54},
      {"row": 35, "column": 31, "value": 55},
      {"row": 36, "column": 31, "value": 56},
      {"row": 37, "column": 31, "value": 57},
      {"row": 38, "column": 31, "value": 57},
      {"row": 39, "column": 31, "value": 58},
      {"row": 40, "column": 31, "value": 59},
      {"row": 41, "column": 31, "value": 59},
      {"row": 42, "column": 31, "value": 60},
      {"row": 43, "column": 31, "value": 61},
      {"row": 44, "column": 31, "value": 61},
      {"row": 45, "column": 31, "value": 62},
      {"row": 46, "column": 31, "value": 63},
      {"row": 47, "column": 31, "value": 63},
      {"row": 48, "column": 31, "value": 64},
      {"row": 49, "column": 31, "value": 65},
      {"row": 50, "column": 31, "value": 66},
      {"row": 51, "column": 31, "value": 66},
      {"row": 52, "column": 31, "value": 67},
      {"row": 53, "column": 31, "value": 68},
      {"row": 54, "column": 31, "value": 68},
      {"row": 55, "column": 31, "value": 69},
      {"row": 56, "column": 31, "value": 70},
      {"row": 57, "column": 31, "value": 70},
      {"row": 58, "column": 31, "value": 71},
      {"row": 59, "column": 31, "value": 72},
      {"row": 60, "column": 31, "value": 72},
      {"row": 61, "column": 31, "value": 73},
      {"row": 62, "column": 31, "value": 74},
      {"row": 63, "column": 31, "value": 74},
      {"row": 64, "column": 31, "value": 75},
      {"row": 65, "column": 31, "value": 76},
      {"row": 66, "column": 31, "value": 77},
      {"row": 67, "column": 31, "value": 77},
      {"row": 68, "column": 31, "value": 78},
      {"row": 69, "column": 31, "value": 79},
      {"row": 70, "column": 31, "value": 79},
      {"row": 71, "column": 31, "value": 80},
      {"row": 72, "column": 31, "value": 81},
      {"row": 73, "column": 31, "value": 81},
      {"row": 74, "column": 31, "value": 82},
      {"row": 75, "column": 31, "value": 83},
      {"row": 76, "column": 31, "value": 83},
      {"row": 77, "column": 31, "value": 84},
      {"row": 78, "column": 31, "value": 85},
      {"row": 79, "column": 31, "value": 86},
      {"row": 80, "column": 31, "value": 86},
      {"row": 81, "column": 31, "value": 87},
      {"row": 82, "column": 31, "value": 88},
      {"row": 83, "column": 31, "value": 88},
      {"row": 84, "column": 31, "value": 89},
      {"row": 85, "column": 31, "value": 90},
      {"row": 86, "column": 31, "value": 90},
      {"row": 87, "column": 31, "value": 91},
      {"row": 88, "column": 31, "value": 92},
      {"row": 89, "column": 31, "value": 92},
      {"row": 90, "column": 31, "value": 93},
      {"row": 91, "column": 31, "value": 94},
      {"row": 92, "column": 31, "value": 94},
      {"row": 93, "column": 31, "value": 95},
      {"row": 94, "column": 31, "value": 96},
      {"row": 95, "column": 31, "value": 97},
      {"row": 96, "column": 31, "value": 97},
      {"row": 97, "column": 31, "value": 98},
      {"row": 98, "column": 31, "value": 99},
      {"row": 99, "column": 31, "value": 99},
      {"row": 32, "column": 32, "value": 54},
      {"row": 33, "column": 32, "value": 54},
      {"row": 34, "column": 32, "value": 55},
      {"row": 35, "column": 32, "value": 56},
      {"row": 36, "column": 32, "value": 56},
      {"row": 37, "column": 32, "value": 57},
      {"row": 38, "column": 32, "value": 58},
      {"row": 39, "column": 32, "value": 59},
      {"row": 40, "column": 32, "value": 59},
      {"row": 41, "column": 32, "value": 60},
      {"row": 42, "column": 32, "value": 61},
      {"row": 43, "column": 32, "value": 61},
      {"row": 44, "column": 32, "value": 62},
      {"row": 45, "column": 32, "value": 63},
      {"row": 46, "column": 32, "value": 63},
      {"row": 47, "column": 32, "value": 64},
      {"row": 48, "column": 32, "value": 65},
      {"row": 49, "column": 32, "value": 65},
      {"row": 50, "column": 32, "value": 66},
      {"row": 51, "column": 32, "value": 67},
      {"row": 52, "column": 32, "value": 67},
      {"row": 53, "column": 32, "value": 68},
      {"row": 54, "column": 32, "value": 69},
      {"row": 55, "column": 32, "value": 69},
      {"row": 56, "column": 32, "value": 70},
      {"row": 57, "column": 32, "value": 71},
      {"row": 58, "column": 32, "value": 71},
      {"row": 59, "column": 32, "value": 72},
      {"row": 60, "column": 32, "value": 73},
      {"row": 61, "column": 32, "value": 73},
      {"row": 62, "column": 32, "value": 74},
      {"row": 63, "column": 32, "value": 75},
      {"row": 64, "column": 32, "value": 76},
      {"row": 65, "column": 32, "value": 76},
      {"row": 66, "column": 32, "value": 77},
      {"row": 67, "column": 32, "value": 78},
      {"row": 68, "column": 32, "value": 78},
      {"row": 69, "column": 32, "value": 79},
      {"row": 70, "column": 32, "value": 80},
      {"row": 71, "column": 32, "value": 80},
      {"row": 72, "column": 32, "value": 81},
      {"row": 73, "column": 32, "value": 82},
      {"row": 74, "column": 32, "value": 82},
      {"row": 75, "column": 32, "value": 83},
      {"row": 76, "column": 32, "value": 84},
      {"row": 77, "column": 32, "value": 84},
      {"row": 78, "column": 32, "value": 85},
      {"row": 79, "column": 32, "value": 86},
      {"row": 80, "column": 32, "value": 86},
      {"row": 81, "column": 32, "value": 87},
      {"row": 82, "column": 32, "value": 88},
      {"row": 83, "column": 32, "value": 88},
      {"row": 84, "column": 32, "value": 89},
      {"row": 85, "column": 32, "value": 90},
      {"row": 86, "column": 32, "value": 90},
      {"row": 87, "column": 32, "value": 91},
      {"row": 88, "column": 32, "value": 92},
      {"row": 89, "column": 32, "value": 93},
      {"row": 90, "column": 32, "value": 93},
      {"row": 91, "column": 32, "value": 94},
      {"row": 92, "column": 32, "value": 95},
      {"row": 93, "column": 32, "value": 95},
      {"row": 94, "column": 32, "value": 96},
      {"row": 95, "column": 32, "value": 97},
      {"row": 96, "column": 32, "value": 97},
      {"row": 97, "column": 32, "value": 98},
      {"row": 98, "column": 32, "value": 99},
      {"row": 99, "column": 32, "value": 99},
      {"row": 33, "column": 33, "value": 55},
      {"row": 34, "column": 33, "value": 56},
      {"row": 35, "column": 33, "value": 56},
      {"row": 36, "column": 33, "value": 57},
      {"row": 37, "column": 33, "value": 58},
      {"row": 38, "column": 33, "value": 58},
      {"row": 39, "column": 33, "value": 59},
      {"row": 40, "column": 33, "value": 60},
      {"row": 41, "column": 33, "value": 60},
      {"row": 42, "column": 33, "value": 61},
      {"row": 43, "column": 33, "value": 62},
      {"row": 44, "column": 33, "value": 62},
      {"row": 45, "column": 33, "value": 63},
      {"row": 46, "column": 33, "value": 64},
      {"row": 47, "column": 33, "value": 64},
      {"row": 48, "column": 33, "value": 65},
      {"row": 49, "column": 33, "value": 66},
      {"row": 50, "column": 33, "value": 67},
      {"row": 51, "column": 33, "value": 67},
      {"row": 52, "column": 33, "value": 68},
      {"row": 53, "column": 33, "value": 69},
      {"row": 54, "column": 33, "value": 69},
      {"row": 55, "column": 33, "value": 70},
      {"row": 56, "column": 33, "value": 71},
      {"row": 57, "column": 33, "value": 71},
      {"row": 58, "column": 33, "value": 72},
      {"row": 59, "column": 33, "value": 73},
      {"row": 60, "column": 33, "value": 73},
      {"row": 61, "column": 33, "value": 74},
      {"row": 62, "column": 33, "value": 75},
      {"row": 63, "column": 33, "value": 75},
      {"row": 64, "column": 33, "value": 76},
      {"row": 65, "column": 33, "value": 77},
      {"row": 66, "column": 33, "value": 77},
      {"row": 67, "column": 33, "value": 78},
      {"row": 68, "column": 33, "value": 79},
      {"row": 69, "column": 33, "value": 79},
      {"row": 70, "column": 33, "value": 80},
      {"row": 71, "column": 33, "value": 81},
      {"row": 72, "column": 33, "value": 81},
      {"row": 73, "column": 33, "value": 82},
      {"row": 74, "column": 33, "value": 83},
      {"row": 75, "column": 33, "value": 83},
      {"row": 76, "column": 33, "value": 84},
      {"row": 77, "column": 33, "value": 85},
      {"row": 78, "column": 33, "value": 85},
      {"row": 79, "column": 33, "value": 86},
      {"row": 80, "column": 33, "value": 87},
      {"row": 81, "column": 33, "value": 87},
      {"row": 82, "column": 33, "value": 88},
      {"row": 83, "column": 33, "value": 89},
      {"row": 84, "column": 33, "value": 89},
      {"row": 85, "column": 33, "value": 90},
      {"row": 86, "column": 33, "value": 91},
      {"row": 87, "column": 33, "value": 91},
      {"row": 88, "column": 33, "value": 92},
      {"row": 89, "column": 33, "value": 93},
      {"row": 90, "column": 33, "value": 93},
      {"row": 91, "column": 33, "value": 94},
      {"row": 92, "column": 33, "value": 95},
      {"row": 93, "column": 33, "value": 95},
      {"row": 94, "column": 33, "value": 96},
      {"row": 95, "column": 33, "value": 97},
      {"row": 96, "column": 33, "value": 97},
      {"row": 97, "column": 33, "value": 98},
      {"row": 98, "column": 33, "value": 99},
      {"row": 99, "column": 33, "value": 99},
      {"row": 34, "column": 34, "value": 56},
      {"row": 35, "column": 34, "value": 57},
      {"row": 36, "column": 34, "value": 58},
      {"row": 37, "column": 34, "value": 58},
      {"row": 38, "column": 34, "value": 59},
      {"row": 39, "column": 34, "value": 60},
      {"row": 40, "column": 34, "value": 60},
      {"row": 41, "column": 34, "value": 61},
      {"row": 42, "column": 34, "value": 62},
      {"row": 43, "column": 34, "value": 62},
      {"row": 44, "column": 34, "value": 63},
      {"row": 45, "column": 34, "value": 64},
      {"row": 46, "column": 34, "value": 64},
      {"row": 47, "column": 34, "value": 65},
      {"row": 48, "column": 34, "value": 66},
      {"row": 49, "column": 34, "value": 66},
      {"row": 50, "column": 34, "value": 67},
      {"row": 51, "column": 34, "value": 68},
      {"row": 52, "column": 34, "value": 68},
      {"row": 53, "column": 34, "value": 69},
      {"row": 54, "column": 34, "value": 70},
      {"row": 55, "column": 34, "value": 70},
      {"row": 56, "column": 34, "value": 71},
      {"row": 57, "column": 34, "value": 72},
      {"row": 58, "column": 34, "value": 72},
      {"row": 59, "column": 34, "value": 73},
      {"row": 60, "column": 34, "value": 74},
      {"row": 61, "column": 34, "value": 74},
      {"row": 62, "column": 34, "value": 75},
      {"row": 63, "column": 34, "value": 76},
      {"row": 64, "column": 34, "value": 76},
      {"row": 65, "column": 34, "value": 77},
      {"row": 66, "column": 34, "value": 78},
      {"row": 67, "column": 34, "value": 78},
      {"row": 68, "column": 34, "value": 79},
      {"row": 69, "column": 34, "value": 80},
      {"row": 70, "column": 34, "value": 80},
      {"row": 71, "column": 34, "value": 81},
      {"row": 72, "column": 34, "value": 82},
      {"row": 73, "column": 34, "value": 82},
      {"row": 74, "column": 34, "value": 83},
      {"row": 75, "column": 34, "value": 84},
      {"row": 76, "column": 34, "value": 84},
      {"row": 77, "column": 34, "value": 85},
      {"row": 78, "column": 34, "value": 85},
      {"row": 79, "column": 34, "value": 86},
      {"row": 80, "column": 34, "value": 87},
      {"row": 81, "column": 34, "value": 87},
      {"row": 82, "column": 34, "value": 88},
      {"row": 83, "column": 34, "value": 89},
      {"row": 84, "column": 34, "value": 89},
      {"row": 85, "column": 34, "value": 90},
      {"row": 86, "column": 34, "value": 91},
      {"row": 87, "column": 34, "value": 91},
      {"row": 88, "column": 34, "value": 92},
      {"row": 89, "column": 34, "value": 93},
      {"row": 90, "column": 34, "value": 93},
      {"row": 91, "column": 34, "value": 94},
      {"row": 92, "column": 34, "value": 95},
      {"row": 93, "column": 34, "value": 95},
      {"row": 94, "column": 34, "value": 96},
      {"row": 95, "column": 34, "value": 97},
      {"row": 96, "column": 34, "value": 97},
      {"row": 97, "column": 34, "value": 98},
      {"row": 98, "column": 34, "value": 99},
      {"row": 99, "column": 34, "value": 99},
      {"row": 35, "column": 35, "value": 58},
      {"row": 36, "column": 35, "value": 58},
      {"row": 37, "column": 35, "value": 59},
      {"row": 38, "column": 35, "value": 60},
      {"row": 39, "column": 35, "value": 60},
      {"row": 40, "column": 35, "value": 61},
      {"row": 41, "column": 35, "value": 62},
      {"row": 42, "column": 35, "value": 62},
      {"row": 43, "column": 35, "value": 63},
      {"row": 44, "column": 35, "value": 64},
      {"row": 45, "column": 35, "value": 64},
      {"row": 46, "column": 35, "value": 65},
      {"row": 47, "column": 35, "value": 66},
      {"row": 48, "column": 35, "value": 66},
      {"row": 49, "column": 35, "value": 67},
      {"row": 50, "column": 35, "value": 68},
      {"row": 51, "column": 35, "value": 68},
      {"row": 52, "column": 35, "value": 69},
      {"row": 53, "column": 35, "value": 69},
      {"row": 54, "column": 35, "value": 70},
      {"row": 55, "column": 35, "value": 71},
      {"row": 56, "column": 35, "value": 71},
      {"row": 57, "column": 35, "value": 72},
      {"row": 58, "column": 35, "value": 73},
      {"row": 59, "column": 35, "value": 73},
      {"row": 60, "column": 35, "value": 74},
      {"row": 61, "column": 35, "value": 75},
      {"row": 62, "column": 35, "value": 75},
      {"row": 63, "column": 35, "value": 76},
      {"row": 64, "column": 35, "value": 77},
      {"row": 65, "column": 35, "value": 77},
      {"row": 66, "column": 35, "value": 78},
      {"row": 67, "column": 35, "value": 79},
      {"row": 68, "column": 35, "value": 79},
      {"row": 69, "column": 35, "value": 80},
      {"row": 70, "column": 35, "value": 81},
      {"row": 71, "column": 35, "value": 81},
      {"row": 72, "column": 35, "value": 82},
      {"row": 73, "column": 35, "value": 82},
      {"row": 74, "column": 35, "value": 83},
      {"row": 75, "column": 35, "value": 84},
      {"row": 76, "column": 35, "value": 84},
      {"row": 77, "column": 35, "value": 85},
      {"row": 78, "column": 35, "value": 86},
      {"row": 79, "column": 35, "value": 86},
      {"row": 80, "column": 35, "value": 87},
      {"row": 81, "column": 35, "value": 88},
      {"row": 82, "column": 35, "value": 88},
      {"row": 83, "column": 35, "value": 89},
      {"row": 84, "column": 35, "value": 90},
      {"row": 85, "column": 35, "value": 90},
      {"row": 86, "column": 35, "value": 91},
      {"row": 87, "column": 35, "value": 92},
      {"row": 88, "column": 35, "value": 92},
      {"row": 89, "column": 35, "value": 93},
      {"row": 90, "column": 35, "value": 94},
      {"row": 91, "column": 35, "value": 94},
      {"row": 92, "column": 35, "value": 95},
      {"row": 93, "column": 35, "value": 95},
      {"row": 94, "column": 35, "value": 96},
      {"row": 95, "column": 35, "value": 97},
      {"row": 96, "column": 35, "value": 97},
      {"row": 97, "column": 35, "value": 98},
      {"row": 98, "column": 35, "value": 99},
      {"row": 99, "column": 35, "value": 99},
      {"row": 36, "column": 36, "value": 59},
      {"row": 37, "column": 36, "value": 60},
      {"row": 38, "column": 36, "value": 60},
      {"row": 39, "column": 36, "value": 61},
      {"row": 40, "column": 36, "value": 62},
      {"row": 41, "column": 36, "value": 62},
      {"row": 42, "column": 36, "value": 63},
      {"row": 43, "column": 36, "value": 64},
      {"row": 44, "column": 36, "value": 64},
      {"row": 45, "column": 36, "value": 65},
      {"row": 46, "column": 36, "value": 65},
      {"row": 47, "column": 36, "value": 66},
      {"row": 48, "column": 36, "value": 67},
      {"row": 49, "column": 36, "value": 67},
      {"row": 50, "column": 36, "value": 68},
      {"row": 51, "column": 36, "value": 69},
      {"row": 52, "column": 36, "value": 69},
      {"row": 53, "column": 36, "value": 70},
      {"row": 54, "column": 36, "value": 71},
      {"row": 55, "column": 36, "value": 71},
      {"row": 56, "column": 36, "value": 72},
      {"row": 57, "column": 36, "value": 72},
      {"row": 58, "column": 36, "value": 73},
      {"row": 59, "column": 36, "value": 74},
      {"row": 60, "column": 36, "value": 74},
      {"row": 61, "column": 36, "value": 75},
      {"row": 62, "column": 36, "value": 76},
      {"row": 63, "column": 36, "value": 76},
      {"row": 64, "column": 36, "value": 77},
      {"row": 65, "column": 36, "value": 78},
      {"row": 66, "column": 36, "value": 78},
      {"row": 67, "column": 36, "value": 79},
      {"row": 68, "column": 36, "value": 80},
      {"row": 69, "column": 36, "value": 80},
      {"row": 70, "column": 36, "value": 81},
      {"row": 71, "column": 36, "value": 81},
      {"row": 72, "column": 36, "value": 82},
      {"row": 73, "column": 36, "value": 83},
      {"row": 74, "column": 36, "value": 83},
      {"row": 75, "column": 36, "value": 84},
      {"row": 76, "column": 36, "value": 85},
      {"row": 77, "column": 36, "value": 85},
      {"row": 78, "column": 36, "value": 86},
      {"row": 79, "column": 36, "value": 87},
      {"row": 80, "column": 36, "value": 87},
      {"row": 81, "column": 36, "value": 88},
      {"row": 82, "column": 36, "value": 88},
      {"row": 83, "column": 36, "value": 89},
      {"row": 84, "column": 36, "value": 90},
      {"row": 85, "column": 36, "value": 90},
      {"row": 86, "column": 36, "value": 91},
      {"row": 87, "column": 36, "value": 92},
      {"row": 88, "column": 36, "value": 92},
      {"row": 89, "column": 36, "value": 93},
      {"row": 90, "column": 36, "value": 94},
      {"row": 91, "column": 36, "value": 94},
      {"row": 92, "column": 36, "value": 95},
      {"row": 93, "column": 36, "value": 96},
      {"row": 94, "column": 36, "value": 96},
      {"row": 95, "column": 36, "value": 97},
      {"row": 96, "column": 36, "value": 97},
      {"row": 97, "column": 36, "value": 98},
      {"row": 98, "column": 36, "value": 99},
      {"row": 99, "column": 36, "value": 99},
      {"row": 37, "column": 37, "value": 60},
      {"row": 38, "column": 37, "value": 61},
      {"row": 39, "column": 37, "value": 62},
      {"row": 40, "column": 37, "value": 62},
      {"row": 41, "column": 37, "value": 63},
      {"row": 42, "column": 37, "value": 63},
      {"row": 43, "column": 37, "value": 64},
      {"row": 44, "column": 37, "value": 65},
      {"row": 45, "column": 37, "value": 65},
      {"row": 46, "column": 37, "value": 66},
      {"row": 47, "column": 37, "value": 67},
      {"row": 48, "column": 37, "value": 67},
      {"row": 49, "column": 37, "value": 68},
      {"row": 50, "column": 37, "value": 69},
      {"row": 51, "column": 37, "value": 69},
      {"row": 52, "column": 37, "value": 70},
      {"row": 53, "column": 37, "value": 70},
      {"row": 54, "column": 37, "value": 71},
      {"row": 55, "column": 37, "value": 72},
      {"row": 56, "column": 37, "value": 72},
      {"row": 57, "column": 37, "value": 73},
      {"row": 58, "column": 37, "value": 74},
      {"row": 59, "column": 37, "value": 74},
      {"row": 60, "column": 37, "value": 75},
      {"row": 61, "column": 37, "value": 75},
      {"row": 62, "column": 37, "value": 76},
      {"row": 63, "column": 37, "value": 77},
      {"row": 64, "column": 37, "value": 77},
      {"row": 65, "column": 37, "value": 78},
      {"row": 66, "column": 37, "value": 79},
      {"row": 67, "column": 37, "value": 79},
      {"row": 68, "column": 37, "value": 80},
      {"row": 69, "column": 37, "value": 80},
      {"row": 70, "column": 37, "value": 81},
      {"row": 71, "column": 37, "value": 82},
      {"row": 72, "column": 37, "value": 82},
      {"row": 73, "column": 37, "value": 83},
      {"row": 74, "column": 37, "value": 84},
      {"row": 75, "column": 37, "value": 84},
      {"row": 76, "column": 37, "value": 85},
      {"row": 77, "column": 37, "value": 86},
      {"row": 78, "column": 37, "value": 86},
      {"row": 79, "column": 37, "value": 87},
      {"row": 80, "column": 37, "value": 87},
      {"row": 81, "column": 37, "value": 88},
      {"row": 82, "column": 37, "value": 89},
      {"row": 83, "column": 37, "value": 89},
      {"row": 84, "column": 37, "value": 90},
      {"row": 85, "column": 37, "value": 91},
      {"row": 86, "column": 37, "value": 91},
      {"row": 87, "column": 37, "value": 92},
      {"row": 88, "column": 37, "value": 92},
      {"row": 89, "column": 37, "value": 93},
      {"row": 90, "column": 37, "value": 94},
      {"row": 91, "column": 37, "value": 94},
      {"row": 92, "column": 37, "value": 95},
      {"row": 93, "column": 37, "value": 96},
      {"row": 94, "column": 37, "value": 96},
      {"row": 95, "column": 37, "value": 97},
      {"row": 96, "column": 37, "value": 97},
      {"row": 97, "column": 37, "value": 98},
      {"row": 98, "column": 37, "value": 99},
      {"row": 99, "column": 37, "value": 99},
      {"row": 38, "column": 38, "value": 62},
      {"row": 39, "column": 38, "value": 62},
      {"row": 40, "column": 38, "value": 63},
      {"row": 41, "column": 38, "value": 63},
      {"row": 42, "column": 38, "value": 64},
      {"row": 43, "column": 38, "value": 65},
      {"row": 44, "column": 38, "value": 65},
      {"row": 45, "column": 38, "value": 66},
      {"row": 46, "column": 38, "value": 67},
      {"row": 47, "column": 38, "value": 67},
      {"row": 48, "column": 38, "value": 68},
      {"row": 49, "column": 38, "value": 68},
      {"row": 50, "column": 38, "value": 69},
      {"row": 51, "column": 38, "value": 70},
      {"row": 52, "column": 38, "value": 70},
      {"row": 53, "column": 38, "value": 71},
      {"row": 54, "column": 38, "value": 71},
      {"row": 55, "column": 38, "value": 72},
      {"row": 56, "column": 38, "value": 73},
      {"row": 57, "column": 38, "value": 73},
      {"row": 58, "column": 38, "value": 74},
      {"row": 59, "column": 38, "value": 75},
      {"row": 60, "column": 38, "value": 75},
      {"row": 61, "column": 38, "value": 76},
      {"row": 62, "column": 38, "value": 76},
      {"row": 63, "column": 38, "value": 77},
      {"row": 64, "column": 38, "value": 78},
      {"row": 65, "column": 38, "value": 78},
      {"row": 66, "column": 38, "value": 79},
      {"row": 67, "column": 38, "value": 80},
      {"row": 68, "column": 38, "value": 80},
      {"row": 69, "column": 38, "value": 81},
      {"row": 70, "column": 38, "value": 81},
      {"row": 71, "column": 38, "value": 82},
      {"row": 72, "column": 38, "value": 83},
      {"row": 73, "column": 38, "value": 83},
      {"row": 74, "column": 38, "value": 84},
      {"row": 75, "column": 38, "value": 85},
      {"row": 76, "column": 38, "value": 85},
      {"row": 77, "column": 38, "value": 86},
      {"row": 78, "column": 38, "value": 86},
      {"row": 79, "column": 38, "value": 87},
      {"row": 80, "column": 38, "value": 88},
      {"row": 81, "column": 38, "value": 88},
      {"row": 82, "column": 38, "value": 89},
      {"row": 83, "column": 38, "value": 89},
      {"row": 84, "column": 38, "value": 90},
      {"row": 85, "column": 38, "value": 91},
      {"row": 86, "column": 38, "value": 91},
      {"row": 87, "column": 38, "value": 92},
      {"row": 88, "column": 38, "value": 93},
      {"row": 89, "column": 38, "value": 93},
      {"row": 90, "column": 38, "value": 94},
      {"row": 91, "column": 38, "value": 94},
      {"row": 92, "column": 38, "value": 95},
      {"row": 93, "column": 38, "value": 96},
      {"row": 94, "column": 38, "value": 96},
      {"row": 95, "column": 38, "value": 97},
      {"row": 96, "column": 38, "value": 98},
      {"row": 97, "column": 38, "value": 98},
      {"row": 98, "column": 38, "value": 99},
      {"row": 99, "column": 38, "value": 99},
      {"row": 39, "column": 39, "value": 63},
      {"row": 40, "column": 39, "value": 63},
      {"row": 41, "column": 39, "value": 64},
      {"row": 42, "column": 39, "value": 65},
      {"row": 43, "column": 39, "value": 65},
      {"row": 44, "column": 39, "value": 66},
      {"row": 45, "column": 39, "value": 66},
      {"row": 46, "column": 39, "value": 67},
      {"row": 47, "column": 39, "value": 68},
      {"row": 48, "column": 39, "value": 68},
      {"row": 49, "column": 39, "value": 69},
      {"row": 50, "column": 39, "value": 70},
      {"row": 51, "column": 39, "value": 70},
      {"row": 52, "column": 39, "value": 71},
      {"row": 53, "column": 39, "value": 71},
      {"row": 54, "column": 39, "value": 72},
      {"row": 55, "column": 39, "value": 73},
      {"row": 56, "column": 39, "value": 73},
      {"row": 57, "column": 39, "value": 74},
      {"row": 58, "column": 39, "value": 74},
      {"row": 59, "column": 39, "value": 75},
      {"row": 60, "column": 39, "value": 76},
      {"row": 61, "column": 39, "value": 76},
      {"row": 62, "column": 39, "value": 77},
      {"row": 63, "column": 39, "value": 77},
      {"row": 64, "column": 39, "value": 78},
      {"row": 65, "column": 39, "value": 79},
      {"row": 66, "column": 39, "value": 79},
      {"row": 67, "column": 39, "value": 80},
      {"row": 68, "column": 39, "value": 80},
      {"row": 69, "column": 39, "value": 81},
      {"row": 70, "column": 39, "value": 82},
      {"row": 71, "column": 39, "value": 82},
      {"row": 72, "column": 39, "value": 83},
      {"row": 73, "column": 39, "value": 84},
      {"row": 74, "column": 39, "value": 84},
      {"row": 75, "column": 39, "value": 85},
      {"row": 76, "column": 39, "value": 85},
      {"row": 77, "column": 39, "value": 86},
      {"row": 78, "column": 39, "value": 87},
      {"row": 79, "column": 39, "value": 87},
      {"row": 80, "column": 39, "value": 88},
      {"row": 81, "column": 39, "value": 88},
      {"row": 82, "column": 39, "value": 89},
      {"row": 83, "column": 39, "value": 90},
      {"row": 84, "column": 39, "value": 90},
      {"row": 85, "column": 39, "value": 91},
      {"row": 86, "column": 39, "value": 91},
      {"row": 87, "column": 39, "value": 92},
      {"row": 88, "column": 39, "value": 93},
      {"row": 89, "column": 39, "value": 93},
      {"row": 90, "column": 39, "value": 94},
      {"row": 91, "column": 39, "value": 95},
      {"row": 92, "column": 39, "value": 95},
      {"row": 93, "column": 39, "value": 96},
      {"row": 94, "column": 39, "value": 96},
      {"row": 95, "column": 39, "value": 97},
      {"row": 96, "column": 39, "value": 98},
      {"row": 97, "column": 39, "value": 98},
      {"row": 98, "column": 39, "value": 99},
      {"row": 99, "column": 39, "value": 99},
      {"row": 40, "column": 40, "value": 64},
      {"row": 41, "column": 40, "value": 65},
      {"row": 42, "column": 40, "value": 65},
      {"row": 43, "column": 40, "value": 66},
      {"row": 44, "column": 40, "value": 66},
      {"row": 45, "column": 40, "value": 67},
      {"row": 46, "column": 40, "value": 68},
      {"row": 47, "column": 40, "value": 68},
      {"row": 48, "column": 40, "value": 69},
      {"row": 49, "column": 40, "value": 69},
      {"row": 50, "column": 40, "value": 70},
      {"row": 51, "column": 40, "value": 71},
      {"row": 52, "column": 40, "value": 71},
      {"row": 53, "column": 40, "value": 72},
      {"row": 54, "column": 40, "value": 72},
      {"row": 55, "column": 40, "value": 73},
      {"row": 56, "column": 40, "value": 74},
      {"row": 57, "column": 40, "value": 74},
      {"row": 58, "column": 40, "value": 75},
      {"row": 59, "column": 40, "value": 75},
      {"row": 60, "column": 40, "value": 76},
      {"row": 61, "column": 40, "value": 77},
      {"row": 62, "column": 40, "value": 77},
      {"row": 63, "column": 40, "value": 78},
      {"row": 64, "column": 40, "value": 78},
      {"row": 65, "column": 40, "value": 79},
      {"row": 66, "column": 40, "value": 80},
      {"row": 67, "column": 40, "value": 80},
      {"row": 68, "column": 40, "value": 81},
      {"row": 69, "column": 40, "value": 81},
      {"row": 70, "column": 40, "value": 82},
      {"row": 71, "column": 40, "value": 83},
      {"row": 72, "column": 40, "value": 83},
      {"row": 73, "column": 40, "value": 84},
      {"row": 74, "column": 40, "value": 84},
      {"row": 75, "column": 40, "value": 85},
      {"row": 76, "column": 40, "value": 86},
      {"row": 77, "column": 40, "value": 86},
      {"row": 78, "column": 40, "value": 87},
      {"row": 79, "column": 40, "value": 87},
      {"row": 80, "column": 40, "value": 88},
      {"row": 81, "column": 40, "value": 89},
      {"row": 82, "column": 40, "value": 89},
      {"row": 83, "column": 40, "value": 90},
      {"row": 84, "column": 40, "value": 90},
      {"row": 85, "column": 40, "value": 91},
      {"row": 86, "column": 40, "value": 92},
      {"row": 87, "column": 40, "value": 92},
      {"row": 88, "column": 40, "value": 93},
      {"row": 89, "column": 40, "value": 93},
      {"row": 90, "column": 40, "value": 94},
      {"row": 91, "column": 40, "value": 95},
      {"row": 92, "column": 40, "value": 95},
      {"row": 93, "column": 40, "value": 96},
      {"row": 94, "column": 40, "value": 96},
      {"row": 95, "column": 40, "value": 97},
      {"row": 96, "column": 40, "value": 98},
      {"row": 97, "column": 40, "value": 98},
      {"row": 98, "column": 40, "value": 99},
      {"row": 99, "column": 40, "value": 99},
      {"row": 41, "column": 41, "value": 65},
      {"row": 42, "column": 41, "value": 66},
      {"row": 43, "column": 41, "value": 66},
      {"row": 44, "column": 41, "value": 67},
      {"row": 45, "column": 41, "value": 68},
      {"row": 46, "column": 41, "value": 68},
      {"row": 47, "column": 41, "value": 69},
      {"row": 48, "column": 41, "value": 69},
      {"row": 49, "column": 41, "value": 70},
      {"row": 50, "column": 41, "value": 71},
      {"row": 51, "column": 41, "value": 71},
      {"row": 52, "column": 41, "value": 72},
      {"row": 53, "column": 41, "value": 72},
      {"row": 54, "column": 41, "value": 73},
      {"row": 55, "column": 41, "value": 73},
      {"row": 56, "column": 41, "value": 74},
      {"row": 57, "column": 41, "value": 75},
      {"row": 58, "column": 41, "value": 75},
      {"row": 59, "column": 41, "value": 76},
      {"row": 60, "column": 41, "value": 76},
      {"row": 61, "column": 41, "value": 77},
      {"row": 62, "column": 41, "value": 78},
      {"row": 63, "column": 41, "value": 78},
      {"row": 64, "column": 41, "value": 79},
      {"row": 65, "column": 41, "value": 79},
      {"row": 66, "column": 41, "value": 80},
      {"row": 67, "column": 41, "value": 81},
      {"row": 68, "column": 41, "value": 81},
      {"row": 69, "column": 41, "value": 82},
      {"row": 70, "column": 41, "value": 82},
      {"row": 71, "column": 41, "value": 83},
      {"row": 72, "column": 41, "value": 83},
      {"row": 73, "column": 41, "value": 84},
      {"row": 74, "column": 41, "value": 85},
      {"row": 75, "column": 41, "value": 85},
      {"row": 76, "column": 41, "value": 86},
      {"row": 77, "column": 41, "value": 86},
      {"row": 78, "column": 41, "value": 87},
      {"row": 79, "column": 41, "value": 88},
      {"row": 80, "column": 41, "value": 88},
      {"row": 81, "column": 41, "value": 89},
      {"row": 82, "column": 41, "value": 89},
      {"row": 83, "column": 41, "value": 90},
      {"row": 84, "column": 41, "value": 91},
      {"row": 85, "column": 41, "value": 91},
      {"row": 86, "column": 41, "value": 92},
      {"row": 87, "column": 41, "value": 92},
      {"row": 88, "column": 41, "value": 93},
      {"row": 89, "column": 41, "value": 94},
      {"row": 90, "column": 41, "value": 94},
      {"row": 91, "column": 41, "value": 95},
      {"row": 92, "column": 41, "value": 95},
      {"row": 93, "column": 41, "value": 96},
      {"row": 94, "column": 41, "value": 96},
      {"row": 95, "column": 41, "value": 97},
      {"row": 96, "column": 41, "value": 98},
      {"row": 97, "column": 41, "value": 98},
      {"row": 98, "column": 41, "value": 99},
      {"row": 99, "column": 41, "value": 99},
      {"row": 42, "column": 42, "value": 66},
      {"row": 43, "column": 42, "value": 67},
      {"row": 44, "column": 42, "value": 68},
      {"row": 45, "column": 42, "value": 68},
      {"row": 46, "column": 42, "value": 69},
      {"row": 47, "column": 42, "value": 69},
      {"row": 48, "column": 42, "value": 70},
      {"row": 49, "column": 42, "value": 70},
      {"row": 50, "column": 42, "value": 71},
      {"row": 51, "column": 42, "value": 72},
      {"row": 52, "column": 42, "value": 72},
      {"row": 53, "column": 42, "value": 73},
      {"row": 54, "column": 42, "value": 73},
      {"row": 55, "column": 42, "value": 74},
      {"row": 56, "column": 42, "value": 74},
      {"row": 57, "column": 42, "value": 75},
      {"row": 58, "column": 42, "value": 76},
      {"row": 59, "column": 42, "value": 76},
      {"row": 60, "column": 42, "value": 77},
      {"row": 61, "column": 42, "value": 77},
      {"row": 62, "column": 42, "value": 78},
      {"row": 63, "column": 42, "value": 79},
      {"row": 64, "column": 42, "value": 79},
      {"row": 65, "column": 42, "value": 80},
      {"row": 66, "column": 42, "value": 80},
      {"row": 67, "column": 42, "value": 81},
      {"row": 68, "column": 42, "value": 81},
      {"row": 69, "column": 42, "value": 82},
      {"row": 70, "column": 42, "value": 83},
      {"row": 71, "column": 42, "value": 83},
      {"row": 72, "column": 42, "value": 84},
      {"row": 73, "column": 42, "value": 84},
      {"row": 74, "column": 42, "value": 85},
      {"row": 75, "column": 42, "value": 86},
      {"row": 76, "column": 42, "value": 86},
      {"row": 77, "column": 42, "value": 87},
      {"row": 78, "column": 42, "value": 87},
      {"row": 79, "column": 42, "value": 88},
      {"row": 80, "column": 42, "value": 88},
      {"row": 81, "column": 42, "value": 89},
      {"row": 82, "column": 42, "value": 90},
      {"row": 83, "column": 42, "value": 90},
      {"row": 84, "column": 42, "value": 91},
      {"row": 85, "column": 42, "value": 91},
      {"row": 86, "column": 42, "value": 92},
      {"row": 87, "column": 42, "value": 92},
      {"row": 88, "column": 42, "value": 93},
      {"row": 89, "column": 42, "value": 94},
      {"row": 90, "column": 42, "value": 94},
      {"row": 91, "column": 42, "value": 95},
      {"row": 92, "column": 42, "value": 95},
      {"row": 93, "column": 42, "value": 96},
      {"row": 94, "column": 42, "value": 97},
      {"row": 95, "column": 42, "value": 97},
      {"row": 96, "column": 42, "value": 98},
      {"row": 97, "column": 42, "value": 98},
      {"row": 98, "column": 42, "value": 99},
      {"row": 99, "column": 42, "value": 99},
      {"row": 43, "column": 43, "value": 68},
      {"row": 44, "column": 43, "value": 68},
      {"row": 45, "column": 43, "value": 69},
      {"row": 46, "column": 43, "value": 69},
      {"row": 47, "column": 43, "value": 70},
      {"row": 48, "column": 43, "value": 70},
      {"row": 49, "column": 43, "value": 71},
      {"row": 50, "column": 43, "value": 72},
      {"row": 51, "column": 43, "value": 72},
      {"row": 52, "column": 43, "value": 73},
      {"row": 53, "column": 43, "value": 73},
      {"row": 54, "column": 43, "value": 74},
      {"row": 55, "column": 43, "value": 74},
      {"row": 56, "column": 43, "value": 75},
      {"row": 57, "column": 43, "value": 75},
      {"row": 58, "column": 43, "value": 76},
      {"row": 59, "column": 43, "value": 77},
      {"row": 60, "column": 43, "value": 77},
      {"row": 61, "column": 43, "value": 78},
      {"row": 62, "column": 43, "value": 78},
      {"row": 63, "column": 43, "value": 79},
      {"row": 64, "column": 43, "value": 79},
      {"row": 65, "column": 43, "value": 80},
      {"row": 66, "column": 43, "value": 81},
      {"row": 67, "column": 43, "value": 81},
      {"row": 68, "column": 43, "value": 82},
      {"row": 69, "column": 43, "value": 82},
      {"row": 70, "column": 43, "value": 83},
      {"row": 71, "column": 43, "value": 83},
      {"row": 72, "column": 43, "value": 84},
      {"row": 73, "column": 43, "value": 85},
      {"row": 74, "column": 43, "value": 85},
      {"row": 75, "column": 43, "value": 86},
      {"row": 76, "column": 43, "value": 86},
      {"row": 77, "column": 43, "value": 87},
      {"row": 78, "column": 43, "value": 87},
      {"row": 79, "column": 43, "value": 88},
      {"row": 80, "column": 43, "value": 89},
      {"row": 81, "column": 43, "value": 89},
      {"row": 82, "column": 43, "value": 90},
      {"row": 83, "column": 43, "value": 90},
      {"row": 84, "column": 43, "value": 91},
      {"row": 85, "column": 43, "value": 91},
      {"row": 86, "column": 43, "value": 92},
      {"row": 87, "column": 43, "value": 93},
      {"row": 88, "column": 43, "value": 93},
      {"row": 89, "column": 43, "value": 94},
      {"row": 90, "column": 43, "value": 94},
      {"row": 91, "column": 43, "value": 95},
      {"row": 92, "column": 43, "value": 95},
      {"row": 93, "column": 43, "value": 96},
      {"row": 94, "column": 43, "value": 97},
      {"row": 95, "column": 43, "value": 97},
      {"row": 96, "column": 43, "value": 98},
      {"row": 97, "column": 43, "value": 98},
      {"row": 98, "column": 43, "value": 99},
      {"row": 99, "column": 43, "value": 99},
      {"row": 44, "column": 44, "value": 69},
      {"row": 45, "column": 44, "value": 69},
      {"row": 46, "column": 44, "value": 70},
      {"row": 47, "column": 44, "value": 70},
      {"row": 48, "column": 44, "value": 71},
      {"row": 49, "column": 44, "value": 71},
      {"row": 50, "column": 44, "value": 72},
      {"row": 51, "column": 44, "value": 73},
      {"row": 52, "column": 44, "value": 73},
      {"row": 53, "column": 44, "value": 74},
      {"row": 54, "column": 44, "value": 74},
      {"row": 55, "column": 44, "value": 75},
      {"row": 56, "column": 44, "value": 75},
      {"row": 57, "column": 44, "value": 76},
      {"row": 58, "column": 44, "value": 76},
      {"row": 59, "column": 44, "value": 77},
      {"row": 60, "column": 44, "value": 78},
      {"row": 61, "column": 44, "value": 78},
      {"row": 62, "column": 44, "value": 79},
      {"row": 63, "column": 44, "value": 79},
      {"row": 64, "column": 44, "value": 80},
      {"row": 65, "column": 44, "value": 80},
      {"row": 66, "column": 44, "value": 81},
      {"row": 67, "column": 44, "value": 82},
      {"row": 68, "column": 44, "value": 82},
      {"row": 69, "column": 44, "value": 83},
      {"row": 70, "column": 44, "value": 83},
      {"row": 71, "column": 44, "value": 84},
      {"row": 72, "column": 44, "value": 84},
      {"row": 73, "column": 44, "value": 85},
      {"row": 74, "column": 44, "value": 85},
      {"row": 75, "column": 44, "value": 86},
      {"row": 76, "column": 44, "value": 87},
      {"row": 77, "column": 44, "value": 87},
      {"row": 78, "column": 44, "value": 88},
      {"row": 79, "column": 44, "value": 88},
      {"row": 80, "column": 44, "value": 89},
      {"row": 81, "column": 44, "value": 89},
      {"row": 82, "column": 44, "value": 90},
      {"row": 83, "column": 44, "value": 90},
      {"row": 84, "column": 44, "value": 91},
      {"row": 85, "column": 44, "value": 92},
      {"row": 86, "column": 44, "value": 92},
      {"row": 87, "column": 44, "value": 93},
      {"row": 88, "column": 44, "value": 93},
      {"row": 89, "column": 44, "value": 94},
      {"row": 90, "column": 44, "value": 94},
      {"row": 91, "column": 44, "value": 95},
      {"row": 92, "column": 44, "value": 96},
      {"row": 93, "column": 44, "value": 96},
      {"row": 94, "column": 44, "value": 97},
      {"row": 95, "column": 44, "value": 97},
      {"row": 96, "column": 44, "value": 98},
      {"row": 97, "column": 44, "value": 98},
      {"row": 98, "column": 44, "value": 99},
      {"row": 99, "column": 44, "value": 99},
      {"row": 45, "column": 45, "value": 70},
      {"row": 46, "column": 45, "value": 70},
      {"row": 47, "column": 45, "value": 71},
      {"row": 48, "column": 45, "value": 71},
      {"row": 49, "column": 45, "value": 72},
      {"row": 50, "column": 45, "value": 73},
      {"row": 51, "column": 45, "value": 73},
      {"row": 52, "column": 45, "value": 74},
      {"row": 53, "column": 45, "value": 74},
      {"row": 54, "column": 45, "value": 75},
      {"row": 55, "column": 45, "value": 75},
      {"row": 56, "column": 45, "value": 76},
      {"row": 57, "column": 45, "value": 76},
      {"row": 58, "column": 45, "value": 77},
      {"row": 59, "column": 45, "value": 77},
      {"row": 60, "column": 45, "value": 78},
      {"row": 61, "column": 45, "value": 79},
      {"row": 62, "column": 45, "value": 79},
      {"row": 63, "column": 45, "value": 80},
      {"row": 64, "column": 45, "value": 80},
      {"row": 65, "column": 45, "value": 81},
      {"row": 66, "column": 45, "value": 81},
      {"row": 67, "column": 45, "value": 82},
      {"row": 68, "column": 45, "value": 82},
      {"row": 69, "column": 45, "value": 83},
      {"row": 70, "column": 45, "value": 84},
      {"row": 71, "column": 45, "value": 84},
      {"row": 72, "column": 45, "value": 85},
      {"row": 73, "column": 45, "value": 85},
      {"row": 74, "column": 45, "value": 86},
      {"row": 75, "column": 45, "value": 86},
      {"row": 76, "column": 45, "value": 87},
      {"row": 77, "column": 45, "value": 87},
      {"row": 78, "column": 45, "value": 88},
      {"row": 79, "column": 45, "value": 88},
      {"row": 80, "column": 45, "value": 89},
      {"row": 81, "column": 45, "value": 90},
      {"row": 82, "column": 45, "value": 90},
      {"row": 83, "column": 45, "value": 91},
      {"row": 84, "column": 45, "value": 91},
      {"row": 85, "column": 45, "value": 92},
      {"row": 86, "column": 45, "value": 92},
      {"row": 87, "column": 45, "value": 93},
      {"row": 88, "column": 45, "value": 93},
      {"row": 89, "column": 45, "value": 94},
      {"row": 90, "column": 45, "value": 95},
      {"row": 91, "column": 45, "value": 95},
      {"row": 92, "column": 45, "value": 96},
      {"row": 93, "column": 45, "value": 96},
      {"row": 94, "column": 45, "value": 97},
      {"row": 95, "column": 45, "value": 97},
      {"row": 96, "column": 45, "value": 98},
      {"row": 97, "column": 45, "value": 98},
      {"row": 98, "column": 45, "value": 99},
      {"row": 99, "column": 45, "value": 99},
      {"row": 46, "column": 46, "value": 71},
      {"row": 47, "column": 46, "value": 71},
      {"row": 48, "column": 46, "value": 72},
      {"row": 49, "column": 46, "value": 72},
      {"row": 50, "column": 46, "value": 73},
      {"row": 51, "column": 46, "value": 74},
      {"row": 52, "column": 46, "value": 74},
      {"row": 53, "column": 46, "value": 75},
      {"row": 54, "column": 46, "value": 75},
      {"row": 55, "column": 46, "value": 76},
      {"row": 56, "column": 46, "value": 76},
      {"row": 57, "column": 46, "value": 77},
      {"row": 58, "column": 46, "value": 77},
      {"row": 59, "column": 46, "value": 78},
      {"row": 60, "column": 46, "value": 78},
      {"row": 61, "column": 46, "value": 79},
      {"row": 62, "column": 46, "value": 79},
      {"row": 63, "column": 46, "value": 80},
      {"row": 64, "column": 46, "value": 81},
      {"row": 65, "column": 46, "value": 81},
      {"row": 66, "column": 46, "value": 82},
      {"row": 67, "column": 46, "value": 82},
      {"row": 68, "column": 46, "value": 83},
      {"row": 69, "column": 46, "value": 83},
      {"row": 70, "column": 46, "value": 84},
      {"row": 71, "column": 46, "value": 84},
      {"row": 72, "column": 46, "value": 85},
      {"row": 73, "column": 46, "value": 85},
      {"row": 74, "column": 46, "value": 86},
      {"row": 75, "column": 46, "value": 87},
      {"row": 76, "column": 46, "value": 87},
      {"row": 77, "column": 46, "value": 88},
      {"row": 78, "column": 46, "value": 88},
      {"row": 79, "column": 46, "value": 89},
      {"row": 80, "column": 46, "value": 89},
      {"row": 81, "column": 46, "value": 90},
      {"row": 82, "column": 46, "value": 90},
      {"row": 83, "column": 46, "value": 91},
      {"row": 84, "column": 46, "value": 91},
      {"row": 85, "column": 46, "value": 92},
      {"row": 86, "column": 46, "value": 92},
      {"row": 87, "column": 46, "value": 93},
      {"row": 88, "column": 46, "value": 94},
      {"row": 89, "column": 46, "value": 94},
      {"row": 90, "column": 46, "value": 95},
      {"row": 91, "column": 46, "value": 95},
      {"row": 92, "column": 46, "value": 96},
      {"row": 93, "column": 46, "value": 96},
      {"row": 94, "column": 46, "value": 97},
      {"row": 95, "column": 46, "value": 97},
      {"row": 96, "column": 46, "value": 98},
      {"row": 97, "column": 46, "value": 98},
      {"row": 98, "column": 46, "value": 99},
      {"row": 99, "column": 46, "value": 99},
      {"row": 47, "column": 47, "value": 72},
      {"row": 48, "column": 47, "value": 72},
      {"row": 49, "column": 47, "value": 73},
      {"row": 50, "column": 47, "value": 74},
      {"row": 51, "column": 47, "value": 74},
      {"row": 52, "column": 47, "value": 75},
      {"row": 53, "column": 47, "value": 75},
      {"row": 54, "column": 47, "value": 76},
      {"row": 55, "column": 47, "value": 76},
      {"row": 56, "column": 47, "value": 77},
      {"row": 57, "column": 47, "value": 77},
      {"row": 58, "column": 47, "value": 78},
      {"row": 59, "column": 47, "value": 78},
      {"row": 60, "column": 47, "value": 79},
      {"row": 61, "column": 47, "value": 79},
      {"row": 62, "column": 47, "value": 80},
      {"row": 63, "column": 47, "value": 80},
      {"row": 64, "column": 47, "value": 81},
      {"row": 65, "column": 47, "value": 81},
      {"row": 66, "column": 47, "value": 82},
      {"row": 67, "column": 47, "value": 83},
      {"row": 68, "column": 47, "value": 83},
      {"row": 69, "column": 47, "value": 84},
      {"row": 70, "column": 47, "value": 84},
      {"row": 71, "column": 47, "value": 85},
      {"row": 72, "column": 47, "value": 85},
      {"row": 73, "column": 47, "value": 86},
      {"row": 74, "column": 47, "value": 86},
      {"row": 75, "column": 47, "value": 87},
      {"row": 76, "column": 47, "value": 87},
      {"row": 77, "column": 47, "value": 88},
      {"row": 78, "column": 47, "value": 88},
      {"row": 79, "column": 47, "value": 89},
      {"row": 80, "column": 47, "value": 89},
      {"row": 81, "column": 47, "value": 90},
      {"row": 82, "column": 47, "value": 90},
      {"row": 83, "column": 47, "value": 91},
      {"row": 84, "column": 47, "value": 92},
      {"row": 85, "column": 47, "value": 92},
      {"row": 86, "column": 47, "value": 93},
      {"row": 87, "column": 47, "value": 93},
      {"row": 88, "column": 47, "value": 94},
      {"row": 89, "column": 47, "value": 94},
      {"row": 90, "column": 47, "value": 95},
      {"row": 91, "column": 47, "value": 95},
      {"row": 92, "column": 47, "value": 96},
      {"row": 93, "column": 47, "value": 96},
      {"row": 94, "column": 47, "value": 97},
      {"row": 95, "column": 47, "value": 97},
      {"row": 96, "column": 47, "value": 98},
      {"row": 97, "column": 47, "value": 98},
      {"row": 98, "column": 47, "value": 99},
      {"row": 99, "column": 47, "value": 99},
      {"row": 48, "column": 48, "value": 73},
      {"row": 49, "column": 48, "value": 73},
      {"row": 50, "column": 48, "value": 74},
      {"row": 51, "column": 48, "value": 75},
      {"row": 52, "column": 48, "value": 75},
      {"row": 53, "column": 48, "value": 76},
      {"row": 54, "column": 48, "value": 76},
      {"row": 55, "column": 48, "value": 77},
      {"row": 56, "column": 48, "value": 77},
      {"row": 57, "column": 48, "value": 78},
      {"row": 58, "column": 48, "value": 78},
      {"row": 59, "column": 48, "value": 79},
      {"row": 60, "column": 48, "value": 79},
      {"row": 61, "column": 48, "value": 80},
      {"row": 62, "column": 48, "value": 80},
      {"row": 63, "column": 48, "value": 81},
      {"row": 64, "column": 48, "value": 81},
      {"row": 65, "column": 48, "value": 82},
      {"row": 66, "column": 48, "value": 82},
      {"row": 67, "column": 48, "value": 83},
      {"row": 68, "column": 48, "value": 83},
      {"row": 69, "column": 48, "value": 84},
      {"row": 70, "column": 48, "value": 84},
      {"row": 71, "column": 48, "value": 85},
      {"row": 72, "column": 48, "value": 85},
      {"row": 73, "column": 48, "value": 86},
      {"row": 74, "column": 48, "value": 86},
      {"row": 75, "column": 48, "value": 87},
      {"row": 76, "column": 48, "value": 88},
      {"row": 77, "column": 48, "value": 88},
      {"row": 78, "column": 48, "value": 89},
      {"row": 79, "column": 48, "value": 89},
      {"row": 80, "column": 48, "value": 90},
      {"row": 81, "column": 48, "value": 90},
      {"row": 82, "column": 48, "value": 91},
      {"row": 83, "column": 48, "value": 91},
      {"row": 84, "column": 48, "value": 92},
      {"row": 85, "column": 48, "value": 92},
      {"row": 86, "column": 48, "value": 93},
      {"row": 87, "column": 48, "value": 93},
      {"row": 88, "column": 48, "value": 94},
      {"row": 89, "column": 48, "value": 94},
      {"row": 90, "column": 48, "value": 95},
      {"row": 91, "column": 48, "value": 95},
      {"row": 92, "column": 48, "value": 96},
      {"row": 93, "column": 48, "value": 96},
      {"row": 94, "column": 48, "value": 97},
      {"row": 95, "column": 48, "value": 97},
      {"row": 96, "column": 48, "value": 98},
      {"row": 97, "column": 48, "value": 98},
      {"row": 98, "column": 48, "value": 99},
      {"row": 99, "column": 48, "value": 99},
      {"row": 49, "column": 49, "value": 74},
      {"row": 50, "column": 49, "value": 75},
      {"row": 51, "column": 49, "value": 75},
      {"row": 52, "column": 49, "value": 76},
      {"row": 53, "column": 49, "value": 76},
      {"row": 54, "column": 49, "value": 77},
      {"row": 55, "column": 49, "value": 77},
      {"row": 56, "column": 49, "value": 78},
      {"row": 57, "column": 49, "value": 78},
      {"row": 58, "column": 49, "value": 79},
      {"row": 59, "column": 49, "value": 79},
      {"row": 60, "column": 49, "value": 80},
      {"row": 61, "column": 49, "value": 80},
      {"row": 62, "column": 49, "value": 81},
      {"row": 63, "column": 49, "value": 81},
      {"row": 64, "column": 49, "value": 82},
      {"row": 65, "column": 49, "value": 82},
      {"row": 66, "column": 49, "value": 83},
      {"row": 67, "column": 49, "value": 83},
      {"row": 68, "column": 49, "value": 84},
      {"row": 69, "column": 49, "value": 84},
      {"row": 70, "column": 49, "value": 85},
      {"row": 71, "column": 49, "value": 85},
      {"row": 72, "column": 49, "value": 86},
      {"row": 73, "column": 49, "value": 86},
      {"row": 74, "column": 49, "value": 87},
      {"row": 75, "column": 49, "value": 87},
      {"row": 76, "column": 49, "value": 88},
      {"row": 77, "column": 49, "value": 88},
      {"row": 78, "column": 49, "value": 89},
      {"row": 79, "column": 49, "value": 89},
      {"row": 80, "column": 49, "value": 90},
      {"row": 81, "column": 49, "value": 90},
      {"row": 82, "column": 49, "value": 91},
      {"row": 83, "column": 49, "value": 91},
      {"row": 84, "column": 49, "value": 92},
      {"row": 85, "column": 49, "value": 92},
      {"row": 86, "column": 49, "value": 93},
      {"row": 87, "column": 49, "value": 93},
      {"row": 88, "column": 49, "value": 94},
      {"row": 89, "column": 49, "value": 94},
      {"row": 90, "column": 49, "value": 95},
      {"row": 91, "column": 49, "value": 95},
      {"row": 92, "column": 49, "value": 96},
      {"row": 93, "column": 49, "value": 96},
      {"row": 94, "column": 49, "value": 97},
      {"row": 95, "column": 49, "value": 97},
      {"row": 96, "column": 49, "value": 98},
      {"row": 97, "column": 49, "value": 98},
      {"row": 98, "column": 49, "value": 99},
      {"row": 99, "column": 49, "value": 99},
      {"row": 50, "column": 50, "value": 75},
      {"row": 51, "column": 50, "value": 76},
      {"row": 52, "column": 50, "value": 76},
      {"row": 53, "column": 50, "value": 77},
      {"row": 54, "column": 50, "value": 77},
      {"row": 55, "column": 50, "value": 78},
      {"row": 56, "column": 50, "value": 78},
      {"row": 57, "column": 50, "value": 79},
      {"row": 58, "column": 50, "value": 79},
      {"row": 59, "column": 50, "value": 80},
      {"row": 60, "column": 50, "value": 80},
      {"row": 61, "column": 50, "value": 81},
      {"row": 62, "column": 50, "value": 81},
      {"row": 63, "column": 50, "value": 82},
      {"row": 64, "column": 50, "value": 82},
      {"row": 65, "column": 50, "value": 83},
      {"row": 66, "column": 50, "value": 83},
      {"row": 67, "column": 50, "value": 84},
      {"row": 68, "column": 50, "value": 84},
      {"row": 69, "column": 50, "value": 85},
      {"row": 70, "column": 50, "value": 85},
      {"row": 71, "column": 50, "value": 86},
      {"row": 72, "column": 50, "value": 86},
      {"row": 73, "column": 50, "value": 87},
      {"row": 74, "column": 50, "value": 87},
      {"row": 75, "column": 50, "value": 88},
      {"row": 76, "column": 50, "value": 88},
      {"row": 77, "column": 50, "value": 89},
      {"row": 78, "column": 50, "value": 89},
      {"row": 79, "column": 50, "value": 90},
      {"row": 80, "column": 50, "value": 90},
      {"row": 81, "column": 50, "value": 91},
      {"row": 82, "column": 50, "value": 91},
      {"row": 83, "column": 50, "value": 92},
      {"row": 84, "column": 50, "value": 92},
      {"row": 85, "column": 50, "value": 93},
      {"row": 86, "column": 50, "value": 93},
      {"row": 87, "column": 50, "value": 94},
      {"row": 88, "column": 50, "value": 94},
      {"row": 89, "column": 50, "value": 95},
      {"row": 90, "column": 50, "value": 95},
      {"row": 91, "column": 50, "value": 96},
      {"row": 92, "column": 50, "value": 96},
      {"row": 93, "column": 50, "value": 97},
      {"row": 94, "column": 50, "value": 97},
      {"row": 95, "column": 50, "value": 98},
      {"row": 96, "column": 50, "value": 98},
      {"row": 97, "column": 50, "value": 99},
      {"row": 98, "column": 50, "value": 99},
      {"row": 99, "column": 50, "value": 100},
      {"row": 51, "column": 51, "value": 76},
      {"row": 52, "column": 51, "value": 76},
      {"row": 53, "column": 51, "value": 77},
      {"row": 54, "column": 51, "value": 77},
      {"row": 55, "column": 51, "value": 78},
      {"row": 56, "column": 51, "value": 78},
      {"row": 57, "column": 51, "value": 79},
      {"row": 58, "column": 51, "value": 79},
      {"row": 59, "column": 51, "value": 80},
      {"row": 60, "column": 51, "value": 80},
      {"row": 61, "column": 51, "value": 81},
      {"row": 62, "column": 51, "value": 81},
      {"row": 63, "column": 51, "value": 82},
      {"row": 64, "column": 51, "value": 82},
      {"row": 65, "column": 51, "value": 83},
      {"row": 66, "column": 51, "value": 83},
      {"row": 67, "column": 51, "value": 84},
      {"row": 68, "column": 51, "value": 84},
      {"row": 69, "column": 51, "value": 85},
      {"row": 70, "column": 51, "value": 85},
      {"row": 71, "column": 51, "value": 86},
      {"row": 72, "column": 51, "value": 86},
      {"row": 73, "column": 51, "value": 87},
      {"row": 74, "column": 51, "value": 87},
      {"row": 75, "column": 51, "value": 88},
      {"row": 76, "column": 51, "value": 88},
      {"row": 77, "column": 51, "value": 89},
      {"row": 78, "column": 51, "value": 89},
      {"row": 79, "column": 51, "value": 90},
      {"row": 80, "column": 51, "value": 90},
      {"row": 81, "column": 51, "value": 91},
      {"row": 82, "column": 51, "value": 91},
      {"row": 83, "column": 51, "value": 92},
      {"row": 84, "column": 51, "value": 92},
      {"row": 85, "column": 51, "value": 93},
      {"row": 86, "column": 51, "value": 93},
      {"row": 87, "column": 51, "value": 94},
      {"row": 88, "column": 51, "value": 94},
      {"row": 89, "column": 51, "value": 95},
      {"row": 90, "column": 51, "value": 95},
      {"row": 91, "column": 51, "value": 96},
      {"row": 92, "column": 51, "value": 96},
      {"row": 93, "column": 51, "value": 97},
      {"row": 94, "column": 51, "value": 97},
      {"row": 95, "column": 51, "value": 98},
      {"row": 96, "column": 51, "value": 98},
      {"row": 97, "column": 51, "value": 99},
      {"row": 98, "column": 51, "value": 99},
      {"row": 99, "column": 51, "value": 100},
      {"row": 52, "column": 52, "value": 77},
      {"row": 53, "column": 52, "value": 77},
      {"row": 54, "column": 52, "value": 78},
      {"row": 55, "column": 52, "value": 78},
      {"row": 56, "column": 52, "value": 79},
      {"row": 57, "column": 52, "value": 79},
      {"row": 58, "column": 52, "value": 80},
      {"row": 59, "column": 52, "value": 80},
      {"row": 60, "column": 52, "value": 81},
      {"row": 61, "column": 52, "value": 81},
      {"row": 62, "column": 52, "value": 82},
      {"row": 63, "column": 52, "value": 82},
      {"row": 64, "column": 52, "value": 83},
      {"row": 65, "column": 52, "value": 83},
      {"row": 66, "column": 52, "value": 84},
      {"row": 67, "column": 52, "value": 84},
      {"row": 68, "column": 52, "value": 85},
      {"row": 69, "column": 52, "value": 85},
      {"row": 70, "column": 52, "value": 86},
      {"row": 71, "column": 52, "value": 86},
      {"row": 72, "column": 52, "value": 87},
      {"row": 73, "column": 52, "value": 87},
      {"row": 74, "column": 52, "value": 88},
      {"row": 75, "column": 52, "value": 88},
      {"row": 76, "column": 52, "value": 88},
      {"row": 77, "column": 52, "value": 89},
      {"row": 78, "column": 52, "value": 89},
      {"row": 79, "column": 52, "value": 90},
      {"row": 80, "column": 52, "value": 90},
      {"row": 81, "column": 52, "value": 91},
      {"row": 82, "column": 52, "value": 91},
      {"row": 83, "column": 52, "value": 92},
      {"row": 84, "column": 52, "value": 92},
      {"row": 85, "column": 52, "value": 93},
      {"row": 86, "column": 52, "value": 93},
      {"row": 87, "column": 52, "value": 94},
      {"row": 88, "column": 52, "value": 94},
      {"row": 89, "column": 52, "value": 95},
      {"row": 90, "column": 52, "value": 95},
      {"row": 91, "column": 52, "value": 96},
      {"row": 92, "column": 52, "value": 96},
      {"row": 93, "column": 52, "value": 97},
      {"row": 94, "column": 52, "value": 97},
      {"row": 95, "column": 52, "value": 98},
      {"row": 96, "column": 52, "value": 98},
      {"row": 97, "column": 52, "value": 99},
      {"row": 98, "column": 52, "value": 99},
      {"row": 99, "column": 52, "value": 100},
      {"row": 53, "column": 53, "value": 78},
      {"row": 54, "column": 53, "value": 78},
      {"row": 55, "column": 53, "value": 79},
      {"row": 56, "column": 53, "value": 79},
      {"row": 57, "column": 53, "value": 80},
      {"row": 58, "column": 53, "value": 80},
      {"row": 59, "column": 53, "value": 81},
      {"row": 60, "column": 53, "value": 81},
      {"row": 61, "column": 53, "value": 82},
      {"row": 62, "column": 53, "value": 82},
      {"row": 63, "column": 53, "value": 83},
      {"row": 64, "column": 53, "value": 83},
      {"row": 65, "column": 53, "value": 84},
      {"row": 66, "column": 53, "value": 84},
      {"row": 67, "column": 53, "value": 84},
      {"row": 68, "column": 53, "value": 85},
      {"row": 69, "column": 53, "value": 85},
      {"row": 70, "column": 53, "value": 86},
      {"row": 71, "column": 53, "value": 86},
      {"row": 72, "column": 53, "value": 87},
      {"row": 73, "column": 53, "value": 87},
      {"row": 74, "column": 53, "value": 88},
      {"row": 75, "column": 53, "value": 88},
      {"row": 76, "column": 53, "value": 89},
      {"row": 77, "column": 53, "value": 89},
      {"row": 78, "column": 53, "value": 90},
      {"row": 79, "column": 53, "value": 90},
      {"row": 80, "column": 53, "value": 91},
      {"row": 81, "column": 53, "value": 91},
      {"row": 82, "column": 53, "value": 92},
      {"row": 83, "column": 53, "value": 92},
      {"row": 84, "column": 53, "value": 92},
      {"row": 85, "column": 53, "value": 93},
      {"row": 86, "column": 53, "value": 93},
      {"row": 87, "column": 53, "value": 94},
      {"row": 88, "column": 53, "value": 94},
      {"row": 89, "column": 53, "value": 95},
      {"row": 90, "column": 53, "value": 95},
      {"row": 91, "column": 53, "value": 96},
      {"row": 92, "column": 53, "value": 96},
      {"row": 93, "column": 53, "value": 97},
      {"row": 94, "column": 53, "value": 97},
      {"row": 95, "column": 53, "value": 98},
      {"row": 96, "column": 53, "value": 98},
      {"row": 97, "column": 53, "value": 99},
      {"row": 98, "column": 53, "value": 99},
      {"row": 99, "column": 53, "value": 100},
      {"row": 54, "column": 54, "value": 79},
      {"row": 55, "column": 54, "value": 79},
      {"row": 56, "column": 54, "value": 80},
      {"row": 57, "column": 54, "value": 80},
      {"row": 58, "column": 54, "value": 81},
      {"row": 59, "column": 54, "value": 81},
      {"row": 60, "column": 54, "value": 82},
      {"row": 61, "column": 54, "value": 82},
      {"row": 62, "column": 54, "value": 83},
      {"row": 63, "column": 54, "value": 83},
      {"row": 64, "column": 54, "value": 83},
      {"row": 65, "column": 54, "value": 84},
      {"row": 66, "column": 54, "value": 84},
      {"row": 67, "column": 54, "value": 85},
      {"row": 68, "column": 54, "value": 85},
      {"row": 69, "column": 54, "value": 86},
      {"row": 70, "column": 54, "value": 86},
      {"row": 71, "column": 54, "value": 87},
      {"row": 72, "column": 54, "value": 87},
      {"row": 73, "column": 54, "value": 88},
      {"row": 74, "column": 54, "value": 88},
      {"row": 75, "column": 54, "value": 89},
      {"row": 76, "column": 54, "value": 89},
      {"row": 77, "column": 54, "value": 89},
      {"row": 78, "column": 54, "value": 90},
      {"row": 79, "column": 54, "value": 90},
      {"row": 80, "column": 54, "value": 91},
      {"row": 81, "column": 54, "value": 91},
      {"row": 82, "column": 54, "value": 92},
      {"row": 83, "column": 54, "value": 92},
      {"row": 84, "column": 54, "value": 93},
      {"row": 85, "column": 54, "value": 93},
      {"row": 86, "column": 54, "value": 94},
      {"row": 87, "column": 54, "value": 94},
      {"row": 88, "column": 54, "value": 94},
      {"row": 89, "column": 54, "value": 95},
      {"row": 90, "column": 54, "value": 95},
      {"row": 91, "column": 54, "value": 96},
      {"row": 92, "column": 54, "value": 96},
      {"row": 93, "column": 54, "value": 97},
      {"row": 94, "column": 54, "value": 97},
      {"row": 95, "column": 54, "value": 98},
      {"row": 96, "column": 54, "value": 98},
      {"row": 97, "column": 54, "value": 99},
      {"row": 98, "column": 54, "value": 99},
      {"row": 99, "column": 54, "value": 100},
      {"row": 55, "column": 55, "value": 80},
      {"row": 56, "column": 55, "value": 80},
      {"row": 57, "column": 55, "value": 81},
      {"row": 58, "column": 55, "value": 81},
      {"row": 59, "column": 55, "value": 82},
      {"row": 60, "column": 55, "value": 82},
      {"row": 61, "column": 55, "value": 82},
      {"row": 62, "column": 55, "value": 83},
      {"row": 63, "column": 55, "value": 83},
      {"row": 64, "column": 55, "value": 84},
      {"row": 65, "column": 55, "value": 84},
      {"row": 66, "column": 55, "value": 85},
      {"row": 67, "column": 55, "value": 85},
      {"row": 68, "column": 55, "value": 86},
      {"row": 69, "column": 55, "value": 86},
      {"row": 70, "column": 55, "value": 87},
      {"row": 71, "column": 55, "value": 87},
      {"row": 72, "column": 55, "value": 87},
      {"row": 73, "column": 55, "value": 88},
      {"row": 74, "column": 55, "value": 88},
      {"row": 75, "column": 55, "value": 89},
      {"row": 76, "column": 55, "value": 89},
      {"row": 77, "column": 55, "value": 90},
      {"row": 78, "column": 55, "value": 90},
      {"row": 79, "column": 55, "value": 91},
      {"row": 80, "column": 55, "value": 91},
      {"row": 81, "column": 55, "value": 91},
      {"row": 82, "column": 55, "value": 92},
      {"row": 83, "column": 55, "value": 92},
      {"row": 84, "column": 55, "value": 93},
      {"row": 85, "column": 55, "value": 93},
      {"row": 86, "column": 55, "value": 94},
      {"row": 87, "column": 55, "value": 94},
      {"row": 88, "column": 55, "value": 95},
      {"row": 89, "column": 55, "value": 95},
      {"row": 90, "column": 55, "value": 96},
      {"row": 91, "column": 55, "value": 96},
      {"row": 92, "column": 55, "value": 96},
      {"row": 93, "column": 55, "value": 97},
      {"row": 94, "column": 55, "value": 97},
      {"row": 95, "column": 55, "value": 98},
      {"row": 96, "column": 55, "value": 98},
      {"row": 97, "column": 55, "value": 99},
      {"row": 98, "column": 55, "value": 99},
      {"row": 99, "column": 55, "value": 100},
      {"row": 56, "column": 56, "value": 81},
      {"row": 57, "column": 56, "value": 81},
      {"row": 58, "column": 56, "value": 82},
      {"row": 59, "column": 56, "value": 82},
      {"row": 60, "column": 56, "value": 82},
      {"row": 61, "column": 56, "value": 83},
      {"row": 62, "column": 56, "value": 83},
      {"row": 63, "column": 56, "value": 84},
      {"row": 64, "column": 56, "value": 84},
      {"row": 65, "column": 56, "value": 85},
      {"row": 66, "column": 56, "value": 85},
      {"row": 67, "column": 56, "value": 85},
      {"row": 68, "column": 56, "value": 86},
      {"row": 69, "column": 56, "value": 86},
      {"row": 70, "column": 56, "value": 87},
      {"row": 71, "column": 56, "value": 87},
      {"row": 72, "column": 56, "value": 88},
      {"row": 73, "column": 56, "value": 88},
      {"row": 74, "column": 56, "value": 89},
      {"row": 75, "column": 56, "value": 89},
      {"row": 76, "column": 56, "value": 89},
      {"row": 77, "column": 56, "value": 90},
      {"row": 78, "column": 56, "value": 90},
      {"row": 79, "column": 56, "value": 91},
      {"row": 80, "column": 56, "value": 91},
      {"row": 81, "column": 56, "value": 92},
      {"row": 82, "column": 56, "value": 92},
      {"row": 83, "column": 56, "value": 93},
      {"row": 84, "column": 56, "value": 93},
      {"row": 85, "column": 56, "value": 93},
      {"row": 86, "column": 56, "value": 94},
      {"row": 87, "column": 56, "value": 94},
      {"row": 88, "column": 56, "value": 95},
      {"row": 89, "column": 56, "value": 95},
      {"row": 90, "column": 56, "value": 96},
      {"row": 91, "column": 56, "value": 96},
      {"row": 92, "column": 56, "value": 96},
      {"row": 93, "column": 56, "value": 97},
      {"row": 94, "column": 56, "value": 97},
      {"row": 95, "column": 56, "value": 98},
      {"row": 96, "column": 56, "value": 98},
      {"row": 97, "column": 56, "value": 99},
      {"row": 98, "column": 56, "value": 99},
      {"row": 99, "column": 56, "value": 100},
      {"row": 57, "column": 57, "value": 82},
      {"row": 58, "column": 57, "value": 82},
      {"row": 59, "column": 57, "value": 82},
      {"row": 60, "column": 57, "value": 83},
      {"row": 61, "column": 57, "value": 83},
      {"row": 62, "column": 57, "value": 84},
      {"row": 63, "column": 57, "value": 84},
      {"row": 64, "column": 57, "value": 85},
      {"row": 65, "column": 57, "value": 85},
      {"row": 66, "column": 57, "value": 85},
      {"row": 67, "column": 57, "value": 86},
      {"row": 68, "column": 57, "value": 86},
      {"row": 69, "column": 57, "value": 87},
      {"row": 70, "column": 57, "value": 87},
      {"row": 71, "column": 57, "value": 88},
      {"row": 72, "column": 57, "value": 88},
      {"row": 73, "column": 57, "value": 88},
      {"row": 74, "column": 57, "value": 89},
      {"row": 75, "column": 57, "value": 89},
      {"row": 76, "column": 57, "value": 90},
      {"row": 77, "column": 57, "value": 90},
      {"row": 78, "column": 57, "value": 91},
      {"row": 79, "column": 57, "value": 91},
      {"row": 80, "column": 57, "value": 91},
      {"row": 81, "column": 57, "value": 92},
      {"row": 82, "column": 57, "value": 92},
      {"row": 83, "column": 57, "value": 93},
      {"row": 84, "column": 57, "value": 93},
      {"row": 85, "column": 57, "value": 94},
      {"row": 86, "column": 57, "value": 94},
      {"row": 87, "column": 57, "value": 94},
      {"row": 88, "column": 57, "value": 95},
      {"row": 89, "column": 57, "value": 95},
      {"row": 90, "column": 57, "value": 96},
      {"row": 91, "column": 57, "value": 96},
      {"row": 92, "column": 57, "value": 97},
      {"row": 93, "column": 57, "value": 97},
      {"row": 94, "column": 57, "value": 97},
      {"row": 95, "column": 57, "value": 98},
      {"row": 96, "column": 57, "value": 98},
      {"row": 97, "column": 57, "value": 99},
      {"row": 98, "column": 57, "value": 99},
      {"row": 99, "column": 57, "value": 100},
      {"row": 58, "column": 58, "value": 82},
      {"row": 59, "column": 58, "value": 83},
      {"row": 60, "column": 58, "value": 83},
      {"row": 61, "column": 58, "value": 84},
      {"row": 62, "column": 58, "value": 84},
      {"row": 63, "column": 58, "value": 84},
      {"row": 64, "column": 58, "value": 85},
      {"row": 65, "column": 58, "value": 85},
      {"row": 66, "column": 58, "value": 86},
      {"row": 67, "column": 58, "value": 86},
      {"row": 68, "column": 58, "value": 87},
      {"row": 69, "column": 58, "value": 87},
      {"row": 70, "column": 58, "value": 87},
      {"row": 71, "column": 58, "value": 88},
      {"row": 72, "column": 58, "value": 88},
      {"row": 73, "column": 58, "value": 89},
      {"row": 74, "column": 58, "value": 89},
      {"row": 75, "column": 58, "value": 90},
      {"row": 76, "column": 58, "value": 90},
      {"row": 77, "column": 58, "value": 90},
      {"row": 78, "column": 58, "value": 91},
      {"row": 79, "column": 58, "value": 91},
      {"row": 80, "column": 58, "value": 92},
      {"row": 81, "column": 58, "value": 92},
      {"row": 82, "column": 58, "value": 92},
      {"row": 83, "column": 58, "value": 93},
      {"row": 84, "column": 58, "value": 93},
      {"row": 85, "column": 58, "value": 94},
      {"row": 86, "column": 58, "value": 94},
      {"row": 87, "column": 58, "value": 95},
      {"row": 88, "column": 58, "value": 95},
      {"row": 89, "column": 58, "value": 95},
      {"row": 90, "column": 58, "value": 96},
      {"row": 91, "column": 58, "value": 96},
      {"row": 92, "column": 58, "value": 97},
      {"row": 93, "column": 58, "value": 97},
      {"row": 94, "column": 58, "value": 97},
      {"row": 95, "column": 58, "value": 98},
      {"row": 96, "column": 58, "value": 98},
      {"row": 97, "column": 58, "value": 99},
      {"row": 98, "column": 58, "value": 99},
      {"row": 99, "column": 58, "value": 100},
      {"row": 59, "column": 59, "value": 83},
      {"row": 60, "column": 59, "value": 84},
      {"row": 61, "column": 59, "value": 84},
      {"row": 62, "column": 59, "value": 84},
      {"row": 63, "column": 59, "value": 85},
      {"row": 64, "column": 59, "value": 85},
      {"row": 65, "column": 59, "value": 86},
      {"row": 66, "column": 59, "value": 86},
      {"row": 67, "column": 59, "value": 86},
      {"row": 68, "column": 59, "value": 87},
      {"row": 69, "column": 59, "value": 87},
      {"row": 70, "column": 59, "value": 88},
      {"row": 71, "column": 59, "value": 88},
      {"row": 72, "column": 59, "value": 89},
      {"row": 73, "column": 59, "value": 89},
      {"row": 74, "column": 59, "value": 89},
      {"row": 75, "column": 59, "value": 90},
      {"row": 76, "column": 59, "value": 90},
      {"row": 77, "column": 59, "value": 91},
      {"row": 78, "column": 59, "value": 91},
      {"row": 79, "column": 59, "value": 91},
      {"row": 80, "column": 59, "value": 92},
      {"row": 81, "column": 59, "value": 92},
      {"row": 82, "column": 59, "value": 93},
      {"row": 83, "column": 59, "value": 93},
      {"row": 84, "column": 59, "value": 93},
      {"row": 85, "column": 59, "value": 94},
      {"row": 86, "column": 59, "value": 94},
      {"row": 87, "column": 59, "value": 95},
      {"row": 88, "column": 59, "value": 95},
      {"row": 89, "column": 59, "value": 95},
      {"row": 90, "column": 59, "value": 96},
      {"row": 91, "column": 59, "value": 96},
      {"row": 92, "column": 59, "value": 97},
      {"row": 93, "column": 59, "value": 97},
      {"row": 94, "column": 59, "value": 98},
      {"row": 95, "column": 59, "value": 98},
      {"row": 96, "column": 59, "value": 98},
      {"row": 97, "column": 59, "value": 99},
      {"row": 98, "column": 59, "value": 99},
      {"row": 99, "column": 59, "value": 100},
      {"row": 60, "column": 60, "value": 84},
      {"row": 61, "column": 60, "value": 84},
      {"row": 62, "column": 60, "value": 85},
      {"row": 63, "column": 60, "value": 85},
      {"row": 64, "column": 60, "value": 86},
      {"row": 65, "column": 60, "value": 86},
      {"row": 66, "column": 60, "value": 86},
      {"row": 67, "column": 60, "value": 87},
      {"row": 68, "column": 60, "value": 87},
      {"row": 69, "column": 60, "value": 88},
      {"row": 70, "column": 60, "value": 88},
      {"row": 71, "column": 60, "value": 88},
      {"row": 72, "column": 60, "value": 89},
      {"row": 73, "column": 60, "value": 89},
      {"row": 74, "column": 60, "value": 90},
      {"row": 75, "column": 60, "value": 90},
      {"row": 76, "column": 60, "value": 90},
      {"row": 77, "column": 60, "value": 91},
      {"row": 78, "column": 60, "value": 91},
      {"row": 79, "column": 60, "value": 92},
      {"row": 80, "column": 60, "value": 92},
      {"row": 81, "column": 60, "value": 92},
      {"row": 82, "column": 60, "value": 93},
      {"row": 83, "column": 60, "value": 93},
      {"row": 84, "column": 60, "value": 94},
      {"row": 85, "column": 60, "value": 94},
      {"row": 86, "column": 60, "value": 94},
      {"row": 87, "column": 60, "value": 95},
      {"row": 88, "column": 60, "value": 95},
      {"row": 89, "column": 60, "value": 96},
      {"row": 90, "column": 60, "value": 96},
      {"row": 91, "column": 60, "value": 96},
      {"row": 92, "column": 60, "value": 97},
      {"row": 93, "column": 60, "value": 97},
      {"row": 94, "column": 60, "value": 98},
      {"row": 95, "column": 60, "value": 98},
      {"row": 96, "column": 60, "value": 98},
      {"row": 97, "column": 60, "value": 99},
      {"row": 98, "column": 60, "value": 99},
      {"row": 99, "column": 60, "value": 100},
      {"row": 61, "column": 61, "value": 85},
      {"row": 62, "column": 61, "value": 85},
      {"row": 63, "column": 61, "value": 86},
      {"row": 64, "column": 61, "value": 86},
      {"row": 65, "column": 61, "value": 86},
      {"row": 66, "column": 61, "value": 87},
      {"row": 67, "column": 61, "value": 87},
      {"row": 68, "column": 61, "value": 88},
      {"row": 69, "column": 61, "value": 88},
      {"row": 70, "column": 61, "value": 88},
      {"row": 71, "column": 61, "value": 89},
      {"row": 72, "column": 61, "value": 89},
      {"row": 73, "column": 61, "value": 89},
      {"row": 74, "column": 61, "value": 90},
      {"row": 75, "column": 61, "value": 90},
      {"row": 76, "column": 61, "value": 91},
      {"row": 77, "column": 61, "value": 91},
      {"row": 78, "column": 61, "value": 91},
      {"row": 79, "column": 61, "value": 92},
      {"row": 80, "column": 61, "value": 92},
      {"row": 81, "column": 61, "value": 93},
      {"row": 82, "column": 61, "value": 93},
      {"row": 83, "column": 61, "value": 93},
      {"row": 84, "column": 61, "value": 94},
      {"row": 85, "column": 61, "value": 94},
      {"row": 86, "column": 61, "value": 95},
      {"row": 87, "column": 61, "value": 95},
      {"row": 88, "column": 61, "value": 95},
      {"row": 89, "column": 61, "value": 96},
      {"row": 90, "column": 61, "value": 96},
      {"row": 91, "column": 61, "value": 96},
      {"row": 92, "column": 61, "value": 97},
      {"row": 93, "column": 61, "value": 97},
      {"row": 94, "column": 61, "value": 98},
      {"row": 95, "column": 61, "value": 98},
      {"row": 96, "column": 61, "value": 98},
      {"row": 97, "column": 61, "value": 99},
      {"row": 98, "column": 61, "value": 99},
      {"row": 99, "column": 61, "value": 100},
      {"row": 62, "column": 62, "value": 86},
      {"row": 63, "column": 62, "value": 86},
      {"row": 64, "column": 62, "value": 86},
      {"row": 65, "column": 62, "value": 87},
      {"row": 66, "column": 62, "value": 87},
      {"row": 67, "column": 62, "value": 87},
      {"row": 68, "column": 62, "value": 88},
      {"row": 69, "column": 62, "value": 88},
      {"row": 70, "column": 62, "value": 89},
      {"row": 71, "column": 62, "value": 89},
      {"row": 72, "column": 62, "value": 89},
      {"row": 73, "column": 62, "value": 90},
      {"row": 74, "column": 62, "value": 90},
      {"row": 75, "column": 62, "value": 91},
      {"row": 76, "column": 62, "value": 91},
      {"row": 77, "column": 62, "value": 91},
      {"row": 78, "column": 62, "value": 92},
      {"row": 79, "column": 62, "value": 92},
      {"row": 80, "column": 62, "value": 92},
      {"row": 81, "column": 62, "value": 93},
      {"row": 82, "column": 62, "value": 93},
      {"row": 83, "column": 62, "value": 94},
      {"row": 84, "column": 62, "value": 94},
      {"row": 85, "column": 62, "value": 94},
      {"row": 86, "column": 62, "value": 95},
      {"row": 87, "column": 62, "value": 95},
      {"row": 88, "column": 62, "value": 95},
      {"row": 89, "column": 62, "value": 96},
      {"row": 90, "column": 62, "value": 96},
      {"row": 91, "column": 62, "value": 97},
      {"row": 92, "column": 62, "value": 97},
      {"row": 93, "column": 62, "value": 97},
      {"row": 94, "column": 62, "value": 98},
      {"row": 95, "column": 62, "value": 98},
      {"row": 96, "column": 62, "value": 98},
      {"row": 97, "column": 62, "value": 99},
      {"row": 98, "column": 62, "value": 99},
      {"row": 99, "column": 62, "value": 100},
      {"row": 63, "column": 63, "value": 86},
      {"row": 64, "column": 63, "value": 87},
      {"row": 65, "column": 63, "value": 87},
      {"row": 66, "column": 63, "value": 87},
      {"row": 67, "column": 63, "value": 88},
      {"row": 68, "column": 63, "value": 88},
      {"row": 69, "column": 63, "value": 89},
      {"row": 70, "column": 63, "value": 89},
      {"row": 71, "column": 63, "value": 89},
      {"row": 72, "column": 63, "value": 90},
      {"row": 73, "column": 63, "value": 90},
      {"row": 74, "column": 63, "value": 90},
      {"row": 75, "column": 63, "value": 91},
      {"row": 76, "column": 63, "value": 91},
      {"row": 77, "column": 63, "value": 91},
      {"row": 78, "column": 63, "value": 92},
      {"row": 79, "column": 63, "value": 92},
      {"row": 80, "column": 63, "value": 93},
      {"row": 81, "column": 63, "value": 93},
      {"row": 82, "column": 63, "value": 93},
      {"row": 83, "column": 63, "value": 94},
      {"row": 84, "column": 63, "value": 94},
      {"row": 85, "column": 63, "value": 94},
      {"row": 86, "column": 63, "value": 95},
      {"row": 87, "column": 63, "value": 95},
      {"row": 88, "column": 63, "value": 96},
      {"row": 89, "column": 63, "value": 96},
      {"row": 90, "column": 63, "value": 96},
      {"row": 91, "column": 63, "value": 97},
      {"row": 92, "column": 63, "value": 97},
      {"row": 93, "column": 63, "value": 97},
      {"row": 94, "column": 63, "value": 98},
      {"row": 95, "column": 63, "value": 98},
      {"row": 96, "column": 63, "value": 99},
      {"row": 97, "column": 63, "value": 99},
      {"row": 98, "column": 63, "value": 99},
      {"row": 99, "column": 63, "value": 100},
      {"row": 64, "column": 64, "value": 87},
      {"row": 65, "column": 64, "value": 87},
      {"row": 66, "column": 64, "value": 88},
      {"row": 67, "column": 64, "value": 88},
      {"row": 68, "column": 64, "value": 88},
      {"row": 69, "column": 64, "value": 89},
      {"row": 70, "column": 64, "value": 89},
      {"row": 71, "column": 64, "value": 90},
      {"row": 72, "column": 64, "value": 90},
      {"row": 73, "column": 64, "value": 90},
      {"row": 74, "column": 64, "value": 91},
      {"row": 75, "column": 64, "value": 91},
      {"row": 76, "column": 64, "value": 91},
      {"row": 77, "column": 64, "value": 92},
      {"row": 78, "column": 64, "value": 92},
      {"row": 79, "column": 64, "value": 92},
      {"row": 80, "column": 64, "value": 93},
      {"row": 81, "column": 64, "value": 93},
      {"row": 82, "column": 64, "value": 94},
      {"row": 83, "column": 64, "value": 94},
      {"row": 84, "column": 64, "value": 94},
      {"row": 85, "column": 64, "value": 95},
      {"row": 86, "column": 64, "value": 95},
      {"row": 87, "column": 64, "value": 95},
      {"row": 88, "column": 64, "value": 96},
      {"row": 89, "column": 64, "value": 96},
      {"row": 90, "column": 64, "value": 96},
      {"row": 91, "column": 64, "value": 97},
      {"row": 92, "column": 64, "value": 97},
      {"row": 93, "column": 64, "value": 97},
      {"row": 94, "column": 64, "value": 98},
      {"row": 95, "column": 64, "value": 98},
      {"row": 96, "column": 64, "value": 99},
      {"row": 97, "column": 64, "value": 99},
      {"row": 98, "column": 64, "value": 99},
      {"row": 99, "column": 64, "value": 100},
      {"row": 65, "column": 65, "value": 88},
      {"row": 66, "column": 65, "value": 88},
      {"row": 67, "column": 65, "value": 88},
      {"row": 68, "column": 65, "value": 89},
      {"row": 69, "column": 65, "value": 89},
      {"row": 70, "column": 65, "value": 90},
      {"row": 71, "column": 65, "value": 90},
      {"row": 72, "column": 65, "value": 90},
      {"row": 73, "column": 65, "value": 91},
      {"row": 74, "column": 65, "value": 91},
      {"row": 75, "column": 65, "value": 91},
      {"row": 76, "column": 65, "value": 92},
      {"row": 77, "column": 65, "value": 92},
      {"row": 78, "column": 65, "value": 92},
      {"row": 79, "column": 65, "value": 93},
      {"row": 80, "column": 65, "value": 93},
      {"row": 81, "column": 65, "value": 93},
      {"row": 82, "column": 65, "value": 94},
      {"row": 83, "column": 65, "value": 94},
      {"row": 84, "column": 65, "value": 94},
      {"row": 85, "column": 65, "value": 95},
      {"row": 86, "column": 65, "value": 95},
      {"row": 87, "column": 65, "value": 95},
      {"row": 88, "column": 65, "value": 96},
      {"row": 89, "column": 65, "value": 96},
      {"row": 90, "column": 65, "value": 97},
      {"row": 91, "column": 65, "value": 97},
      {"row": 92, "column": 65, "value": 97},
      {"row": 93, "column": 65, "value": 98},
      {"row": 94, "column": 65, "value": 98},
      {"row": 95, "column": 65, "value": 98},
      {"row": 96, "column": 65, "value": 99},
      {"row": 97, "column": 65, "value": 99},
      {"row": 98, "column": 65, "value": 99},
      {"row": 99, "column": 65, "value": 100},
      {"row": 66, "column": 66, "value": 88},
      {"row": 67, "column": 66, "value": 89},
      {"row": 68, "column": 66, "value": 89},
      {"row": 69, "column": 66, "value": 89},
      {"row": 70, "column": 66, "value": 90},
      {"row": 71, "column": 66, "value": 90},
      {"row": 72, "column": 66, "value": 90},
      {"row": 73, "column": 66, "value": 91},
      {"row": 74, "column": 66, "value": 91},
      {"row": 75, "column": 66, "value": 92},
      {"row": 76, "column": 66, "value": 92},
      {"row": 77, "column": 66, "value": 92},
      {"row": 78, "column": 66, "value": 93},
      {"row": 79, "column": 66, "value": 93},
      {"row": 80, "column": 66, "value": 93},
      {"row": 81, "column": 66, "value": 94},
      {"row": 82, "column": 66, "value": 94},
      {"row": 83, "column": 66, "value": 94},
      {"row": 84, "column": 66, "value": 95},
      {"row": 85, "column": 66, "value": 95},
      {"row": 86, "column": 66, "value": 95},
      {"row": 87, "column": 66, "value": 96},
      {"row": 88, "column": 66, "value": 96},
      {"row": 89, "column": 66, "value": 96},
      {"row": 90, "column": 66, "value": 97},
      {"row": 91, "column": 66, "value": 97},
      {"row": 92, "column": 66, "value": 97},
      {"row": 93, "column": 66, "value": 98},
      {"row": 94, "column": 66, "value": 98},
      {"row": 95, "column": 66, "value": 98},
      {"row": 96, "column": 66, "value": 99},
      {"row": 97, "column": 66, "value": 99},
      {"row": 98, "column": 66, "value": 99},
      {"row": 99, "column": 66, "value": 100},
      {"row": 67, "column": 67, "value": 89},
      {"row": 68, "column": 67, "value": 89},
      {"row": 69, "column": 67, "value": 90},
      {"row": 70, "column": 67, "value": 90},
      {"row": 71, "column": 67, "value": 90},
      {"row": 72, "column": 67, "value": 91},
      {"row": 73, "column": 67, "value": 91},
      {"row": 74, "column": 67, "value": 91},
      {"row": 75, "column": 67, "value": 92},
      {"row": 76, "column": 67, "value": 92},
      {"row": 77, "column": 67, "value": 92},
      {"row": 78, "column": 67, "value": 93},
      {"row": 79, "column": 67, "value": 93},
      {"row": 80, "column": 67, "value": 93},
      {"row": 81, "column": 67, "value": 94},
      {"row": 82, "column": 67, "value": 94},
      {"row": 83, "column": 67, "value": 94},
      {"row": 84, "column": 67, "value": 95},
      {"row": 85, "column": 67, "value": 95},
      {"row": 86, "column": 67, "value": 95},
      {"row": 87, "column": 67, "value": 96},
      {"row": 88, "column": 67, "value": 96},
      {"row": 89, "column": 67, "value": 96},
      {"row": 90, "column": 67, "value": 97},
      {"row": 91, "column": 67, "value": 97},
      {"row": 92, "column": 67, "value": 97},
      {"row": 93, "column": 67, "value": 98},
      {"row": 94, "column": 67, "value": 98},
      {"row": 95, "column": 67, "value": 98},
      {"row": 96, "column": 67, "value": 99},
      {"row": 97, "column": 67, "value": 99},
      {"row": 98, "column": 67, "value": 99},
      {"row": 99, "column": 67, "value": 100},
      {"row": 68, "column": 68, "value": 90},
      {"row": 69, "column": 68, "value": 90},
      {"row": 70, "column": 68, "value": 90},
      {"row": 71, "column": 68, "value": 91},
      {"row": 72, "column": 68, "value": 91},
      {"row": 73, "column": 68, "value": 91},
      {"row": 74, "column": 68, "value": 92},
      {"row": 75, "column": 68, "value": 92},
      {"row": 76, "column": 68, "value": 92},
      {"row": 77, "column": 68, "value": 93},
      {"row": 78, "column": 68, "value": 93},
      {"row": 79, "column": 68, "value": 93},
      {"row": 80, "column": 68, "value": 94},
      {"row": 81, "column": 68, "value": 94},
      {"row": 82, "column": 68, "value": 94},
      {"row": 83, "column": 68, "value": 95},
      {"row": 84, "column": 68, "value": 95},
      {"row": 85, "column": 68, "value": 95},
      {"row": 86, "column": 68, "value": 96},
      {"row": 87, "column": 68, "value": 96},
      {"row": 88, "column": 68, "value": 96},
      {"row": 89, "column": 68, "value": 96},
      {"row": 90, "column": 68, "value": 97},
      {"row": 91, "column": 68, "value": 97},
      {"row": 92, "column": 68, "value": 97},
      {"row": 93, "column": 68, "value": 98},
      {"row": 94, "column": 68, "value": 98},
      {"row": 95, "column": 68, "value": 98},
      {"row": 96, "column": 68, "value": 99},
      {"row": 97, "column": 68, "value": 99},
      {"row": 98, "column": 68, "value": 99},
      {"row": 99, "column": 68, "value": 100},
      {"row": 69, "column": 69, "value": 90},
      {"row": 70, "column": 69, "value": 91},
      {"row": 71, "column": 69, "value": 91},
      {"row": 72, "column": 69, "value": 91},
      {"row": 73, "column": 69, "value": 92},
      {"row": 74, "column": 69, "value": 92},
      {"row": 75, "column": 69, "value": 92},
      {"row": 76, "column": 69, "value": 93},
      {"row": 77, "column": 69, "value": 93},
      {"row": 78, "column": 69, "value": 93},
      {"row": 79, "column": 69, "value": 93},
      {"row": 80, "column": 69, "value": 94},
      {"row": 81, "column": 69, "value": 94},
      {"row": 82, "column": 69, "value": 94},
      {"row": 83, "column": 69, "value": 95},
      {"row": 84, "column": 69, "value": 95},
      {"row": 85, "column": 69, "value": 95},
      {"row": 86, "column": 69, "value": 96},
      {"row": 87, "column": 69, "value": 96},
      {"row": 88, "column": 69, "value": 96},
      {"row": 89, "column": 69, "value": 97},
      {"row": 90, "column": 69, "value": 97},
      {"row": 91, "column": 69, "value": 97},
      {"row": 92, "column": 69, "value": 98},
      {"row": 93, "column": 69, "value": 98},
      {"row": 94, "column": 69, "value": 98},
      {"row": 95, "column": 69, "value": 98},
      {"row": 96, "column": 69, "value": 99},
      {"row": 97, "column": 69, "value": 99},
      {"row": 98, "column": 69, "value": 99},
      {"row": 99, "column": 69, "value": 100},
      {"row": 70, "column": 70, "value": 91},
      {"row": 71, "column": 70, "value": 91},
      {"row": 72, "column": 70, "value": 92},
      {"row": 73, "column": 70, "value": 92},
      {"row": 74, "column": 70, "value": 92},
      {"row": 75, "column": 70, "value": 93},
      {"row": 76, "column": 70, "value": 93},
      {"row": 77, "column": 70, "value": 93},
      {"row": 78, "column": 70, "value": 93},
      {"row": 79, "column": 70, "value": 94},
      {"row": 80, "column": 70, "value": 94},
      {"row": 81, "column": 70, "value": 94},
      {"row": 82, "column": 70, "value": 95},
      {"row": 83, "column": 70, "value": 95},
      {"row": 84, "column": 70, "value": 95},
      {"row": 85, "column": 70, "value": 96},
      {"row": 86, "column": 70, "value": 96},
      {"row": 87, "column": 70, "value": 96},
      {"row": 88, "column": 70, "value": 96},
      {"row": 89, "column": 70, "value": 97},
      {"row": 90, "column": 70, "value": 97},
      {"row": 91, "column": 70, "value": 97},
      {"row": 92, "column": 70, "value": 98},
      {"row": 93, "column": 70, "value": 98},
      {"row": 94, "column": 70, "value": 98},
      {"row": 95, "column": 70, "value": 99},
      {"row": 96, "column": 70, "value": 99},
      {"row": 97, "column": 70, "value": 99},
      {"row": 98, "column": 70, "value": 99},
      {"row": 99, "column": 70, "value": 100},
      {"row": 71, "column": 71, "value": 92},
      {"row": 72, "column": 71, "value": 92},
      {"row": 73, "column": 71, "value": 92},
      {"row": 74, "column": 71, "value": 92},
      {"row": 75, "column": 71, "value": 93},
      {"row": 76, "column": 71, "value": 93},
      {"row": 77, "column": 71, "value": 93},
      {"row": 78, "column": 71, "value": 94},
      {"row": 79, "column": 71, "value": 94},
      {"row": 80, "column": 71, "value": 94},
      {"row": 81, "column": 71, "value": 94},
      {"row": 82, "column": 71, "value": 95},
      {"row": 83, "column": 71, "value": 95},
      {"row": 84, "column": 71, "value": 95},
      {"row": 85, "column": 71, "value": 96},
      {"row": 86, "column": 71, "value": 96},
      {"row": 87, "column": 71, "value": 96},
      {"row": 88, "column": 71, "value": 97},
      {"row": 89, "column": 71, "value": 97},
      {"row": 90, "column": 71, "value": 97},
      {"row": 91, "column": 71, "value": 97},
      {"row": 92, "column": 71, "value": 98},
      {"row": 93, "column": 71, "value": 98},
      {"row": 94, "column": 71, "value": 98},
      {"row": 95, "column": 71, "value": 99},
      {"row": 96, "column": 71, "value": 99},
      {"row": 97, "column": 71, "value": 99},
      {"row": 98, "column": 71, "value": 99},
      {"row": 99, "column": 71, "value": 100},
      {"row": 72, "column": 72, "value": 92},
      {"row": 73, "column": 72, "value": 92},
      {"row": 74, "column": 72, "value": 93},
      {"row": 75, "column": 72, "value": 93},
      {"row": 76, "column": 72, "value": 93},
      {"row": 77, "column": 72, "value": 94},
      {"row": 78, "column": 72, "value": 94},
      {"row": 79, "column": 72, "value": 94},
      {"row": 80, "column": 72, "value": 94},
      {"row": 81, "column": 72, "value": 95},
      {"row": 82, "column": 72, "value": 95},
      {"row": 83, "column": 72, "value": 95},
      {"row": 84, "column": 72, "value": 96},
      {"row": 85, "column": 72, "value": 96},
      {"row": 86, "column": 72, "value": 96},
      {"row": 87, "column": 72, "value": 96},
      {"row": 88, "column": 72, "value": 97},
      {"row": 89, "column": 72, "value": 97},
      {"row": 90, "column": 72, "value": 97},
      {"row": 91, "column": 72, "value": 97},
      {"row": 92, "column": 72, "value": 98},
      {"row": 93, "column": 72, "value": 98},
      {"row": 94, "column": 72, "value": 98},
      {"row": 95, "column": 72, "value": 99},
      {"row": 96, "column": 72, "value": 99},
      {"row": 97, "column": 72, "value": 99},
      {"row": 98, "column": 72, "value": 99},
      {"row": 99, "column": 72, "value": 100},
      {"row": 73, "column": 73, "value": 93},
      {"row": 74, "column": 73, "value": 93},
      {"row": 75, "column": 73, "value": 93},
      {"row": 76, "column": 73, "value": 94},
      {"row": 77, "column": 73, "value": 94},
      {"row": 78, "column": 73, "value": 94},
      {"row": 79, "column": 73, "value": 95},
      {"row": 80, "column": 73, "value": 95},
      {"row": 81, "column": 73, "value": 95},
      {"row": 82, "column": 73, "value": 95},
      {"row": 83, "column": 73, "value": 96},
      {"row": 84, "column": 73, "value": 96},
      {"row": 85, "column": 73, "value": 96},
      {"row": 86, "column": 73, "value": 96},
      {"row": 87, "column": 73, "value": 97},
      {"row": 88, "column": 73, "value": 97},
      {"row": 89, "column": 73, "value": 97},
      {"row": 90, "column": 73, "value": 98},
      {"row": 91, "column": 73, "value": 98},
      {"row": 92, "column": 73, "value": 98},
      {"row": 93, "column": 73, "value": 98},
      {"row": 94, "column": 73, "value": 99},
      {"row": 95, "column": 73, "value": 99},
      {"row": 96, "column": 73, "value": 99},
      {"row": 97, "column": 73, "value": 99},
      {"row": 98, "column": 73, "value": 99},
      {"row": 99, "column": 73, "value": 100},
      {"row": 74, "column": 74, "value": 93},
      {"row": 75, "column": 74, "value": 94},
      {"row": 76, "column": 74, "value": 94},
      {"row": 77, "column": 74, "value": 94},
      {"row": 78, "column": 74, "value": 94},
      {"row": 79, "column": 74, "value": 95},
      {"row": 80, "column": 74, "value": 95},
      {"row": 81, "column": 74, "value": 95},
      {"row": 82, "column": 74, "value": 95},
      {"row": 83, "column": 74, "value": 96},
      {"row": 84, "column": 74, "value": 96},
      {"row": 85, "column": 74, "value": 96},
      {"row": 86, "column": 74, "value": 96},
      {"row": 87, "column": 74, "value": 97},
      {"row": 88, "column": 74, "value": 97},
      {"row": 89, "column": 74, "value": 97},
      {"row": 90, "column": 74, "value": 97},
      {"row": 91, "column": 74, "value": 98},
      {"row": 92, "column": 74, "value": 98},
      {"row": 93, "column": 74, "value": 98},
      {"row": 94, "column": 74, "value": 98},
      {"row": 95, "column": 74, "value": 99},
      {"row": 96, "column": 74, "value": 99},
      {"row": 97, "column": 74, "value": 99},
      {"row": 98, "column": 74, "value": 99},
      {"row": 99, "column": 74, "value": 100},
      {"row": 75, "column": 75, "value": 94},
      {"row": 76, "column": 75, "value": 94},
      {"row": 77, "column": 75, "value": 94},
      {"row": 78, "column": 75, "value": 95},
      {"row": 79, "column": 75, "value": 95},
      {"row": 80, "column": 75, "value": 95},
      {"row": 81, "column": 75, "value": 95},
      {"row": 82, "column": 75, "value": 96},
      {"row": 83, "column": 75, "value": 96},
      {"row": 84, "column": 75, "value": 96},
      {"row": 85, "column": 75, "value": 96},
      {"row": 86, "column": 75, "value": 97},
      {"row": 87, "column": 75, "value": 97},
      {"row": 88, "column": 75, "value": 97},
      {"row": 89, "column": 75, "value": 97},
      {"row": 90, "column": 75, "value": 98},
      {"row": 91, "column": 75, "value": 98},
      {"row": 92, "column": 75, "value": 98},
      {"row": 93, "column": 75, "value": 98},
      {"row": 94, "column": 75, "value": 99},
      {"row": 95, "column": 75, "value": 99},
      {"row": 96, "column": 75, "value": 99},
      {"row": 97, "column": 75, "value": 99},
      {"row": 98, "column": 75, "value": 100},
      {"row": 99, "column": 75, "value": 100},
      {"row": 76, "column": 76, "value": 94},
      {"row": 77, "column": 76, "value": 94},
      {"row": 78, "column": 76, "value": 95},
      {"row": 79, "column": 76, "value": 95},
      {"row": 80, "column": 76, "value": 95},
      {"row": 81, "column": 76, "value": 95},
      {"row": 82, "column": 76, "value": 96},
      {"row": 83, "column": 76, "value": 96},
      {"row": 84, "column": 76, "value": 96},
      {"row": 85, "column": 76, "value": 96},
      {"row": 86, "column": 76, "value": 97},
      {"row": 87, "column": 76, "value": 97},
      {"row": 88, "column": 76, "value": 97},
      {"row": 89, "column": 76, "value": 97},
      {"row": 90, "column": 76, "value": 98},
      {"row": 91, "column": 76, "value": 98},
      {"row": 92, "column": 76, "value": 98},
      {"row": 93, "column": 76, "value": 98},
      {"row": 94, "column": 76, "value": 99},
      {"row": 95, "column": 76, "value": 99},
      {"row": 96, "column": 76, "value": 99},
      {"row": 97, "column": 76, "value": 99},
      {"row": 98, "column": 76, "value": 100},
      {"row": 99, "column": 76, "value": 100},
      {"row": 77, "column": 77, "value": 95},
      {"row": 78, "column": 77, "value": 95},
      {"row": 79, "column": 77, "value": 95},
      {"row": 80, "column": 77, "value": 95},
      {"row": 81, "column": 77, "value": 96},
      {"row": 82, "column": 77, "value": 96},
      {"row": 83, "column": 77, "value": 96},
      {"row": 84, "column": 77, "value": 96},
      {"row": 85, "column": 77, "value": 97},
      {"row": 86, "column": 77, "value": 97},
      {"row": 87, "column": 77, "value": 97},
      {"row": 88, "column": 77, "value": 97},
      {"row": 89, "column": 77, "value": 97},
      {"row": 90, "column": 77, "value": 98},
      {"row": 91, "column": 77, "value": 98},
      {"row": 92, "column": 77, "value": 98},
      {"row": 93, "column": 77, "value": 98},
      {"row": 94, "column": 77, "value": 99},
      {"row": 95, "column": 77, "value": 99},
      {"row": 96, "column": 77, "value": 99},
      {"row": 97, "column": 77, "value": 99},
      {"row": 98, "column": 77, "value": 100},
      {"row": 99, "column": 77, "value": 100},
      {"row": 78, "column": 78, "value": 95},
      {"row": 79, "column": 78, "value": 95},
      {"row": 80, "column": 78, "value": 96},
      {"row": 81, "column": 78, "value": 96},
      {"row": 82, "column": 78, "value": 96},
      {"row": 83, "column": 78, "value": 96},
      {"row": 84, "column": 78, "value": 96},
      {"row": 85, "column": 78, "value": 97},
      {"row": 86, "column": 78, "value": 97},
      {"row": 87, "column": 78, "value": 97},
      {"row": 88, "column": 78, "value": 97},
      {"row": 89, "column": 78, "value": 98},
      {"row": 90, "column": 78, "value": 98},
      {"row": 91, "column": 78, "value": 98},
      {"row": 92, "column": 78, "value": 98},
      {"row": 93, "column": 78, "value": 98},
      {"row": 94, "column": 78, "value": 99},
      {"row": 95, "column": 78, "value": 99},
      {"row": 96, "column": 78, "value": 99},
      {"row": 97, "column": 78, "value": 99},
      {"row": 98, "column": 78, "value": 100},
      {"row": 99, "column": 78, "value": 100},
      {"row": 79, "column": 79, "value": 96},
      {"row": 80, "column": 79, "value": 96},
      {"row": 81, "column": 79, "value": 96},
      {"row": 82, "column": 79, "value": 96},
      {"row": 83, "column": 79, "value": 96},
      {"row": 84, "column": 79, "value": 97},
      {"row": 85, "column": 79, "value": 97},
      {"row": 86, "column": 79, "value": 97},
      {"row": 87, "column": 79, "value": 97},
      {"row": 88, "column": 79, "value": 97},
      {"row": 89, "column": 79, "value": 98},
      {"row": 90, "column": 79, "value": 98},
      {"row": 91, "column": 79, "value": 98},
      {"row": 92, "column": 79, "value": 98},
      {"row": 93, "column": 79, "value": 99},
      {"row": 94, "column": 79, "value": 99},
      {"row": 95, "column": 79, "value": 99},
      {"row": 96, "column": 79, "value": 99},
      {"row": 97, "column": 79, "value": 99},
      {"row": 98, "column": 79, "value": 100},
      {"row": 99, "column": 79, "value": 100},
      {"row": 80, "column": 80, "value": 96},
      {"row": 81, "column": 80, "value": 96},
      {"row": 82, "column": 80, "value": 96},
      {"row": 83, "column": 80, "value": 97},
      {"row": 84, "column": 80, "value": 97},
      {"row": 85, "column": 80, "value": 97},
      {"row": 86, "column": 80, "value": 97},
      {"row": 87, "column": 80, "value": 97},
      {"row": 88, "column": 80, "value": 98},
      {"row": 89, "column": 80, "value": 98},
      {"row": 90, "column": 80, "value": 98},
      {"row": 91, "column": 80, "value": 98},
      {"row": 92, "column": 80, "value": 98},
      {"row": 93, "column": 80, "value": 99},
      {"row": 94, "column": 80, "value": 99},
      {"row": 95, "column": 80, "value": 99},
      {"row": 96, "column": 80, "value": 99},
      {"row": 97, "column": 80, "value": 99},
      {"row": 98, "column": 80, "value": 100},
      {"row": 99, "column": 80, "value": 100},
      {"row": 81, "column": 81, "value": 96},
      {"row": 82, "column": 81, "value": 97},
      {"row": 83, "column": 81, "value": 97},
      {"row": 84, "column": 81, "value": 97},
      {"row": 85, "column": 81, "value": 97},
      {"row": 86, "column": 81, "value": 97},
      {"row": 87, "column": 81, "value": 98},
      {"row": 88, "column": 81, "value": 98},
      {"row": 89, "column": 81, "value": 98},
      {"row": 90, "column": 81, "value": 98},
      {"row": 91, "column": 81, "value": 98},
      {"row": 92, "column": 81, "value": 98},
      {"row": 93, "column": 81, "value": 99},
      {"row": 94, "column": 81, "value": 99},
      {"row": 95, "column": 81, "value": 99},
      {"row": 96, "column": 81, "value": 99},
      {"row": 97, "column": 81, "value": 99},
      {"row": 98, "column": 81, "value": 100},
      {"row": 99, "column": 81, "value": 100},
      {"row": 82, "column": 82, "value": 97},
      {"row": 83, "column": 82, "value": 97},
      {"row": 84, "column": 82, "value": 97},
      {"row": 85, "column": 82, "value": 97},
      {"row": 86, "column": 82, "value": 97},
      {"row": 87, "column": 82, "value": 98},
      {"row": 88, "column": 82, "value": 98},
      {"row": 89, "column": 82, "value": 98},
      {"row": 90, "column": 82, "value": 98},
      {"row": 91, "column": 82, "value": 98},
      {"row": 92, "column": 82, "value": 99},
      {"row": 93, "column": 82, "value": 99},
      {"row": 94, "column": 82, "value": 99},
      {"row": 95, "column": 82, "value": 99},
      {"row": 96, "column": 82, "value": 99},
      {"row": 97, "column": 82, "value": 99},
      {"row": 98, "column": 82, "value": 100},
      {"row": 99, "column": 82, "value": 100},
      {"row": 83, "column": 83, "value": 97},
      {"row": 84, "column": 83, "value": 97},
      {"row": 85, "column": 83, "value": 97},
      {"row": 86, "column": 83, "value": 98},
      {"row": 87, "column": 83, "value": 98},
      {"row": 88, "column": 83, "value": 98},
      {"row": 89, "column": 83, "value": 98},
      {"row": 90, "column": 83, "value": 98},
      {"row": 91, "column": 83, "value": 98},
      {"row": 92, "column": 83, "value": 99},
      {"row": 93, "column": 83, "value": 99},
      {"row": 94, "column": 83, "value": 99},
      {"row": 95, "column": 83, "value": 99},
      {"row": 96, "column": 83, "value": 99},
      {"row": 97, "column": 83, "value": 99},
      {"row": 98, "column": 83, "value": 100},
      {"row": 99, "column": 83, "value": 100},
      {"row": 84, "column": 84, "value": 97},
      {"row": 85, "column": 84, "value": 98},
      {"row": 86, "column": 84, "value": 98},
      {"row": 87, "column": 84, "value": 98},
      {"row": 88, "column": 84, "value": 98},
      {"row": 89, "column": 84, "value": 98},
      {"row": 90, "column": 84, "value": 98},
      {"row": 91, "column": 84, "value": 99},
      {"row": 92, "column": 84, "value": 99},
      {"row": 93, "column": 84, "value": 99},
      {"row": 94, "column": 84, "value": 99},
      {"row": 95, "column": 84, "value": 99},
      {"row": 96, "column": 84, "value": 99},
      {"row": 97, "column": 84, "value": 100},
      {"row": 98, "column": 84, "value": 100},
      {"row": 99, "column": 84, "value": 100},
      {"row": 85, "column": 85, "value": 98},
      {"row": 86, "column": 85, "value": 98},
      {"row": 87, "column": 85, "value": 98},
      {"row": 88, "column": 85, "value": 98},
      {"row": 89, "column": 85, "value": 98},
      {"row": 90, "column": 85, "value": 99},
      {"row": 91, "column": 85, "value": 99},
      {"row": 92, "column": 85, "value": 99},
      {"row": 93, "column": 85, "value": 99},
      {"row": 94, "column": 85, "value": 99},
      {"row": 95, "column": 85, "value": 99},
      {"row": 96, "column": 85, "value": 99},
      {"row": 97, "column": 85, "value": 100},
      {"row": 98, "column": 85, "value": 100},
      {"row": 99, "column": 85, "value": 100},
      {"row": 86, "column": 86, "value": 98},
      {"row": 87, "column": 86, "value": 98},
      {"row": 88, "column": 86, "value": 98},
      {"row": 89, "column": 86, "value": 98},
      {"row": 90, "column": 86, "value": 99},
      {"row": 91, "column": 86, "value": 99},
      {"row": 92, "column": 86, "value": 99},
      {"row": 93, "column": 86, "value": 99},
      {"row": 94, "column": 86, "value": 99},
      {"row": 95, "column": 86, "value": 99},
      {"row": 96, "column": 86, "value": 99},
      {"row": 97, "column": 86, "value": 100},
      {"row": 98, "column": 86, "value": 100},
      {"row": 99, "column": 86, "value": 100},
      {"row": 87, "column": 87, "value": 98},
      {"row": 88, "column": 87, "value": 98},
      {"row": 89, "column": 87, "value": 99},
      {"row": 90, "column": 87, "value": 99},
      {"row": 91, "column": 87, "value": 99},
      {"row": 92, "column": 87, "value": 99},
      {"row": 93, "column": 87, "value": 99},
      {"row": 94, "column": 87, "value": 99},
      {"row": 95, "column": 87, "value": 99},
      {"row": 96, "column": 87, "value": 99},
      {"row": 97, "column": 87, "value": 100},
      {"row": 98, "column": 87, "value": 100},
      {"row": 99, "column": 87, "value": 100},
      {"row": 88, "column": 88, "value": 99},
      {"row": 89, "column": 88, "value": 99},
      {"row": 90, "column": 88, "value": 99},
      {"row": 91, "column": 88, "value": 99},
      {"row": 92, "column": 88, "value": 99},
      {"row": 93, "column": 88, "value": 99},
      {"row": 94, "column": 88, "value": 99},
      {"row": 95, "column": 88, "value": 99},
      {"row": 96, "column": 88, "value": 100},
      {"row": 97, "column": 88, "value": 100},
      {"row": 98, "column": 88, "value": 100},
      {"row": 99, "column": 88, "value": 100},
      {"row": 89, "column": 89, "value": 99},
      {"row": 90, "column": 89, "value": 99},
      {"row": 91, "column": 89, "value": 99},
      {"row": 92, "column": 89, "value": 99},
      {"row": 93, "column": 89, "value": 99},
      {"row": 94, "column": 89, "value": 99},
      {"row": 95, "column": 89, "value": 99},
      {"row": 96, "column": 89, "value": 100},
      {"row": 97, "column": 89, "value": 100},
      {"row": 98, "column": 89, "value": 100},
      {"row": 99, "column": 89, "value": 100},
      {"row": 90, "column": 90, "value": 99},
      {"row": 91, "column": 90, "value": 99},
      {"row": 92, "column": 90, "value": 99},
      {"row": 93, "column": 90, "value": 99},
      {"row": 94, "column": 90, "value": 99},
      {"row": 95, "column": 90, "value": 100},
      {"row": 96, "column": 90, "value": 100},
      {"row": 97, "column": 90, "value": 100},
      {"row": 98, "column": 90, "value": 100},
      {"row": 99, "column": 90, "value": 100},
      {"row": 91, "column": 91, "value": 99},
      {"row": 92, "column": 91, "value": 99},
      {"row": 93, "column": 91, "value": 99},
      {"row": 94, "column": 91, "value": 99},
      {"row": 95, "column": 91, "value": 100},
      {"row": 96, "column": 91, "value": 100},
      {"row": 97, "column": 91, "value": 100},
      {"row": 98, "column": 91, "value": 100},
      {"row": 99, "column": 91, "value": 100},
      {"row": 92, "column": 92, "value": 99},
      {"row": 93, "column": 92, "value": 99},
      {"row": 94, "column": 92, "value": 100},
      {"row": 95, "column": 92, "value": 100},
      {"row": 96, "column": 92, "value": 100},
      {"row": 97, "column": 92, "value": 100},
      {"row": 98, "column": 92, "value": 100},
      {"row": 99, "column": 92, "value": 100},
      {"row": 93, "column": 93, "value": 100},
      {"row": 94, "column": 93, "value": 100},
      {"row": 95, "column": 93, "value": 100},
      {"row": 96, "column": 93, "value": 100},
      {"row": 97, "column": 93, "value": 100},
      {"row": 98, "column": 93, "value": 100},
      {"row": 99, "column": 93, "value": 100},
      {"row": 94, "column": 94, "value": 100},
      {"row": 95, "column": 94, "value": 100},
      {"row": 96, "column": 94, "value": 100},
      {"row": 97, "column": 94, "value": 100},
      {"row": 98, "column": 94, "value": 100},
      {"row": 99, "column": 94, "value": 100},
      {"row": 95, "column": 95, "value": 100},
      {"row": 96, "column": 95, "value": 100},
      {"row": 97, "column": 95, "value": 100},
      {"row": 98, "column": 95, "value": 100},
      {"row": 99, "column": 95, "value": 100},
      {"row": 96, "column": 96, "value": 100},
      {"row": 97, "column": 96, "value": 100},
      {"row": 98, "column": 96, "value": 100},
      {"row": 99, "column": 96, "value": 100},
      {"row": 97, "column": 97, "value": 100},
      {"row": 98, "column": 97, "value": 100},
      {"row": 99, "column": 97, "value": 100},
      {"row": 98, "column": 98, "value": 100},
      {"row": 99, "column": 98, "value": 100},
      {"row": 99, "column": 99, "value": 100}
    ];

    print("ROW_COLUMN== " + row.toString() + "  " + column.toString());
    List<CombineValueResponse> books = list
        .map(
          (jsonObject) => CombineValueResponse.fromJson(jsonObject),
        )
        .toList();

    print("notRepeatv" + notRepeat.toString());
    for (int i = 0; i < books.length; i++) {
      if (row.toInt() == books[i].row && column.toInt() == books[i].column) {
        // Totalrate = books[i].value.toDouble();
        print("RowColumValue " +
            books[i].row.toString() +
            " == " +
            books[i].column.toString() +
            " == " +
            books[i].value.toString());
      }
    }

    if (notRepeat == false) {
      isCombine = true;
      for (int i = 0; i < books.length; i++) {
        if (row.toInt() == books[i].row && column.toInt() == books[i].column) {
          Totalrate = books[i].value.toDouble();
        }
        // print(books[i].row.toString() + " == " + books[i].column.toString() +
        //     " == " + books[i].value.toString());
      }
      // Totalrate = row.toDouble() + column.toDouble();
      edt_Combined_Whole_Person_Rate.text = Totalrate.toStringAsFixed(2);
      print("sssssss4444" +
          "   ----- > " +
          row.toString() +
          "  " +
          Totalrate.toString());
    } else {
      isCombine = false;
      Totalrate = radio_one_red_per +
          radio_two_red_per +
          radio_three_red_per +
          radio_four_red_per;
      print("ddfdff34" + " Total : " + Totalrate.toString());
      edt_Combined_Whole_Person_Rate.text = Totalrate.toStringAsFixed(2);
    }

    //Malhar

    /// total award nu calculation ni formula muki ne value textfield ma set karvi

    ///edt_Total_Award_Value_With_Current_Conversations.text aa controller ma value mukvi
    setState(() {});
  }

  void totalawarvaluewithconvertion(double ttd) {
    /*  double d = edt_Impairment_Rating_Right_Upper.text.toString() == "" ? 0.00 : double.parse(edt_Impairment_Rating_Right_Upper.text.toString());
    double e = edt_Impairment_Rating_Left_Upper.text.toString() == "" ? 0.00 : double.parse(edt_Impairment_Rating_Left_Upper.text.toString());
    double f = edt_Impairment_Rating_Right_Lower.text.toString() == "" ? 0.00 : double.parse(edt_Impairment_Rating_Right_Lower.text.toString());
    double g = edt_Impairment_Rating_Left_Lower.text.toString() == "" ? 0.00 : double.parse(edt_Impairment_Rating_Left_Lower.text.toString());*/

    double a = 0.00, b = 0.00, c = 0.00, d = 0.00;
    double awardValue = 0.00;
    if (isCombine ||
        ttd != 0.00 ||
        edt_Combined_Whole_Person_Rate.text != "0.00") {
      double resultb1 = ttd * 400 * AgeFactorForInjury;

      awardValue =
          (resultb1 * double.parse(edt_Combined_Whole_Person_Rate.text)) / 100;
      print("AWARD VALUE1 === " + awardValue.toString());
    } else {
      if (edt_Value_of_the_Rating_Right_Upper.text != "") {
        a = double.parse(edt_Value_of_the_Rating_Right_Upper.text);
      }
      if (edt_Value_of_the_Rating_Right_Lower.text != "") {
        b = double.parse(edt_Value_of_the_Rating_Right_Lower.text);
      }
      if (edt_Value_of_the_Rating_Left_Upper.text != "") {
        c = double.parse(edt_Value_of_the_Rating_Left_Upper.text);
      }
      if (edt_Value_of_the_Rating_Left_Lower.text != "") {
        d = double.parse(edt_Value_of_the_Rating_Left_Lower.text);
      }
      awardValue = a + b + c + d;
      print("AWARD VALUE2 === " + awardValue.toString());
    }
    print("Total Award Value == " + awardValue.toString());
    edt_Total_Award_Value_With_Current_Conversations.text =
        awardValue.toStringAsFixed(2);
  }

  void TotalScheduleRateee() {
    /* final TextEditingController edt_right_upper_extremity_rating =
      TextEditingController();
  final TextEditingController edt_left_upper_extremity_rating =
      TextEditingController();
  final TextEditingController edt_right_lower_extremity_rating =
      TextEditingController();
  final TextEditingController edt_left_lower_extremity_rating =
      TextEditingController();*/

    double d = edt_right_upper_extremity_rating.text.toString() == ""
        ? 0.00
        : double.parse(edt_right_upper_extremity_rating.text.toString());
    double e = edt_left_upper_extremity_rating.text.toString() == ""
        ? 0.00
        : double.parse(edt_left_upper_extremity_rating.text.toString());
    double f = edt_right_lower_extremity_rating.text.toString() == ""
        ? 0.00
        : double.parse(edt_right_lower_extremity_rating.text.toString());
    double g = edt_left_lower_extremity_rating.text.toString() == ""
        ? 0.00
        : double.parse(edt_left_lower_extremity_rating.text.toString());

    double t2 = d + e + f + g;
    double t1 = radio_one_red_before_per +
        radio_two_red_before_per +
        radio_three_red_before_per +
        radio_four_red_before_per;
    // double t2 = radio_one_red_after_per+radio_two_red_after_per+radio_three_red_after_per+radio_four_red_after_per;

    print("fdsdsfd33rt" +
        " Before " +
        t2.toString() +
        " After : " +
        t1.toString());
    double total = t2 - t1;

    print("TotalScheduleRateee" + " Total : " + total.toString());
    edt_Total_Scheduled_Rate.text = total.toStringAsFixed(2);
  }

  Widget Whole_Person_UI() {
    return Container(
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
                margin: EdgeInsets.all(10),
                child: Text("Whole Person",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 10),
                height: 3,
                color: colorLightGray,
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextFormField(
                                enabled: false,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                textInputAction: TextInputAction.next,
                                controller: edt_Whole_Person_Rating,
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(top: 10.0),
                                    // border: UnderlineInputBorder(),
                                    labelText: 'Whole Person Rating',
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Text(
                                        "\%",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    hintText: "0.00"),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                )),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextFormField(
                                enabled: false,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                controller: edt_Value_of_the_Rating,
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(top: 10.0),
                                    border: UnderlineInputBorder(),
                                    labelText: 'Value of the Rating',
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Text(
                                        "\$",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    hintText: "0.00"),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                )),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget Right_Upper_Extremity_UI() {
    return Container(
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
                margin: EdgeInsets.all(10),
                child: Text("Right Upper Extremity (Scheduled)",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 10),
                height: 3,
                color: colorLightGray,
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CupertinoSwitch(
                          value: IsRightUpperState,
                          onChanged: (value) {
                            IsRightUpperState = value;

                            RightUpperExtremlyCovertFormula(value);

                            getTotRatingValue();

                            setState(
                              () {},
                            );
                          },
                          thumbColor: CupertinoColors.white,
                          activeColor: CupertinoColors.destructiveRed,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Convert Rating",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ))
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                controller: edt_Impairment_Rating_Right_Upper,
                                enabled: false,
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(top: 10.0),
                                    // border: UnderlineInputBorder(),
                                    labelText: 'Impairment Rating',
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Text(
                                        "\%",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    hintText: "0.00"),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                )),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                controller: edt_Value_of_the_Rating_Right_Upper,
                                enabled: false,
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(top: 10.0),
                                    border: UnderlineInputBorder(),
                                    labelText: 'Value of the Rating',
                                    // errorText: ISErrorrightUppervalue==true? LessMore4<0? "Additional \$" +LessMore4.toStringAsFixed(2):"Less \$" +LessMore4.toStringAsFixed(2) :null,
                                    errorStyle: TextStyle(color: Colors.red),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Text(
                                        "\$",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    hintText: "0.00"),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                )),
                          ),
                        ],
                      ),
                    ),
                    ISErrorrightUppervalue == true
                        ? Text(
                            LessMore4 < 0
                                ? "Additional \$" +
                                    LessMore4.toStringAsFixed(2)
                                        .replaceAll("-", "")
                                : "Less \$" +
                                    LessMore4.toStringAsFixed(2)
                                        .replaceAll("-", ""),
                            style: TextStyle(fontSize: 12, color: Colors.red),
                          )
                        : Container(),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget Left_Upper_Extremity_UI() {
    return Container(
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
                margin: EdgeInsets.all(10),
                child: Text("Left Upper Extremity (Scheduled)",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 10),
                height: 3,
                color: colorLightGray,
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CupertinoSwitch(
                          value: IsLeftUpperState,
                          onChanged: (value) {
                            IsLeftUpperState = value;
                            LefttUpperExtremlyCovertFormula(value);

                            getTotRatingValue();

                            setState(
                              () {},
                            );
                          },
                          thumbColor: CupertinoColors.white,
                          activeColor: CupertinoColors.destructiveRed,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Convert Rating",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ))
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                controller: edt_Impairment_Rating_Left_Upper,
                                onChanged: (value) {},
                                enabled: false,
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(top: 10.0),
                                    // border: UnderlineInputBorder(),
                                    labelText: 'Impairment Rating',
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Text(
                                        "\%",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    hintText: "0.00"),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                )),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                controller: edt_Value_of_the_Rating_Left_Upper,
                                enabled: false,
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(top: 10.0),
                                    border: UnderlineInputBorder(),
                                    labelText: 'Value of the Rating',
                                    // errorText: ISErrorleftUppervalue==true? LessMore3<0? "Additional \$" +LessMore3.toStringAsFixed(2):"Less \$" +LessMore3.toStringAsFixed(2) :null,
                                    errorStyle: TextStyle(color: Colors.red),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Text(
                                        "\$",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    hintText: "0.00"),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                )),
                          ),
                        ],
                      ),
                    ),
                    ISErrorleftUppervalue == true
                        ? Text(
                            LessMore3 < 0
                                ? "Additional \$" +
                                    LessMore3.toStringAsFixed(2)
                                        .replaceAll("-", "")
                                : "Less \$" +
                                    LessMore3.toStringAsFixed(2)
                                        .replaceAll("-", ""),
                            style: TextStyle(fontSize: 12, color: Colors.red),
                          )
                        : Container(),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget Right_Lower_Extremity_UI() {
    return Container(
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
                margin: EdgeInsets.all(10),
                child: Text("Right Lower Extremity (Scheduled)",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 10),
                height: 3,
                color: colorLightGray,
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CupertinoSwitch(
                          value: IsRightLowerState,
                          onChanged: (value) {
                            IsRightLowerState = value;

                            RightLowerExtremlyCovertFormula(value);

                            getTotRatingValue();
                            setState(
                              () {},
                            );
                          },
                          thumbColor: CupertinoColors.white,
                          activeColor: CupertinoColors.destructiveRed,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Convert Rating",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ))
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                controller: edt_Impairment_Rating_Right_Lower,
                                onChanged: (value) {},
                                enabled: false,
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(top: 10.0),
                                    // border: UnderlineInputBorder(),
                                    labelText: 'Impairment Rating',
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Text(
                                        "\%",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    hintText: "0.00"),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                )),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                controller: edt_Value_of_the_Rating_Right_Lower,
                                enabled: false,
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(top: 10.0),
                                    border: UnderlineInputBorder(),
                                    labelText: 'Value of the Rating',
                                    // errorText : "sdfds",
                                    errorStyle: TextStyle(color: Colors.red),
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Text(
                                        "\$",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    // errorText: ISErrorrightLowervalue==true? LessMore1<0? "Additional \$" +LessMore1.toStringAsFixed(2):"Less \$" +LessMore1.toStringAsFixed(2) :null,
                                    hintText: "0.00"),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                )),
                          ),
                        ],
                      ),
                    ),
                    ISErrorrightLowervalue == true
                        ? Text(
                            LessMore1 < 0
                                ? "Additional \$" +
                                    LessMore1.toStringAsFixed(2)
                                        .replaceAll("-", "")
                                : "Less \$" +
                                    LessMore1.toStringAsFixed(2)
                                        .replaceAll("-", ""),
                            style: TextStyle(fontSize: 12, color: Colors.red),
                          )
                        : Container(),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget Left_Lower_Extremity_UI() {
    return Container(
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
                margin: EdgeInsets.all(10),
                child: Text("Left Lower Extremity (Scheduled)",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                margin: EdgeInsets.only(top: 5, bottom: 10),
                height: 3,
                color: colorLightGray,
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CupertinoSwitch(
                          value: IsLeftLowerState,
                          onChanged: (value) {
                            IsLeftLowerState = value;

                            LefttLowerExtremlyCovertFormula(value);
                            getTotRatingValue();
                            setState(
                              () {},
                            );
                          },
                          thumbColor: CupertinoColors.white,
                          activeColor: CupertinoColors.destructiveRed,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Convert Rating",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ))
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                controller: edt_Impairment_Rating_Left_Lower,
                                enabled: false,
                                onChanged: (value) {},
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(top: 10.0),
                                    // border: UnderlineInputBorder(),
                                    labelText: 'Impairment Rating',
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Text(
                                        "\%",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    hintText: "0.00"),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                )),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: TextFormField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                controller: edt_Value_of_the_Rating_Left_Lower,
                                enabled: false,
                                decoration: InputDecoration(
                                    contentPadding:
                                        const EdgeInsets.only(top: 10.0),
                                    border: UnderlineInputBorder(),
                                    labelText: 'Value of the Rating',
                                    suffixIcon: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10.0, bottom: 10.0),
                                      child: Text(
                                        "\$",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                      ),
                                    ),
                                    //  errorText: ISErrorleftLowervalue==true? LessMore2<0? "Additional \$" +LessMore2.toStringAsFixed(2):"Less \$" +LessMore2.toStringAsFixed(2) :null,
                                    errorStyle: TextStyle(color: Colors.red),
                                    hintText: "0.00"),
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF000000),
                                )),
                          ),
                        ],
                      ),
                    ),
                    ISErrorleftLowervalue == true
                        ? Text(
                            LessMore2 < 0
                                ? "Additional \$" +
                                    LessMore2.toStringAsFixed(2)
                                        .replaceAll("-", "")
                                : "Less \$" +
                                    LessMore2.toStringAsFixed(2)
                                        .replaceAll("-", ""),
                            style: TextStyle(fontSize: 12, color: Colors.red),
                          )
                        : Container(),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getTotRatingValue() {
    double wholePersonRate = edt_Whole_Person_Rating.text.isNotEmpty
        ? double.parse(edt_Whole_Person_Rating.text)
        : 0;
    double wholePersonValue = edt_Value_of_the_Rating.text.isNotEmpty
        ? double.parse(edt_Value_of_the_Rating.text)
        : 0.00;

    double RU_Rating = edt_Impairment_Rating_Right_Upper.text.isNotEmpty
        ? double.parse(edt_Impairment_Rating_Right_Upper.text)
        : 0.00;
    double RU_Value = edt_Value_of_the_Rating_Right_Upper.text.isNotEmpty
        ? double.parse(edt_Value_of_the_Rating_Right_Upper.text)
        : 0.00;

    print("skljdsddddhf" +
        " Rating : " +
        RU_Rating.toString() +
        " RU_Value : " +
        RU_Value.toString());

    double LU_Rating = edt_Impairment_Rating_Left_Upper.text.isNotEmpty
        ? double.parse(edt_Impairment_Rating_Left_Upper.text)
        : 0.00;

    double LU_Value = edt_Value_of_the_Rating_Left_Upper.text.isNotEmpty
        ? double.parse(edt_Value_of_the_Rating_Left_Upper.text)
        : 0.00;

    double RL_Rating = edt_Impairment_Rating_Right_Lower.text.isNotEmpty
        ? double.parse(edt_Impairment_Rating_Right_Lower.text)
        : 0.00;
    double RL_Value = edt_Value_of_the_Rating_Right_Lower.text.isNotEmpty
        ? double.parse(edt_Value_of_the_Rating_Right_Lower.text)
        : 0.00;
    double LL_Rating = edt_Impairment_Rating_Left_Lower.text.isNotEmpty
        ? double.parse(edt_Impairment_Rating_Left_Lower.text)
        : 0.00;
    double LL_Value = edt_Value_of_the_Rating_Left_Lower.text.isNotEmpty
        ? double.parse(edt_Value_of_the_Rating_Left_Lower.text)
        : 0.00;

    double tot_rating =
        wholePersonRate + RU_Rating + LU_Rating + RL_Rating + LL_Rating;

    double tot_value =
        wholePersonValue + RU_Value + LU_Value + RL_Value + LL_Value;

    edt_Combined_Whole_Person_Rate.text = tot_rating.toStringAsFixed(2);
    edt_Total_Award_Value_With_Current_Conversations.text =
        tot_value.toStringAsFixed(2);

    //  Amount_Remaining_to_Reach_Cap.text = newcal.toStringAsFixed(2);

    double amountcalculatetoreachcap =
        Amount_Remaining_to_Reach_Cap.text.isNotEmpty
            ? double.parse(Amount_Remaining_to_Reach_Cap.text)
            : 0.00;

    double NewTotalAwardvalueforLostCap = 0.00;

    if (amountcalculatetoreachcap < 0) {
      NewTotalAwardvalueforLostCap = tot_value - amountcalculatetoreachcap;
      edt_Total_Award_Value_With_Current_Conversations.text =
          NewTotalAwardvalueforLostCap.toStringAsFixed(2);
      IS_Lost_Cap = true;
    } else {
      IS_Lost_Cap = false;
    }

    /* DateTime dt2 = DateTime.parse("09-07-2021");
    DateTime dt1 = DateTime.parse(edt_date_of_inquiry.text.toString());
*/

    DateTime dt2 = new DateFormat("dd-MM-yyyy").parse("09-07-2021");
    DateTime dt1 =
        new DateFormat("dd-MM-yyyy").parse(edt_date_of_inquiry.text.toString());

    if (dt1.compareTo(dt2) == 0) {
      print("Both date time are at same moment.");

      //  edt_Benefits_Cap.text = edt_Benefits_Cap1st.text;
    }

    if (dt1.compareTo(dt2) < 0) {
      print("DT1 is before DT2");

      int RUE_Convert_Background = rightupperExtremlyRatecalculationBackground(
          edt_right_upper_extremity_rating.text);
      int LUE_Convert_Background = leftupperExtremlyRatecalculationBackground(
          edt_left_upper_extremity_rating.text);
      int RLE_Convert_Background = rightlowerExtremlyRatecalculationBackground(
          edt_right_lower_extremity_rating.text);
      int LLE_Convert_Background = leftlowerExtremlyRatecalculationBackground(
          edt_left_lower_extremity_rating.text);

      double totRateBackground = wholePersonRate +
          RUE_Convert_Background +
          LUE_Convert_Background +
          RLE_Convert_Background +
          LLE_Convert_Background;

      if (totRateBackground >= 19) {
        edt_Benefits_Cap.text = edt_Benefits_Cap1st.text;
      } else {
        edt_Benefits_Cap.text = edt_Benefits_Cap2nd.text;
      }

      print("Banifitcond" +
          "19%" +
          "DT1 is before DT2" +
          " WholePerson " +
          wholePersonRate.toString() +
          " RUE_Convert " +
          RUE_Convert_Background.toString() +
          " LUE_Convert " +
          LUE_Convert_Background.toString() +
          " RLE_Convert " +
          RLE_Convert_Background.toString() +
          " LLE_Convert " +
          LLE_Convert_Background.toString());
    }

    if (dt1.compareTo(dt2) > 0) {
      print("DT1 is after DT2");
      print("Banifitcond" + "25%" + "DT1 is after DT2");

      int RUE_Convert_Background = rightupperExtremlyRatecalculationBackground(
          edt_right_upper_extremity_rating.text);
      int LUE_Convert_Background = leftupperExtremlyRatecalculationBackground(
          edt_left_upper_extremity_rating.text);
      int RLE_Convert_Background = rightlowerExtremlyRatecalculationBackground(
          edt_right_lower_extremity_rating.text);
      int LLE_Convert_Background = leftlowerExtremlyRatecalculationBackground(
          edt_left_lower_extremity_rating.text);

      double totRateBackground = wholePersonRate +
          RUE_Convert_Background +
          LUE_Convert_Background +
          RLE_Convert_Background +
          LLE_Convert_Background;

      if (totRateBackground >= 25) {
        edt_Benefits_Cap.text = edt_Benefits_Cap1st.text;
      } else {
        edt_Benefits_Cap.text = edt_Benefits_Cap2nd.text;
      }

      print("Banifitcond" +
          "25%" +
          "DT1 is before DT2" +
          " WholePerson " +
          wholePersonRate.toString() +
          " RUE_Convert " +
          RUE_Convert_Background.toString() +
          " LUE_Convert " +
          LUE_Convert_Background.toString() +
          " RLE_Convert " +
          RLE_Convert_Background.toString() +
          " LLE_Convert " +
          LLE_Convert_Background.toString());
    }
  }

  int rightupperExtremlyRatecalculationBackground(String value) {
    //edt_whole_person_impliment_rating
    //edt_Whole_Person_Rating
    //edt_Value_of_the_Rating

    // edt_Impairment_Rating_Right_Upper.text = value;

    /* double a = value.toString() == "" ? 0.00 : double.parse(value);
    double b = edt_schedule_rate_fromAPI.text.toString() == ""
        ? 0.00
        : double.parse(edt_schedule_rate_fromAPI.text);
    double result = 208 * b;

    double resulta = result * a;
    double resultb = resulta / 100;*/
    double test = edt_right_upper_extremity_rating.text.toString() == ""
        ? 0.00
        : double.parse(edt_right_upper_extremity_rating.text.toString());
    radio_one_red_before_per = test;
    int test1 = test.toInt();

    String rate = "";

    if (test1 == 0) {
      rate = "0";
    }
    if (test1 == 1) {
      rate = "1";
    }
    if (test1 == 2) {
      rate = "1";
    }
    if (test1 == 3) {
      rate = "2";
    }
    if (test1 == 4) {
      rate = "2";
    }
    if (test1 == 5) {
      rate = "3";
    }
    if (test1 == 6) {
      rate = "4";
    }
    if (test1 == 7) {
      rate = "4";
    }
    if (test1 == 8) {
      rate = "5";
    }
    if (test1 == 9) {
      rate = "5";
    }
    if (test1 == 10) {
      rate = "6";
    }
    if (test1 == 11) {
      rate = "7";
    }
    if (test1 == 12) {
      rate = "7";
    }
    if (test1 == 13) {
      rate = "8";
    }
    if (test1 == 14) {
      rate = "8";
    }
    if (test1 == 15) {
      rate = "9";
    }
    if (test1 == 16) {
      rate = "10";
    }
    if (test1 == 17) {
      rate = "10";
    }
    if (test1 == 18) {
      rate = "11";
    }
    if (test1 == 19) {
      rate = "11";
    }
    if (test1 == 20) {
      rate = "12";
    }
    if (test1 == 21) {
      rate = "13";
    }
    if (test1 == 22) {
      rate = "13";
    }
    if (test1 == 23) {
      rate = "14";
    }
    if (test1 == 24) {
      rate = "14";
    }
    if (test1 == 25) {
      rate = "15";
    }
    if (test1 == 26) {
      rate = "16";
    }
    if (test1 == 27) {
      rate = "16";
    }
    if (test1 == 28) {
      rate = "17";
    }
    if (test1 == 29) {
      rate = "17";
    }
    if (test1 == 30) {
      rate = "18";
    }
    if (test1 == 31) {
      rate = "19";
    }
    if (test1 == 32) {
      rate = "19";
    }
    if (test1 == 33) {
      rate = "20";
    }
    if (test1 == 34) {
      rate = "20";
    }
    if (test1 == 35) {
      rate = "21";
    }
    if (test1 == 36) {
      rate = "22";
    }
    if (test1 == 37) {
      rate = "22";
    }
    if (test1 == 38) {
      rate = "23";
    }
    if (test1 == 39) {
      rate = "23";
    }
    if (test1 == 40) {
      rate = "24";
    }
    if (test1 == 41) {
      rate = "25";
    }
    if (test1 == 42) {
      rate = "25";
    }
    if (test1 == 43) {
      rate = "26";
    }
    if (test1 == 44) {
      rate = "26";
    }
    if (test1 == 45) {
      rate = "27";
    }
    if (test1 == 46) {
      rate = "28";
    }
    if (test1 == 47) {
      rate = "28";
    }
    if (test1 == 48) {
      rate = "29";
    }
    if (test1 == 49) {
      rate = "29";
    }
    if (test1 == 50) {
      rate = "30";
    }
    if (test1 == 51) {
      rate = "31";
    }
    if (test1 == 52) {
      rate = "31";
    }
    if (test1 == 53) {
      rate = "32";
    }
    if (test1 == 54) {
      rate = "32";
    }
    if (test1 == 55) {
      rate = "33";
    }
    if (test1 == 56) {
      rate = "34";
    }
    if (test1 == 57) {
      rate = "34";
    }
    if (test1 == 58) {
      rate = "35";
    }
    if (test1 == 59) {
      rate = "35";
    }
    if (test1 == 60) {
      rate = "36";
    }
    if (test1 == 61) {
      rate = "37";
    }
    if (test1 == 62) {
      rate = "37";
    }
    if (test1 == 63) {
      rate = "38";
    }
    if (test1 == 64) {
      rate = "38";
    }
    if (test1 == 65) {
      rate = "39";
    }
    if (test1 == 66) {
      rate = "40";
    }
    if (test1 == 67) {
      rate = "40";
    }
    if (test1 == 68) {
      rate = "41";
    }
    if (test1 == 69) {
      rate = "41";
    }
    if (test1 == 70) {
      rate = "42";
    }
    if (test1 == 71) {
      rate = "43";
    }
    if (test1 == 72) {
      rate = "43";
    }
    if (test1 == 73) {
      rate = "44";
    }
    if (test1 == 74) {
      rate = "44";
    }
    if (test1 == 75) {
      rate = "45";
    }
    if (test1 == 76) {
      rate = "46";
    }
    if (test1 == 77) {
      rate = "46";
    }
    if (test1 == 78) {
      rate = "47";
    }
    if (test1 == 79) {
      rate = "47";
    }
    if (test1 == 80) {
      rate = "48";
    }
    if (test1 == 81) {
      rate = "49";
    }
    if (test1 == 82) {
      rate = "49";
    }
    if (test1 == 83) {
      rate = "50";
    }
    if (test1 == 84) {
      rate = "50";
    }
    if (test1 == 85) {
      rate = "51";
    }
    if (test1 == 86) {
      rate = "52";
    }
    if (test1 == 87) {
      rate = "52";
    }
    if (test1 == 88) {
      rate = "53";
    }
    if (test1 == 89) {
      rate = "53";
    }
    if (test1 == 90) {
      rate = "54";
    }
    if (test1 == 91) {
      rate = "55";
    }
    if (test1 == 92) {
      rate = "55";
    }
    if (test1 == 93) {
      rate = "56";
    }
    if (test1 == 94) {
      rate = "56";
    }
    if (test1 == 95) {
      rate = "57";
    }
    if (test1 == 96) {
      rate = "58";
    }
    if (test1 == 97) {
      rate = "58";
    }
    if (test1 == 98) {
      rate = "59";
    }
    if (test1 == 99) {
      rate = "59";
    }
    if (test1 == 100) {
      rate = "60";
    }

    return int.parse(rate);
  }

  int leftupperExtremlyRatecalculationBackground(String value) {
    //edt_whole_person_impliment_rating
    //edt_Whole_Person_Rating
    //edt_Value_of_the_Rating

    double test = edt_left_upper_extremity_rating.text.toString() == ""
        ? 0.00
        : double.parse(edt_left_upper_extremity_rating.text.toString());
    radio_two_red_before_per = test;

    String rate = "";

    int test1 = test.toInt();
    if (test1 == 0) {
      rate = "0";
    }
    if (test1 == 1) {
      rate = "1";
    }
    if (test1 == 2) {
      rate = "1";
    }
    if (test1 == 3) {
      rate = "2";
    }
    if (test1 == 4) {
      rate = "2";
    }
    if (test1 == 5) {
      rate = "3";
    }
    if (test1 == 6) {
      rate = "4";
    }
    if (test1 == 7) {
      rate = "4";
    }
    if (test1 == 8) {
      rate = "5";
    }
    if (test1 == 9) {
      rate = "5";
    }
    if (test1 == 10) {
      rate = "6";
    }
    if (test1 == 11) {
      rate = "7";
    }
    if (test1 == 12) {
      rate = "7";
    }
    if (test1 == 13) {
      rate = "8";
    }
    if (test1 == 14) {
      rate = "8";
    }
    if (test1 == 15) {
      rate = "9";
    }
    if (test1 == 16) {
      rate = "10";
    }
    if (test1 == 17) {
      rate = "10";
    }
    if (test1 == 18) {
      rate = "11";
    }
    if (test1 == 19) {
      rate = "11";
    }
    if (test1 == 20) {
      rate = "12";
    }
    if (test1 == 21) {
      rate = "13";
    }
    if (test1 == 22) {
      rate = "13";
    }
    if (test1 == 23) {
      rate = "14";
    }
    if (test1 == 24) {
      rate = "14";
    }
    if (test1 == 25) {
      rate = "15";
    }
    if (test1 == 26) {
      rate = "16";
    }
    if (test1 == 27) {
      rate = "16";
    }
    if (test1 == 28) {
      rate = "17";
    }
    if (test1 == 29) {
      rate = "17";
    }
    if (test1 == 30) {
      rate = "18";
    }
    if (test1 == 31) {
      rate = "19";
    }
    if (test1 == 32) {
      rate = "19";
    }
    if (test1 == 33) {
      rate = "20";
    }
    if (test1 == 34) {
      rate = "20";
    }
    if (test1 == 35) {
      rate = "21";
    }
    if (test1 == 36) {
      rate = "22";
    }
    if (test1 == 37) {
      rate = "22";
    }
    if (test1 == 38) {
      rate = "23";
    }
    if (test1 == 39) {
      rate = "23";
    }
    if (test1 == 40) {
      rate = "24";
    }
    if (test1 == 41) {
      rate = "25";
    }
    if (test1 == 42) {
      rate = "25";
    }
    if (test1 == 43) {
      rate = "26";
    }
    if (test1 == 44) {
      rate = "26";
    }
    if (test1 == 45) {
      rate = "27";
    }
    if (test1 == 46) {
      rate = "28";
    }
    if (test1 == 47) {
      rate = "28";
    }
    if (test1 == 48) {
      rate = "29";
    }
    if (test1 == 49) {
      rate = "29";
    }
    if (test1 == 50) {
      rate = "30";
    }
    if (test1 == 51) {
      rate = "31";
    }
    if (test1 == 52) {
      rate = "31";
    }
    if (test1 == 53) {
      rate = "32";
    }
    if (test1 == 54) {
      rate = "32";
    }
    if (test1 == 55) {
      rate = "33";
    }
    if (test1 == 56) {
      rate = "34";
    }
    if (test1 == 57) {
      rate = "34";
    }
    if (test1 == 58) {
      rate = "35";
    }
    if (test1 == 59) {
      rate = "35";
    }
    if (test1 == 60) {
      rate = "36";
    }
    if (test1 == 61) {
      rate = "37";
    }
    if (test1 == 62) {
      rate = "37";
    }
    if (test1 == 63) {
      rate = "38";
    }
    if (test1 == 64) {
      rate = "38";
    }
    if (test1 == 65) {
      rate = "39";
    }
    if (test1 == 66) {
      rate = "40";
    }
    if (test1 == 67) {
      rate = "40";
    }
    if (test1 == 68) {
      rate = "41";
    }
    if (test1 == 69) {
      rate = "41";
    }
    if (test1 == 70) {
      rate = "42";
    }
    if (test1 == 71) {
      rate = "43";
    }
    if (test1 == 72) {
      rate = "43";
    }
    if (test1 == 73) {
      rate = "44";
    }
    if (test1 == 74) {
      rate = "44";
    }
    if (test1 == 75) {
      rate = "45";
    }
    if (test1 == 76) {
      rate = "46";
    }
    if (test1 == 77) {
      rate = "46";
    }
    if (test1 == 78) {
      rate = "47";
    }
    if (test1 == 79) {
      rate = "47";
    }
    if (test1 == 80) {
      rate = "48";
    }
    if (test1 == 81) {
      rate = "49";
    }
    if (test1 == 82) {
      rate = "49";
    }
    if (test1 == 83) {
      rate = "50";
    }
    if (test1 == 84) {
      rate = "50";
    }
    if (test1 == 85) {
      rate = "51";
    }
    if (test1 == 86) {
      rate = "52";
    }
    if (test1 == 87) {
      rate = "52";
    }
    if (test1 == 88) {
      rate = "53";
    }
    if (test1 == 89) {
      rate = "53";
    }
    if (test1 == 90) {
      rate = "54";
    }
    if (test1 == 91) {
      rate = "55";
    }
    if (test1 == 92) {
      rate = "55";
    }
    if (test1 == 93) {
      rate = "56";
    }
    if (test1 == 94) {
      rate = "56";
    }
    if (test1 == 95) {
      rate = "57";
    }
    if (test1 == 96) {
      rate = "58";
    }
    if (test1 == 97) {
      rate = "58";
    }
    if (test1 == 98) {
      rate = "59";
    }
    if (test1 == 99) {
      rate = "59";
    }
    if (test1 == 100) {
      rate = "60";
    }

    return int.parse(rate);
  }

  int rightlowerExtremlyRatecalculationBackground(String value) {
    //edt_whole_person_impliment_rating
    //edt_Whole_Person_Rating
    //edt_Value_of_the_Rating

    double test = edt_right_lower_extremity_rating.text.toString() == ""
        ? 0.00
        : double.parse(edt_right_lower_extremity_rating.text.toString());
    radio_three_red_before_per = test;
    int test1 = test.toInt();

    String rate = "";

    if (test1 == 0) {
      rate = "0";
    }
    if (test1 == 1) {
      rate = "0";
    }
    if (test1 == 2) {
      rate = "1";
    }
    if (test1 == 3) {
      rate = "1";
    }
    if (test1 == 4) {
      rate = "2";
    }
    if (test1 == 5) {
      rate = "2";
    }
    if (test1 == 6) {
      rate = "2";
    }
    if (test1 == 7) {
      rate = "3";
    }
    if (test1 == 8) {
      rate = "3";
    }
    if (test1 == 9) {
      rate = "4";
    }
    if (test1 == 10) {
      rate = "4";
    }
    if (test1 == 11) {
      rate = "4";
    }
    if (test1 == 12) {
      rate = "5";
    }
    if (test1 == 13) {
      rate = "5";
    }
    if (test1 == 14) {
      rate = "6";
    }
    if (test1 == 15) {
      rate = "6";
    }
    if (test1 == 16) {
      rate = "6";
    }
    if (test1 == 17) {
      rate = "7";
    }
    if (test1 == 18) {
      rate = "7";
    }
    if (test1 == 19) {
      rate = "8";
    }
    if (test1 == 20) {
      rate = "8";
    }
    if (test1 == 21) {
      rate = "8";
    }
    if (test1 == 22) {
      rate = "9";
    }
    if (test1 == 23) {
      rate = "9";
    }
    if (test1 == 24) {
      rate = "10";
    }
    if (test1 == 25) {
      rate = "10";
    }
    if (test1 == 26) {
      rate = "10";
    }
    if (test1 == 27) {
      rate = "11";
    }
    if (test1 == 28) {
      rate = "11";
    }
    if (test1 == 29) {
      rate = "12";
    }
    if (test1 == 30) {
      rate = "12";
    }
    if (test1 == 31) {
      rate = "12";
    }
    if (test1 == 32) {
      rate = "13";
    }
    if (test1 == 33) {
      rate = "13";
    }
    if (test1 == 34) {
      rate = "14";
    }
    if (test1 == 35) {
      rate = "14";
    }
    if (test1 == 36) {
      rate = "14";
    }
    if (test1 == 37) {
      rate = "15";
    }
    if (test1 == 38) {
      rate = "15";
    }
    if (test1 == 39) {
      rate = "16";
    }
    if (test1 == 40) {
      rate = "16";
    }
    if (test1 == 41) {
      rate = "16";
    }
    if (test1 == 42) {
      rate = "17";
    }
    if (test1 == 43) {
      rate = "17";
    }
    if (test1 == 44) {
      rate = "18";
    }
    if (test1 == 45) {
      rate = "18";
    }
    if (test1 == 46) {
      rate = "18";
    }
    if (test1 == 47) {
      rate = "19";
    }
    if (test1 == 48) {
      rate = "19";
    }
    if (test1 == 49) {
      rate = "20";
    }
    if (test1 == 50) {
      rate = "20";
    }
    if (test1 == 51) {
      rate = "20";
    }
    if (test1 == 52) {
      rate = "21";
    }
    if (test1 == 53) {
      rate = "21";
    }
    if (test1 == 54) {
      rate = "22";
    }
    if (test1 == 55) {
      rate = "22";
    }
    if (test1 == 56) {
      rate = "22";
    }
    if (test1 == 57) {
      rate = "23";
    }
    if (test1 == 58) {
      rate = "23";
    }
    if (test1 == 59) {
      rate = "24";
    }
    if (test1 == 60) {
      rate = "24";
    }
    if (test1 == 61) {
      rate = "24";
    }
    if (test1 == 62) {
      rate = "25";
    }
    if (test1 == 63) {
      rate = "25";
    }
    if (test1 == 64) {
      rate = "26";
    }
    if (test1 == 65) {
      rate = "26";
    }
    if (test1 == 66) {
      rate = "28";
    }
    if (test1 == 67) {
      rate = "27";
    }
    if (test1 == 68) {
      rate = "27";
    }
    if (test1 == 69) {
      rate = "28";
    }
    if (test1 == 70) {
      rate = "28";
    }
    if (test1 == 71) {
      rate = "28";
    }
    if (test1 == 72) {
      rate = "29";
    }
    if (test1 == 73) {
      rate = "29";
    }
    if (test1 == 74) {
      rate = "30";
    }
    if (test1 == 75) {
      rate = "30";
    }
    if (test1 == 76) {
      rate = "30";
    }
    if (test1 == 77) {
      rate = "31";
    }
    if (test1 == 78) {
      rate = "31";
    }
    if (test1 == 79) {
      rate = "32";
    }
    if (test1 == 80) {
      rate = "32";
    }
    if (test1 == 81) {
      rate = "32";
    }
    if (test1 == 82) {
      rate = "33";
    }
    if (test1 == 83) {
      rate = "33";
    }
    if (test1 == 84) {
      rate = "34";
    }
    if (test1 == 85) {
      rate = "34";
    }
    if (test1 == 86) {
      rate = "34";
    }
    if (test1 == 87) {
      rate = "35";
    }
    if (test1 == 88) {
      rate = "35";
    }
    if (test1 == 89) {
      rate = "36";
    }
    if (test1 == 90) {
      rate = "36";
    }
    if (test1 == 91) {
      rate = "36";
    }
    if (test1 == 92) {
      rate = "37";
    }
    if (test1 == 93) {
      rate = "37";
    }
    if (test1 == 94) {
      rate = "38";
    }
    if (test1 == 95) {
      rate = "38";
    }
    if (test1 == 96) {
      rate = "38";
    }
    if (test1 == 97) {
      rate = "39";
    }
    if (test1 == 98) {
      rate = "39";
    }
    if (test1 == 99) {
      rate = "40";
    }
    if (test1 == 100) {
      rate = "40";
    }

    return int.parse(rate);
  }

  int leftlowerExtremlyRatecalculationBackground(String value) {
    //edt_whole_person_impliment_rating
    //edt_Whole_Person_Rating
    //edt_Value_of_the_Rating

    double test = edt_left_lower_extremity_rating.text.toString() == ""
        ? 0.00
        : double.parse(edt_left_lower_extremity_rating.text.toString());
    radio_four_red_before_per = test;
    int test1 = test.toInt();
    String rate = "";
    if (test1 == 0) {
      rate = "0";
    }
    if (test1 == 1) {
      rate = "0";
    }
    if (test1 == 2) {
      rate = "1";
    }
    if (test1 == 3) {
      rate = "1";
    }
    if (test1 == 4) {
      rate = "2";
    }
    if (test1 == 5) {
      rate = "2";
    }
    if (test1 == 6) {
      rate = "2";
    }
    if (test1 == 7) {
      rate = "3";
    }
    if (test1 == 8) {
      rate = "3";
    }
    if (test1 == 9) {
      rate = "4";
    }
    if (test1 == 10) {
      rate = "4";
    }
    if (test1 == 11) {
      rate = "4";
    }
    if (test1 == 12) {
      rate = "5";
    }
    if (test1 == 13) {
      rate = "5";
    }
    if (test1 == 14) {
      rate = "6";
    }
    if (test1 == 15) {
      rate = "6";
    }
    if (test1 == 16) {
      rate = "6";
    }
    if (test1 == 17) {
      rate = "7";
    }
    if (test1 == 18) {
      rate = "7";
    }
    if (test1 == 19) {
      rate = "8";
    }
    if (test1 == 20) {
      rate = "8";
    }
    if (test1 == 21) {
      rate = "8";
    }
    if (test1 == 22) {
      rate = "9";
    }
    if (test1 == 23) {
      rate = "9";
    }
    if (test1 == 24) {
      rate = "10";
    }
    if (test1 == 25) {
      rate = "10";
    }
    if (test1 == 26) {
      rate = "10";
    }
    if (test1 == 27) {
      rate = "11";
    }
    if (test1 == 28) {
      rate = "11";
    }
    if (test1 == 29) {
      rate = "12";
    }
    if (test1 == 30) {
      rate = "12";
    }
    if (test1 == 31) {
      rate = "12";
    }
    if (test1 == 32) {
      rate = "13";
    }
    if (test1 == 33) {
      rate = "13";
    }
    if (test1 == 34) {
      rate = "14";
    }
    if (test1 == 35) {
      rate = "14";
    }
    if (test1 == 36) {
      rate = "14";
    }
    if (test1 == 37) {
      rate = "15";
    }
    if (test1 == 38) {
      rate = "15";
    }
    if (test1 == 39) {
      rate = "16";
    }
    if (test1 == 40) {
      rate = "16";
    }
    if (test1 == 41) {
      rate = "16";
    }
    if (test1 == 42) {
      rate = "17";
    }
    if (test1 == 43) {
      rate = "17";
    }
    if (test1 == 44) {
      rate = "18";
    }
    if (test1 == 45) {
      rate = "18";
    }
    if (test1 == 46) {
      rate = "18";
    }
    if (test1 == 47) {
      rate = "19";
    }
    if (test1 == 48) {
      rate = "19";
    }
    if (test1 == 49) {
      rate = "20";
    }
    if (test1 == 50) {
      rate = "20";
    }
    if (test1 == 51) {
      rate = "20";
    }
    if (test1 == 52) {
      rate = "21";
    }
    if (test1 == 53) {
      rate = "21";
    }
    if (test1 == 54) {
      rate = "22";
    }
    if (test1 == 55) {
      rate = "22";
    }
    if (test1 == 56) {
      rate = "22";
    }
    if (test1 == 57) {
      rate = "23";
    }
    if (test1 == 58) {
      rate = "23";
    }
    if (test1 == 59) {
      rate = "24";
    }
    if (test1 == 60) {
      rate = "24";
    }
    if (test1 == 61) {
      rate = "24";
    }
    if (test1 == 62) {
      rate = "25";
    }
    if (test1 == 63) {
      rate = "25";
    }
    if (test1 == 64) {
      rate = "26";
    }
    if (test1 == 65) {
      rate = "26";
    }
    if (test1 == 66) {
      rate = "28";
    }
    if (test1 == 67) {
      rate = "27";
    }
    if (test1 == 68) {
      rate = "27";
    }
    if (test1 == 69) {
      rate = "28";
    }
    if (test1 == 70) {
      rate = "28";
    }
    if (test1 == 71) {
      rate = "28";
    }
    if (test1 == 72) {
      rate = "29";
    }
    if (test1 == 73) {
      rate = "29";
    }
    if (test1 == 74) {
      rate = "30";
    }
    if (test1 == 75) {
      rate = "30";
    }
    if (test1 == 76) {
      rate = "30";
    }
    if (test1 == 77) {
      rate = "31";
    }
    if (test1 == 78) {
      rate = "31";
    }
    if (test1 == 79) {
      rate = "32";
    }
    if (test1 == 80) {
      rate = "32";
    }
    if (test1 == 81) {
      rate = "32";
    }
    if (test1 == 82) {
      rate = "33";
    }
    if (test1 == 83) {
      rate = "33";
    }
    if (test1 == 84) {
      rate = "34";
    }
    if (test1 == 85) {
      rate = "34";
    }
    if (test1 == 86) {
      rate = "34";
    }
    if (test1 == 87) {
      rate = "35";
    }
    if (test1 == 88) {
      rate = "35";
    }
    if (test1 == 89) {
      rate = "36";
    }
    if (test1 == 90) {
      rate = "36";
    }
    if (test1 == 91) {
      rate = "36";
    }
    if (test1 == 92) {
      rate = "37";
    }
    if (test1 == 93) {
      rate = "37";
    }
    if (test1 == 94) {
      rate = "38";
    }
    if (test1 == 95) {
      rate = "38";
    }
    if (test1 == 96) {
      rate = "38";
    }
    if (test1 == 97) {
      rate = "39";
    }
    if (test1 == 98) {
      rate = "39";
    }
    if (test1 == 99) {
      rate = "40";
    }
    if (test1 == 100) {
      rate = "40";
    }
    return int.parse(rate);
  }
}
/*

if(09/07/2021 > DOI)
{
    19%

    if(TotalRate>=19)
    {
      2ndCap
    }
    else
    {
        1stCap
    }

}

else
{
    25%

      if(TotalRate>=25)
    {
      2ndCap
    }
    else
    {
        1stCap
    }


}
*/
