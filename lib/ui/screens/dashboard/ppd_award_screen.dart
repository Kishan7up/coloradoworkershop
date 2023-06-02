import 'package:app/blocs/other/mainbloc/main_bloc.dart';
import 'package:app/models/api_request/max_benifit/max_benifit_request.dart';
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

//import 'package:whatsapp_share/whatsapp_share.dart';

class PpdAwardScreenArguments {
  String editModel;

  PpdAwardScreenArguments(this.editModel);
}

class PpdAwardScreen extends BaseStatefulWidget {
  static const routeName = '/PpdAwardScreen';

  final PpdAwardScreenArguments arguments;

  PpdAwardScreen(this.arguments);

  @override
  _PpdAwardScreenState createState() => _PpdAwardScreenState();
}

class _PpdAwardScreenState extends BaseState<PpdAwardScreen>
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
  double leftLowervalue  = 0.00;
  double leftUppervalue  = 0.00;

  bool ISErrorrightLowervalue  =false;
  bool ISErrorrightUppervalue  =false;
  bool ISErrorleftLowervalue   =false;
  bool ISErrorleftUppervalue   =false;

  double LessMore1 = 0.00;
  double LessMore2 = 0.00;
  double LessMore3 = 0.00;
  double LessMore4 = 0.00;

  double Totalrate =0.00;



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

      var inputFormat = DateFormat('dd-MM-yyyy');
      var inputDate = inputFormat.parse(CurrentDate); // <-- dd/MM 24H format

      var outputFormat = DateFormat('dd-MM-yyyy');
      var outputDate = outputFormat.format(inputDate);
      //  edt_date_of_mmi.text = outputDate;

      edt_date_of_birth.text = "01-01-1900";
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

          if(state is MaxBenifitDateofInjuryResponseState)
            {
              getDateofInjuryResult(state);
            }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is MaxBenifitResponseState ||
          currentState is MaxBenifitDateofInjuryResponseState
          ) {
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

                            var outputFormat = DateFormat('dd-MM-yyyy');
                            var outputDate = outputFormat.format(inputDate);
                            edt_date_of_inquiry.text = outputDate;
                          });
                        }),
                  ),
                  Center(
                    child: ElevatedButton(
                        onPressed: () {

                          edt_whole_person_impliment_rating.text = "";

                          FirebaseMessaging _firebaseMessaging =
                              FirebaseMessaging.instance; // Change here
                          _firebaseMessaging.getToken().then((token) {
                            print("token is $token");
                            _CustomerBloc.add(MaxBenifitDateofInjoryRequestEvent(
                                MaxBenifitRequest(
                                    notification: "1",
                                    device_token: token,
                                    date: edt_date_of_inquiry.text)));
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

                            var outputFormat = DateFormat('dd-MM-yyyy');
                            var outputDate = outputFormat.format(inputDate);
                            edt_date_of_birth.text = outputDate;
                          });
                        }),
                  ),
                  Center(
                    child: ElevatedButton(
                        onPressed: () {
                          calculateAgeMMI();
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

                            var outputFormat = DateFormat('dd-MM-yyyy');
                            var outputDate = outputFormat.format(inputDate);
                            edt_date_of_mmi.text = outputDate;
                          });
                        }),
                  ),
                  Center(
                    child: ElevatedButton(
                        onPressed: () {
                          FirebaseMessaging _firebaseMessaging =
                              FirebaseMessaging.instance;

                          // Change here
                          _firebaseMessaging.getToken().then((token) {
                            print("token is $token");
                            _CustomerBloc.add(MaxBenifitRequestEvent(
                                MaxBenifitRequest(
                                    notification: "1",
                                    device_token: token,
                                    date: edt_date_of_mmi.text)));
                          });

                          calculateAgeMMI();
                          Navigator.pop(ctx);
                        },
                        child: Text("Select")),
                  ),
                ],
              ),
            ));



  }

  calculateAgeOFInjury() {
    // var a = DateTime.parse(edt_date_of_inquiry.text);
    //  var b = DateTime.parse(edt_date_of_birth.text);

    DateTime start = DateFormat("MM-dd-yyyy").parse(edt_date_of_inquiry.text);
    DateTime end = new DateFormat("MM-dd-yyyy").parse(edt_date_of_birth.text);
    print("fsdkhfkjsh" + edt_date_of_inquiry.text);

    var years = start.difference(end);

    int y = years.inDays ~/ 365;
    print("TotalYear :- " + y.toString());

/*
1.78;
1.76;
1.74;
1.72;
1.70;
1.68;
1.66;
1.64;
1.62;
1.60;
1.58;
1.56;
1.54;
1.52;
1.50;
1.48;
1.46;
1.44;
1.42;
1.40;
1.38;
1.36;
1.34;
1.32;
1.30;
1.28;
1.26;
1.24;
1.22;
1.20;
1.18;
1.16;
1.14;
1.12;
1.10;
1.08;
1.06;
1.04;
1.02;
1.00;










*/
    //AgeFactor

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


    print("sdsdkldsfj" + AgeFactorForInjury.toString());
    setState(() {});

  }

  calculateAgeMMI() {
    // var a = DateTime.parse(edt_date_of_inquiry.text);
    //  var b = DateTime.parse(edt_date_of_birth.text);

    DateTime start = DateFormat("MM-dd-yyyy").parse(edt_date_of_mmi.text);
    DateTime end = new DateFormat("MM-dd-yyyy").parse(edt_date_of_birth.text);

    var years = start.difference(end);

    int y = years.inDays ~/ 365;
    print("TotalYear :- " + y.toString());

/*
1.78;
1.76;
1.74;
1.72;
1.70;
1.68;
1.66;
1.64;
1.62;
1.60;
1.58;
1.56;
1.54;
1.52;
1.50;
1.48;
1.46;
1.44;
1.42;
1.40;
1.38;
1.36;
1.34;
1.32;
1.30;
1.28;
1.26;
1.24;
1.22;
1.20;
1.18;
1.16;
1.14;
1.12;
1.10;
1.08;
1.06;
1.04;
1.02;
1.00;










*/
    //AgeFactor

    if (y < 21) {
      AgeFactor = 1.80;
    } else if (y == 21) {
      AgeFactor = 1.78;
    } else if (y == 22) {
      AgeFactor = 1.76;
    } else if (y == 23) {
      AgeFactor = 1.74;
    } else if (y == 24) {
      AgeFactor = 1.72;
    } else if (y == 25) {
      AgeFactor = 1.70;
    } else if (y == 26) {
      AgeFactor = 1.68;
    } else if (y == 27) {
      AgeFactor = 1.66;
    } else if (y == 28) {
      AgeFactor = 1.64;
    } else if (y == 29) {
      AgeFactor = 1.62;
    } else if (y == 30) {
      AgeFactor = 1.60;
    } else if (y == 31) {
      AgeFactor = 1.58;
    } else if (y == 32) {
      AgeFactor = 1.56;
    } else if (y == 33) {
      AgeFactor = 1.54;
    } else if (y == 34) {
      AgeFactor = 1.52;
    } else if (y == 35) {
      AgeFactor = 1.50;
    } else if (y == 36) {
      AgeFactor = 1.48;
    } else if (y == 37) {
      AgeFactor = 1.46;
    } else if (y == 38) {
      AgeFactor = 1.44;
    } else if (y == 39) {
      AgeFactor = 1.42;
    } else if (y == 40) {
      AgeFactor = 1.40;
    } else if (y == 41) {
      AgeFactor = 1.38;
    } else if (y == 42) {
      AgeFactor = 1.36;
    } else if (y == 43) {
      AgeFactor = 1.34;
    } else if (y == 44) {
      AgeFactor = 1.32;
    } else if (y == 45) {
      AgeFactor = 1.30;
    } else if (y == 46) {
      AgeFactor = 1.28;
    } else if (y == 47) {
      AgeFactor = 1.26;
    } else if (y == 48) {
      AgeFactor = 1.24;
    } else if (y == 49) {
      AgeFactor = 1.22;
    } else if (y == 50) {
      AgeFactor = 1.20;
    } else if (y == 51) {
      AgeFactor = 1.18;
    } else if (y == 52) {
      AgeFactor = 1.16;
    } else if (y == 53) {
      AgeFactor = 1.14;
    } else if (y == 54) {
      AgeFactor = 1.12;
    } else if (y == 55) {
      AgeFactor = 1.10;
    } else if (y == 56) {
      AgeFactor = 1.08;
    } else if (y == 57) {
      AgeFactor = 1.06;
    } else if (y == 58) {
      AgeFactor = 1.04;
    } else if (y == 59) {
      AgeFactor = 1.02;
    } else if (y == 60) {
      AgeFactor = 1.00;
    } else if (y > 60) {
      AgeFactor = 1.00;
    }

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
                                onChanged: (value){
                                  wholePersonimperimentsCalculation();
                                  setState(() {

                                  });

                                },
                                decoration: InputDecoration(
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
                          onChanged: (value){
                            wholePersonimperimentsCalculation();
                            setState(() {

                            });
                          },
                          decoration: InputDecoration(
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
                          onChanged: (value){

                            wholePersonimperimentsCalculation();
                            setState(() {

                            });
                          },
                          controller: edt_whole_person_impliment_rating,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
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
                          },
                          decoration: InputDecoration(
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
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
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
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
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
                          },
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
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
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
        ),
        Container(
          child: Column(
            children: [
              SizedBox(
                width: 10,
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
                                margin: EdgeInsets.only(
                                    bottom: 10, left: 10, right: 10),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                          enabled: false,
                                          keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                          textInputAction: TextInputAction.next,
                                          controller: edt_Whole_Person_Rating,
                                          decoration: InputDecoration(
                                              contentPadding:
                                              const EdgeInsets.only(top: 10.0),
                                              // border: UnderlineInputBorder(),
                                              labelText: 'Whole Person Rating',
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
                                          keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                          controller: edt_Value_of_the_Rating,
                                          decoration: InputDecoration(
                                              border: UnderlineInputBorder(),
                                              labelText: 'Value of the Rating',
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
                                margin: EdgeInsets.only(
                                    bottom: 10, left: 10, right: 10),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                          textInputAction: TextInputAction.next,
                                          keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                          controller:
                                          edt_Impairment_Rating_Right_Upper,
                                          onChanged: (value){
                                           /* double d = edt_right_upper_extremity_rating.text.toString() == "" ? 0.00 : double.parse(edt_right_upper_extremity_rating.text.toString());
                                            double e = edt_left_upper_extremity_rating.text.toString() == "" ? 0.00 : double.parse(edt_left_upper_extremity_rating.text.toString());
                                            double f = edt_left_lower_extremity_rating.text.toString() == "" ? 0.00 : double.parse(edt_left_lower_extremity_rating.text.toString());
                                            double g = edt_right_lower_extremity_rating.text.toString() == "" ? 0.00 : double.parse(edt_right_lower_extremity_rating.text.toString());
                                            Totalrate = d+e+f+g;
                                            edt_Total_Scheduled_Rate.text = Totalrate.toStringAsFixed(2);
                                            setState(() {

                                            });*/
                                          },
                                          enabled: false,
                                          decoration: InputDecoration(
                                              contentPadding:
                                              const EdgeInsets.only(top: 10.0),
                                              // border: UnderlineInputBorder(),
                                              labelText: 'Impairment Rating',
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
                                          keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                          controller:
                                          edt_Value_of_the_Rating_Right_Upper,
                                          enabled: false,
                                          decoration: InputDecoration(
                                              border: UnderlineInputBorder(),
                                              labelText: 'Value of the Rating',
                                              errorText: ISErrorrightUppervalue==true? LessMore4<0? "More \$" +LessMore4.toStringAsFixed(2):"Less \$" +LessMore4.toStringAsFixed(2) :null,
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
                                margin: EdgeInsets.only(
                                    bottom: 10, left: 10, right: 10),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                          textInputAction: TextInputAction.next,
                                          keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                          controller:
                                          edt_Impairment_Rating_Left_Upper,
                                          onChanged: (value){

                                          },
                                          enabled: false,
                                          decoration: InputDecoration(
                                              contentPadding:
                                              const EdgeInsets.only(top: 10.0),
                                              // border: UnderlineInputBorder(),
                                              labelText: 'Impairment Rating',
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
                                          keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                          controller:
                                          edt_Value_of_the_Rating_Left_Upper,
                                          enabled: false,
                                          decoration: InputDecoration(
                                              border: UnderlineInputBorder(),
                                              labelText: 'Value of the Rating',
                                              errorText: ISErrorleftUppervalue==true? LessMore3<0? "More \$" +LessMore3.toStringAsFixed(2):"Less \$" +LessMore3.toStringAsFixed(2) :null,
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
                                margin: EdgeInsets.only(
                                    bottom: 10, left: 10, right: 10),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                          textInputAction: TextInputAction.next,
                                          keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                          controller:
                                          edt_Impairment_Rating_Right_Lower,
                                          onChanged: (value){

                                          },
                                          enabled: false,
                                          decoration: InputDecoration(
                                              contentPadding:
                                              const EdgeInsets.only(top: 10.0),
                                              // border: UnderlineInputBorder(),
                                              labelText: 'Impairment Rating',
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
                                          keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                          controller:
                                          edt_Value_of_the_Rating_Right_Lower,
                                          enabled: false,
                                          decoration: InputDecoration(
                                              border: UnderlineInputBorder(),
                                              labelText: 'Value of the Rating',
                                             // errorText : "sdfds",
                                            errorStyle: TextStyle(color: Colors.red),
                                             errorText: ISErrorrightLowervalue==true? LessMore1<0? "More \$" +LessMore1.toStringAsFixed(2):"Less \$" +LessMore1.toStringAsFixed(2) :null,
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
                                margin: EdgeInsets.only(
                                    bottom: 10, left: 10, right: 10),
                                child: Row(
                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                          textInputAction: TextInputAction.next,
                                          keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                          controller:
                                          edt_Impairment_Rating_Left_Lower,
                                          enabled: false,
                                          onChanged: (value){

                                          },
                                          decoration: InputDecoration(
                                              contentPadding:
                                              const EdgeInsets.only(top: 10.0),
                                              // border: UnderlineInputBorder(),
                                              labelText: 'Impairment Rating',

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
                                          keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true),
                                          controller:
                                          edt_Value_of_the_Rating_Left_Lower,
                                          enabled: false,
                                          decoration: InputDecoration(
                                              border: UnderlineInputBorder(),
                                              labelText: 'Value of the Rating',
                                              errorText: ISErrorleftLowervalue==true? LessMore2<0? "More \$" +LessMore2.toStringAsFixed(2):"Less \$" +LessMore2.toStringAsFixed(2) :null,
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
              ),


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
                                    border: UnderlineInputBorder(),
                                    labelText: 'Total Scheduled Rate',
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

                                controller: edt_Combined_Whole_Person_Rate,
                                decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Combined Whole Person Rate',
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
                                controller:
                                    edt_Total_Award_Value_With_Current_Conversations,
                                decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText:
                                        'Total Award Value With Current Conversations',
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
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText:
                                        'Potential Combined Whole Person Rating',
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
                                controller: edt_Benefits_Cap,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Benefits Cap',
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
                                controller:
                                    Total_TTD_TPD_benefits_you_have_received,
                                decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText:
                                        'Total TTD/TPD benefits you have received',
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
                                controller: Amount_Remaining_to_Reach_Cap,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                    border: UnderlineInputBorder(),
                                    labelText: 'Amount Remaining to Reach Cap',
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
                    navigateTo(context, PpdAwardScreen.routeName,
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

     double TTDRate=0.00;

     print("DateofInjuryAdge" + " AdgeFactor" + AgeFactorForInjury.toString());


    double a = edt_whole_person_impliment_rating.text.toString() == "" ? 0.00 : double.parse(edt_whole_person_impliment_rating.text.toString());


    edt_Whole_Person_Rating.text = a.toStringAsFixed(2);
    if(a>25)
      {
        edt_Benefits_Cap.text = edt_Benefits_Cap2nd.text;
      }
    else
      {
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

    print("skjdskdsdfdsfd" + " max_aww : " +max_aww.toString() + " compRate : " + compRate.toString() );

    if(avgweek > max_aww){
      TTDRate = compRate;

    }
    else
      {
        TTDRate = (avgweek * 2)/3;

      }




    print("dskfdsfl" + TTDRate.toString());

    double resultb1 =  TTDRate * 400 * AgeFactorForInjury;
     double resultb = (resultb1 * a) / 100;



    print("valuewhole" + " wholeImpRate : " + a.toString() + " TTDRate " + TTDRate.toString() + " AdgefactorInjury " + AgeFactorForInjury.toString() );

     print("Totaldf" + " wholeImpRate : " +resultb.toString()) ;

     edt_Value_of_the_Rating.text = resultb.toStringAsFixed(2);


    double ttd_tpd =  edt_total_ttd_tpd.text.toString() == "" ? 0.00 : double.parse(edt_total_ttd_tpd.text.toString());
    double banifitcap =  edt_Benefits_Cap.text.toString() == "" ? 0.00 : double.parse(edt_Benefits_Cap.text.toString());


    double tot_ttd_tpd_rec =  ttd_tpd + resultb;

    if(tot_ttd_tpd_rec>banifitcap)
      {
       // Total_TTD_TPD_benefits_you_have_received.text = banifitcap.toStringAsFixed(2);

        isErrorforbenifitCap = true;


      }
    else
      {
       // Total_TTD_TPD_benefits_you_have_received.text =tot_ttd_tpd_rec.toStringAsFixed(2);
        isErrorforbenifitCap = false;
      }



    double temp = Total_TTD_TPD_benefits_you_have_received.text.toString() == "" ? 0.00 : double.parse(Total_TTD_TPD_benefits_you_have_received.text.toString());


     Total_TTD_TPD_benefits_you_have_received.text =ttd_tpd.toStringAsFixed(2);

    double newcal =  banifitcap - resultb - ttd_tpd;



    Amount_Remaining_to_Reach_Cap.text = newcal.toStringAsFixed(2);

    setState(() {});
  }

  void getDateofInjuryResult(MaxBenifitDateofInjuryResponseState state) {
    edt_Benefits_Cap1st.text = state.maxBenifitResponse.data.details.s1cap.toString();
    edt_Benefits_Cap2nd.text = state.maxBenifitResponse.data.details.s2cap.toString();

    edt_MAX_AWW.text = state.maxBenifitResponse.data.details.aww.toString();

    edt_COMP_RATE.text = state.maxBenifitResponse.data.details.comp.toString();
    calculateAgeOFInjury();
  }

  void RightLowerExtremlyCovertFormula(bool value) {

    print("sd00dff" + value.toString());

    if(edt_right_lower_extremity_rating.text.isNotEmpty)
      {
        if(value==true)
        {

          double TTDRate=0.00;
         // double a = edt_Impairment_Rating_Right_Lower.text.toString() == "" ? 0.00 : double.parse(edt_Impairment_Rating_Right_Lower.text.toString());

          double test = edt_right_lower_extremity_rating.text.toString() == "" ? 0.00 : double.parse(edt_right_lower_extremity_rating.text.toString());

          int test1 = test.toInt();
          if(test1==	0	)	{	edt_Impairment_Rating_Right_Lower.text =	"0";	}
          if(test1==	1	)	{	edt_Impairment_Rating_Right_Lower.text =	"0";	}
          if(test1==	2	)	{	edt_Impairment_Rating_Right_Lower.text =	"1";	}
          if(test1==	3	)	{	edt_Impairment_Rating_Right_Lower.text =	"1";	}
          if(test1==	4	)	{	edt_Impairment_Rating_Right_Lower.text =	"2";	}
          if(test1==	5	)	{	edt_Impairment_Rating_Right_Lower.text =	"2";	}
          if(test1==	6	)	{	edt_Impairment_Rating_Right_Lower.text =	"2";	}
          if(test1==	7	)	{	edt_Impairment_Rating_Right_Lower.text =	"3";	}
          if(test1==	8	)	{	edt_Impairment_Rating_Right_Lower.text =	"3";	}
          if(test1==	9	)	{	edt_Impairment_Rating_Right_Lower.text =	"4";	}
          if(test1==	10	)	{	edt_Impairment_Rating_Right_Lower.text =	"4";	}
          if(test1==	11	)	{	edt_Impairment_Rating_Right_Lower.text =	"4";	}
          if(test1==	12	)	{	edt_Impairment_Rating_Right_Lower.text =	"5";	}
          if(test1==	13	)	{	edt_Impairment_Rating_Right_Lower.text =	"5";	}
          if(test1==	14	)	{	edt_Impairment_Rating_Right_Lower.text =	"6";	}
          if(test1==	15	)	{	edt_Impairment_Rating_Right_Lower.text =	"6";	}
          if(test1==	16	)	{	edt_Impairment_Rating_Right_Lower.text =	"6";	}
          if(test1==	17	)	{	edt_Impairment_Rating_Right_Lower.text =	"7";	}
          if(test1==	18	)	{	edt_Impairment_Rating_Right_Lower.text =	"7";	}
          if(test1==	19	)	{	edt_Impairment_Rating_Right_Lower.text =	"8";	}
          if(test1==	20	)	{	edt_Impairment_Rating_Right_Lower.text =	"8";	}
          if(test1==	21	)	{	edt_Impairment_Rating_Right_Lower.text =	"8";	}
          if(test1==	22	)	{	edt_Impairment_Rating_Right_Lower.text =	"9";	}
          if(test1==	23	)	{	edt_Impairment_Rating_Right_Lower.text =	"9";	}
          if(test1==	24	)	{	edt_Impairment_Rating_Right_Lower.text =	"10";	}
          if(test1==	25	)	{	edt_Impairment_Rating_Right_Lower.text =	"10";	}
          if(test1==	26	)	{	edt_Impairment_Rating_Right_Lower.text =	"10";	}
          if(test1==	27	)	{	edt_Impairment_Rating_Right_Lower.text =	"11";	}
          if(test1==	28	)	{	edt_Impairment_Rating_Right_Lower.text =	"11";	}
          if(test1==	29	)	{	edt_Impairment_Rating_Right_Lower.text =	"12";	}
          if(test1==	30	)	{	edt_Impairment_Rating_Right_Lower.text =	"12";	}
          if(test1==	31	)	{	edt_Impairment_Rating_Right_Lower.text =	"12";	}
          if(test1==	32	)	{	edt_Impairment_Rating_Right_Lower.text =	"13";	}
          if(test1==	33	)	{	edt_Impairment_Rating_Right_Lower.text =	"13";	}
          if(test1==	34	)	{	edt_Impairment_Rating_Right_Lower.text =	"14";	}
          if(test1==	35	)	{	edt_Impairment_Rating_Right_Lower.text =	"14";	}
          if(test1==	36	)	{	edt_Impairment_Rating_Right_Lower.text =	"14";	}
          if(test1==	37	)	{	edt_Impairment_Rating_Right_Lower.text =	"15";	}
          if(test1==	38	)	{	edt_Impairment_Rating_Right_Lower.text =	"15";	}
          if(test1==	39	)	{	edt_Impairment_Rating_Right_Lower.text =	"16";	}
          if(test1==	40	)	{	edt_Impairment_Rating_Right_Lower.text =	"16";	}
          if(test1==	41	)	{	edt_Impairment_Rating_Right_Lower.text =	"16";	}
          if(test1==	42	)	{	edt_Impairment_Rating_Right_Lower.text =	"17";	}
          if(test1==	43	)	{	edt_Impairment_Rating_Right_Lower.text =	"17";	}
          if(test1==	44	)	{	edt_Impairment_Rating_Right_Lower.text =	"18";	}
          if(test1==	45	)	{	edt_Impairment_Rating_Right_Lower.text =	"18";	}
          if(test1==	46	)	{	edt_Impairment_Rating_Right_Lower.text =	"18";	}
          if(test1==	47	)	{	edt_Impairment_Rating_Right_Lower.text =	"19";	}
          if(test1==	48	)	{	edt_Impairment_Rating_Right_Lower.text =	"19";	}
          if(test1==	49	)	{	edt_Impairment_Rating_Right_Lower.text =	"20";	}
          if(test1==	50	)	{	edt_Impairment_Rating_Right_Lower.text =	"20";	}
          if(test1==	51	)	{	edt_Impairment_Rating_Right_Lower.text =	"20";	}
          if(test1==	52	)	{	edt_Impairment_Rating_Right_Lower.text =	"21";	}
          if(test1==	53	)	{	edt_Impairment_Rating_Right_Lower.text =	"21";	}
          if(test1==	54	)	{	edt_Impairment_Rating_Right_Lower.text =	"22";	}
          if(test1==	55	)	{	edt_Impairment_Rating_Right_Lower.text =	"22";	}
          if(test1==	56	)	{	edt_Impairment_Rating_Right_Lower.text =	"22";	}
          if(test1==	57	)	{	edt_Impairment_Rating_Right_Lower.text =	"23";	}
          if(test1==	58	)	{	edt_Impairment_Rating_Right_Lower.text =	"23";	}
          if(test1==	59	)	{	edt_Impairment_Rating_Right_Lower.text =	"24";	}
          if(test1==	60	)	{	edt_Impairment_Rating_Right_Lower.text =	"24";	}
          if(test1==	61	)	{	edt_Impairment_Rating_Right_Lower.text =	"24";	}
          if(test1==	62	)	{	edt_Impairment_Rating_Right_Lower.text =	"25";	}
          if(test1==	63	)	{	edt_Impairment_Rating_Right_Lower.text =	"25";	}
          if(test1==	64	)	{	edt_Impairment_Rating_Right_Lower.text =	"26";	}
          if(test1==	65	)	{	edt_Impairment_Rating_Right_Lower.text =	"26";	}
          if(test1==	66	)	{	edt_Impairment_Rating_Right_Lower.text =	"28";	}
          if(test1==	67	)	{	edt_Impairment_Rating_Right_Lower.text =	"27";	}
          if(test1==	68	)	{	edt_Impairment_Rating_Right_Lower.text =	"27";	}
          if(test1==	69	)	{	edt_Impairment_Rating_Right_Lower.text =	"28";	}
          if(test1==	70	)	{	edt_Impairment_Rating_Right_Lower.text =	"28";	}
          if(test1==	71	)	{	edt_Impairment_Rating_Right_Lower.text =	"28";	}
          if(test1==	72	)	{	edt_Impairment_Rating_Right_Lower.text =	"29";	}
          if(test1==	73	)	{	edt_Impairment_Rating_Right_Lower.text =	"29";	}
          if(test1==	74	)	{	edt_Impairment_Rating_Right_Lower.text =	"30";	}
          if(test1==	75	)	{	edt_Impairment_Rating_Right_Lower.text =	"30";	}
          if(test1==	76	)	{	edt_Impairment_Rating_Right_Lower.text =	"30";	}
          if(test1==	77	)	{	edt_Impairment_Rating_Right_Lower.text =	"31";	}
          if(test1==	78	)	{	edt_Impairment_Rating_Right_Lower.text =	"31";	}
          if(test1==	79	)	{	edt_Impairment_Rating_Right_Lower.text =	"32";	}
          if(test1==	80	)	{	edt_Impairment_Rating_Right_Lower.text =	"32";	}
          if(test1==	81	)	{	edt_Impairment_Rating_Right_Lower.text =	"32";	}
          if(test1==	82	)	{	edt_Impairment_Rating_Right_Lower.text =	"33";	}
          if(test1==	83	)	{	edt_Impairment_Rating_Right_Lower.text =	"33";	}
          if(test1==	84	)	{	edt_Impairment_Rating_Right_Lower.text =	"34";	}
          if(test1==	85	)	{	edt_Impairment_Rating_Right_Lower.text =	"34";	}
          if(test1==	86	)	{	edt_Impairment_Rating_Right_Lower.text =	"34";	}
          if(test1==	87	)	{	edt_Impairment_Rating_Right_Lower.text =	"35";	}
          if(test1==	88	)	{	edt_Impairment_Rating_Right_Lower.text =	"35";	}
          if(test1==	89	)	{	edt_Impairment_Rating_Right_Lower.text =	"36";	}
          if(test1==	90	)	{	edt_Impairment_Rating_Right_Lower.text =	"36";	}
          if(test1==	91	)	{	edt_Impairment_Rating_Right_Lower.text =	"36";	}
          if(test1==	92	)	{	edt_Impairment_Rating_Right_Lower.text =	"37";	}
          if(test1==	93	)	{	edt_Impairment_Rating_Right_Lower.text =	"37";	}
          if(test1==	94	)	{	edt_Impairment_Rating_Right_Lower.text =	"38";	}
          if(test1==	95	)	{	edt_Impairment_Rating_Right_Lower.text =	"38";	}
          if(test1==	96	)	{	edt_Impairment_Rating_Right_Lower.text =	"38";	}
          if(test1==	97	)	{	edt_Impairment_Rating_Right_Lower.text =	"39";	}
          if(test1==	98	)	{	edt_Impairment_Rating_Right_Lower.text =	"39";	}
          if(test1==	99	)	{	edt_Impairment_Rating_Right_Lower.text =	"40";	}
          if(test1==	100	)	{	edt_Impairment_Rating_Right_Lower.text =	"40";	}










          double a = edt_Impairment_Rating_Right_Lower.text.toString() == "" ? 0.00 : double.parse(edt_Impairment_Rating_Right_Lower.text.toString());

          double avgweek = edt_avg_weekly_wage.text.toString() == ""
              ? 0.00
              : double.parse(edt_avg_weekly_wage.text);
          double max_aww = edt_MAX_AWW.text.toString() == ""
              ? 0.00
              : double.parse(edt_MAX_AWW.text);
          double compRate = edt_COMP_RATE.text.toString() == ""
              ? 0.00
              : double.parse(edt_COMP_RATE.text);
          if(avgweek > max_aww){
            TTDRate = compRate;
          }
          else
          {
            TTDRate = (avgweek * 2)/3;
          }
          double resultb1 =  TTDRate * 400 * AgeFactorForInjury;
          double resultb = (resultb1 * a) / 100;
          edt_Value_of_the_Rating_Right_Lower.text = resultb.toStringAsFixed(2);
          LessMore1 =0.00;
          LessMore1 = rightLowervalue - resultb ;


           ISErrorrightLowervalue  =true;


          /* double rightLowervalue = 0.00;
  double rightUppervalue = 0.00;
  double leftLowervalue = 0.00;
  double leftUppervalue = 0.00;*/

        }
        else{
          print("dfdfeer" + edt_right_lower_extremity_rating.text.toString());


          rightlowerExtremlyRatecalculation(edt_right_lower_extremity_rating.text);
          ISErrorrightLowervalue  =false;

        }
      }


  }


  void  LefttLowerExtremlyCovertFormula (bool value) {

    print("sd00dff" + value.toString());

    if(edt_left_lower_extremity_rating.text.isNotEmpty)
    {
      if(value==true)
      {

        double TTDRate=0.00;
        // double a = edt_Impairment_Rating_Right_Lower.text.toString() == "" ? 0.00 : double.parse(edt_Impairment_Rating_Right_Lower.text.toString());

        double test = edt_left_lower_extremity_rating.text.toString() == "" ? 0.00 : double.parse(edt_left_lower_extremity_rating.text.toString());

        int test1 = test.toInt();
        if(test1==	0	)	{	edt_Impairment_Rating_Left_Lower.text =	"0";	}
        if(test1==	1	)	{	edt_Impairment_Rating_Left_Lower.text =	"0";	}
        if(test1==	2	)	{	edt_Impairment_Rating_Left_Lower.text =	"1";	}
        if(test1==	3	)	{	edt_Impairment_Rating_Left_Lower.text =	"1";	}
        if(test1==	4	)	{	edt_Impairment_Rating_Left_Lower.text =	"2";	}
        if(test1==	5	)	{	edt_Impairment_Rating_Left_Lower.text =	"2";	}
        if(test1==	6	)	{	edt_Impairment_Rating_Left_Lower.text =	"2";	}
        if(test1==	7	)	{	edt_Impairment_Rating_Left_Lower.text =	"3";	}
        if(test1==	8	)	{	edt_Impairment_Rating_Left_Lower.text =	"3";	}
        if(test1==	9	)	{	edt_Impairment_Rating_Left_Lower.text =	"4";	}
        if(test1==	10	)	{	edt_Impairment_Rating_Left_Lower.text =	"4";	}
        if(test1==	11	)	{	edt_Impairment_Rating_Left_Lower.text =	"4";	}
        if(test1==	12	)	{	edt_Impairment_Rating_Left_Lower.text =	"5";	}
        if(test1==	13	)	{	edt_Impairment_Rating_Left_Lower.text =	"5";	}
        if(test1==	14	)	{	edt_Impairment_Rating_Left_Lower.text =	"6";	}
        if(test1==	15	)	{	edt_Impairment_Rating_Left_Lower.text =	"6";	}
        if(test1==	16	)	{	edt_Impairment_Rating_Left_Lower.text =	"6";	}
        if(test1==	17	)	{	edt_Impairment_Rating_Left_Lower.text =	"7";	}
        if(test1==	18	)	{	edt_Impairment_Rating_Left_Lower.text =	"7";	}
        if(test1==	19	)	{	edt_Impairment_Rating_Left_Lower.text =	"8";	}
        if(test1==	20	)	{	edt_Impairment_Rating_Left_Lower.text =	"8";	}
        if(test1==	21	)	{	edt_Impairment_Rating_Left_Lower.text =	"8";	}
        if(test1==	22	)	{	edt_Impairment_Rating_Left_Lower.text =	"9";	}
        if(test1==	23	)	{	edt_Impairment_Rating_Left_Lower.text =	"9";	}
        if(test1==	24	)	{	edt_Impairment_Rating_Left_Lower.text =	"10";	}
        if(test1==	25	)	{	edt_Impairment_Rating_Left_Lower.text =	"10";	}
        if(test1==	26	)	{	edt_Impairment_Rating_Left_Lower.text =	"10";	}
        if(test1==	27	)	{	edt_Impairment_Rating_Left_Lower.text =	"11";	}
        if(test1==	28	)	{	edt_Impairment_Rating_Left_Lower.text =	"11";	}
        if(test1==	29	)	{	edt_Impairment_Rating_Left_Lower.text =	"12";	}
        if(test1==	30	)	{	edt_Impairment_Rating_Left_Lower.text =	"12";	}
        if(test1==	31	)	{	edt_Impairment_Rating_Left_Lower.text =	"12";	}
        if(test1==	32	)	{	edt_Impairment_Rating_Left_Lower.text =	"13";	}
        if(test1==	33	)	{	edt_Impairment_Rating_Left_Lower.text =	"13";	}
        if(test1==	34	)	{	edt_Impairment_Rating_Left_Lower.text =	"14";	}
        if(test1==	35	)	{	edt_Impairment_Rating_Left_Lower.text =	"14";	}
        if(test1==	36	)	{	edt_Impairment_Rating_Left_Lower.text =	"14";	}
        if(test1==	37	)	{	edt_Impairment_Rating_Left_Lower.text =	"15";	}
        if(test1==	38	)	{	edt_Impairment_Rating_Left_Lower.text =	"15";	}
        if(test1==	39	)	{	edt_Impairment_Rating_Left_Lower.text =	"16";	}
        if(test1==	40	)	{	edt_Impairment_Rating_Left_Lower.text =	"16";	}
        if(test1==	41	)	{	edt_Impairment_Rating_Left_Lower.text =	"16";	}
        if(test1==	42	)	{	edt_Impairment_Rating_Left_Lower.text =	"17";	}
        if(test1==	43	)	{	edt_Impairment_Rating_Left_Lower.text =	"17";	}
        if(test1==	44	)	{	edt_Impairment_Rating_Left_Lower.text =	"18";	}
        if(test1==	45	)	{	edt_Impairment_Rating_Left_Lower.text =	"18";	}
        if(test1==	46	)	{	edt_Impairment_Rating_Left_Lower.text =	"18";	}
        if(test1==	47	)	{	edt_Impairment_Rating_Left_Lower.text =	"19";	}
        if(test1==	48	)	{	edt_Impairment_Rating_Left_Lower.text =	"19";	}
        if(test1==	49	)	{	edt_Impairment_Rating_Left_Lower.text =	"20";	}
        if(test1==	50	)	{	edt_Impairment_Rating_Left_Lower.text =	"20";	}
        if(test1==	51	)	{	edt_Impairment_Rating_Left_Lower.text =	"20";	}
        if(test1==	52	)	{	edt_Impairment_Rating_Left_Lower.text =	"21";	}
        if(test1==	53	)	{	edt_Impairment_Rating_Left_Lower.text =	"21";	}
        if(test1==	54	)	{	edt_Impairment_Rating_Left_Lower.text =	"22";	}
        if(test1==	55	)	{	edt_Impairment_Rating_Left_Lower.text =	"22";	}
        if(test1==	56	)	{	edt_Impairment_Rating_Left_Lower.text =	"22";	}
        if(test1==	57	)	{	edt_Impairment_Rating_Left_Lower.text =	"23";	}
        if(test1==	58	)	{	edt_Impairment_Rating_Left_Lower.text =	"23";	}
        if(test1==	59	)	{	edt_Impairment_Rating_Left_Lower.text =	"24";	}
        if(test1==	60	)	{	edt_Impairment_Rating_Left_Lower.text =	"24";	}
        if(test1==	61	)	{	edt_Impairment_Rating_Left_Lower.text =	"24";	}
        if(test1==	62	)	{	edt_Impairment_Rating_Left_Lower.text =	"25";	}
        if(test1==	63	)	{	edt_Impairment_Rating_Left_Lower.text =	"25";	}
        if(test1==	64	)	{	edt_Impairment_Rating_Left_Lower.text =	"26";	}
        if(test1==	65	)	{	edt_Impairment_Rating_Left_Lower.text =	"26";	}
        if(test1==	66	)	{	edt_Impairment_Rating_Left_Lower.text =	"28";	}
        if(test1==	67	)	{	edt_Impairment_Rating_Left_Lower.text =	"27";	}
        if(test1==	68	)	{	edt_Impairment_Rating_Left_Lower.text =	"27";	}
        if(test1==	69	)	{	edt_Impairment_Rating_Left_Lower.text =	"28";	}
        if(test1==	70	)	{	edt_Impairment_Rating_Left_Lower.text =	"28";	}
        if(test1==	71	)	{	edt_Impairment_Rating_Left_Lower.text =	"28";	}
        if(test1==	72	)	{	edt_Impairment_Rating_Left_Lower.text =	"29";	}
        if(test1==	73	)	{	edt_Impairment_Rating_Left_Lower.text =	"29";	}
        if(test1==	74	)	{	edt_Impairment_Rating_Left_Lower.text =	"30";	}
        if(test1==	75	)	{	edt_Impairment_Rating_Left_Lower.text =	"30";	}
        if(test1==	76	)	{	edt_Impairment_Rating_Left_Lower.text =	"30";	}
        if(test1==	77	)	{	edt_Impairment_Rating_Left_Lower.text =	"31";	}
        if(test1==	78	)	{	edt_Impairment_Rating_Left_Lower.text =	"31";	}
        if(test1==	79	)	{	edt_Impairment_Rating_Left_Lower.text =	"32";	}
        if(test1==	80	)	{	edt_Impairment_Rating_Left_Lower.text =	"32";	}
        if(test1==	81	)	{	edt_Impairment_Rating_Left_Lower.text =	"32";	}
        if(test1==	82	)	{	edt_Impairment_Rating_Left_Lower.text =	"33";	}
        if(test1==	83	)	{	edt_Impairment_Rating_Left_Lower.text =	"33";	}
        if(test1==	84	)	{	edt_Impairment_Rating_Left_Lower.text =	"34";	}
        if(test1==	85	)	{	edt_Impairment_Rating_Left_Lower.text =	"34";	}
        if(test1==	86	)	{	edt_Impairment_Rating_Left_Lower.text =	"34";	}
        if(test1==	87	)	{	edt_Impairment_Rating_Left_Lower.text =	"35";	}
        if(test1==	88	)	{	edt_Impairment_Rating_Left_Lower.text =	"35";	}
        if(test1==	89	)	{	edt_Impairment_Rating_Left_Lower.text =	"36";	}
        if(test1==	90	)	{	edt_Impairment_Rating_Left_Lower.text =	"36";	}
        if(test1==	91	)	{	edt_Impairment_Rating_Left_Lower.text =	"36";	}
        if(test1==	92	)	{	edt_Impairment_Rating_Left_Lower.text =	"37";	}
        if(test1==	93	)	{	edt_Impairment_Rating_Left_Lower.text =	"37";	}
        if(test1==	94	)	{	edt_Impairment_Rating_Left_Lower.text =	"38";	}
        if(test1==	95	)	{	edt_Impairment_Rating_Left_Lower.text =	"38";	}
        if(test1==	96	)	{	edt_Impairment_Rating_Left_Lower.text =	"38";	}
        if(test1==	97	)	{	edt_Impairment_Rating_Left_Lower.text =	"39";	}
        if(test1==	98	)	{	edt_Impairment_Rating_Left_Lower.text =	"39";	}
        if(test1==	99	)	{	edt_Impairment_Rating_Left_Lower.text =	"40";	}
        if(test1==	100	)	{	edt_Impairment_Rating_Left_Lower.text =	"40";	}










        double a = edt_Impairment_Rating_Left_Lower.text.toString() == "" ? 0.00 : double.parse(edt_Impairment_Rating_Left_Lower.text.toString());

        double avgweek = edt_avg_weekly_wage.text.toString() == ""
            ? 0.00
            : double.parse(edt_avg_weekly_wage.text);
        double max_aww = edt_MAX_AWW.text.toString() == ""
            ? 0.00
            : double.parse(edt_MAX_AWW.text);
        double compRate = edt_COMP_RATE.text.toString() == ""
            ? 0.00
            : double.parse(edt_COMP_RATE.text);
        if(avgweek > max_aww){
          TTDRate = compRate;
        }
        else
        {
          TTDRate = (avgweek * 2)/3;
        }
        double resultb1 =  TTDRate * 400 * AgeFactorForInjury;
        double resultb = (resultb1 * a) / 100;
        edt_Value_of_the_Rating_Left_Lower.text = resultb.toStringAsFixed(2);

        LessMore2 =0.00;
        LessMore2 = leftLowervalue - resultb ;
        ISErrorleftLowervalue = true;
      }
      else{
        print("dfdfeer" + edt_left_lower_extremity_rating.text.toString());


        leftlowerExtremlyRatecalculation(edt_left_lower_extremity_rating.text);
        ISErrorleftLowervalue = false;

      }
    }


  }

  void LefttUpperExtremlyCovertFormula(bool value) {
    print("sd00dff" + value.toString());

    if(edt_left_upper_extremity_rating.text.isNotEmpty)
    {
      if(value==true)
      {

        double TTDRate=0.00;
        // double a = edt_Impairment_Rating_Right_Lower.text.toString() == "" ? 0.00 : double.parse(edt_Impairment_Rating_Right_Lower.text.toString());

        double test = edt_left_upper_extremity_rating.text.toString() == "" ? 0.00 : double.parse(edt_left_upper_extremity_rating.text.toString());

        int test1 = test.toInt();
        if(test1==	0	)	{	edt_Impairment_Rating_Left_Upper.text =	"0";	}
        if(test1==	1	)	{	edt_Impairment_Rating_Left_Upper.text =	"1";	}
        if(test1==	2	)	{	edt_Impairment_Rating_Left_Upper.text =	"1";	}
        if(test1==	3	)	{	edt_Impairment_Rating_Left_Upper.text =	"2";	}
        if(test1==	4	)	{	edt_Impairment_Rating_Left_Upper.text =	"2";	}
        if(test1==	5	)	{	edt_Impairment_Rating_Left_Upper.text =	"3";	}
        if(test1==	6	)	{	edt_Impairment_Rating_Left_Upper.text =	"4";	}
        if(test1==	7	)	{	edt_Impairment_Rating_Left_Upper.text =	"4";	}
        if(test1==	8	)	{	edt_Impairment_Rating_Left_Upper.text =	"5";	}
        if(test1==	9	)	{	edt_Impairment_Rating_Left_Upper.text =	"5";	}
        if(test1==	10	)	{	edt_Impairment_Rating_Left_Upper.text =	"6";	}
        if(test1==	11	)	{	edt_Impairment_Rating_Left_Upper.text =	"7";	}
        if(test1==	12	)	{	edt_Impairment_Rating_Left_Upper.text =	"7";	}
        if(test1==	13	)	{	edt_Impairment_Rating_Left_Upper.text =	"8";	}
        if(test1==	14	)	{	edt_Impairment_Rating_Left_Upper.text =	"8";	}
        if(test1==	15	)	{	edt_Impairment_Rating_Left_Upper.text =	"9";	}
        if(test1==	16	)	{	edt_Impairment_Rating_Left_Upper.text =	"10";	}
        if(test1==	17	)	{	edt_Impairment_Rating_Left_Upper.text =	"10";	}
        if(test1==	18	)	{	edt_Impairment_Rating_Left_Upper.text =	"11";	}
        if(test1==	19	)	{	edt_Impairment_Rating_Left_Upper.text =	"11";	}
        if(test1==	20	)	{	edt_Impairment_Rating_Left_Upper.text =	"12";	}
        if(test1==	21	)	{	edt_Impairment_Rating_Left_Upper.text =	"13";	}
        if(test1==	22	)	{	edt_Impairment_Rating_Left_Upper.text =	"13";	}
        if(test1==	23	)	{	edt_Impairment_Rating_Left_Upper.text =	"14";	}
        if(test1==	24	)	{	edt_Impairment_Rating_Left_Upper.text =	"14";	}
        if(test1==	25	)	{	edt_Impairment_Rating_Left_Upper.text =	"15";	}
        if(test1==	26	)	{	edt_Impairment_Rating_Left_Upper.text =	"16";	}
        if(test1==	27	)	{	edt_Impairment_Rating_Left_Upper.text =	"16";	}
        if(test1==	28	)	{	edt_Impairment_Rating_Left_Upper.text =	"17";	}
        if(test1==	29	)	{	edt_Impairment_Rating_Left_Upper.text =	"17";	}
        if(test1==	30	)	{	edt_Impairment_Rating_Left_Upper.text =	"18";	}
        if(test1==	31	)	{	edt_Impairment_Rating_Left_Upper.text =	"19";	}
        if(test1==	32	)	{	edt_Impairment_Rating_Left_Upper.text =	"19";	}
        if(test1==	33	)	{	edt_Impairment_Rating_Left_Upper.text =	"20";	}
        if(test1==	34	)	{	edt_Impairment_Rating_Left_Upper.text =	"20";	}
        if(test1==	35	)	{	edt_Impairment_Rating_Left_Upper.text =	"21";	}
        if(test1==	36	)	{	edt_Impairment_Rating_Left_Upper.text =	"22";	}
        if(test1==	37	)	{	edt_Impairment_Rating_Left_Upper.text =	"22";	}
        if(test1==	38	)	{	edt_Impairment_Rating_Left_Upper.text =	"23";	}
        if(test1==	39	)	{	edt_Impairment_Rating_Left_Upper.text =	"23";	}
        if(test1==	40	)	{	edt_Impairment_Rating_Left_Upper.text =	"24";	}
        if(test1==	41	)	{	edt_Impairment_Rating_Left_Upper.text =	"25";	}
        if(test1==	42	)	{	edt_Impairment_Rating_Left_Upper.text =	"25";	}
        if(test1==	43	)	{	edt_Impairment_Rating_Left_Upper.text =	"26";	}
        if(test1==	44	)	{	edt_Impairment_Rating_Left_Upper.text =	"26";	}
        if(test1==	45	)	{	edt_Impairment_Rating_Left_Upper.text =	"27";	}
        if(test1==	46	)	{	edt_Impairment_Rating_Left_Upper.text =	"28";	}
        if(test1==	47	)	{	edt_Impairment_Rating_Left_Upper.text =	"28";	}
        if(test1==	48	)	{	edt_Impairment_Rating_Left_Upper.text =	"29";	}
        if(test1==	49	)	{	edt_Impairment_Rating_Left_Upper.text =	"29";	}
        if(test1==	50	)	{	edt_Impairment_Rating_Left_Upper.text =	"30";	}
        if(test1==	51	)	{	edt_Impairment_Rating_Left_Upper.text =	"31";	}
        if(test1==	52	)	{	edt_Impairment_Rating_Left_Upper.text =	"31";	}
        if(test1==	53	)	{	edt_Impairment_Rating_Left_Upper.text =	"32";	}
        if(test1==	54	)	{	edt_Impairment_Rating_Left_Upper.text =	"32";	}
        if(test1==	55	)	{	edt_Impairment_Rating_Left_Upper.text =	"33";	}
        if(test1==	56	)	{	edt_Impairment_Rating_Left_Upper.text =	"34";	}
        if(test1==	57	)	{	edt_Impairment_Rating_Left_Upper.text =	"34";	}
        if(test1==	58	)	{	edt_Impairment_Rating_Left_Upper.text =	"35";	}
        if(test1==	59	)	{	edt_Impairment_Rating_Left_Upper.text =	"35";	}
        if(test1==	60	)	{	edt_Impairment_Rating_Left_Upper.text =	"36";	}
        if(test1==	61	)	{	edt_Impairment_Rating_Left_Upper.text =	"37";	}
        if(test1==	62	)	{	edt_Impairment_Rating_Left_Upper.text =	"37";	}
        if(test1==	63	)	{	edt_Impairment_Rating_Left_Upper.text =	"38";	}
        if(test1==	64	)	{	edt_Impairment_Rating_Left_Upper.text =	"38";	}
        if(test1==	65	)	{	edt_Impairment_Rating_Left_Upper.text =	"39";	}
        if(test1==	66	)	{	edt_Impairment_Rating_Left_Upper.text =	"40";	}
        if(test1==	67	)	{	edt_Impairment_Rating_Left_Upper.text =	"40";	}
        if(test1==	68	)	{	edt_Impairment_Rating_Left_Upper.text =	"41";	}
        if(test1==	69	)	{	edt_Impairment_Rating_Left_Upper.text =	"41";	}
        if(test1==	70	)	{	edt_Impairment_Rating_Left_Upper.text =	"42";	}
        if(test1==	71	)	{	edt_Impairment_Rating_Left_Upper.text =	"43";	}
        if(test1==	72	)	{	edt_Impairment_Rating_Left_Upper.text =	"43";	}
        if(test1==	73	)	{	edt_Impairment_Rating_Left_Upper.text =	"44";	}
        if(test1==	74	)	{	edt_Impairment_Rating_Left_Upper.text =	"44";	}
        if(test1==	75	)	{	edt_Impairment_Rating_Left_Upper.text =	"45";	}
        if(test1==	76	)	{	edt_Impairment_Rating_Left_Upper.text =	"46";	}
        if(test1==	77	)	{	edt_Impairment_Rating_Left_Upper.text =	"46";	}
        if(test1==	78	)	{	edt_Impairment_Rating_Left_Upper.text =	"47";	}
        if(test1==	79	)	{	edt_Impairment_Rating_Left_Upper.text =	"47";	}
        if(test1==	80	)	{	edt_Impairment_Rating_Left_Upper.text =	"48";	}
        if(test1==	81	)	{	edt_Impairment_Rating_Left_Upper.text =	"49";	}
        if(test1==	82	)	{	edt_Impairment_Rating_Left_Upper.text =	"49";	}
        if(test1==	83	)	{	edt_Impairment_Rating_Left_Upper.text =	"50";	}
        if(test1==	84	)	{	edt_Impairment_Rating_Left_Upper.text =	"50";	}
        if(test1==	85	)	{	edt_Impairment_Rating_Left_Upper.text =	"51";	}
        if(test1==	86	)	{	edt_Impairment_Rating_Left_Upper.text =	"52";	}
        if(test1==	87	)	{	edt_Impairment_Rating_Left_Upper.text =	"52";	}
        if(test1==	88	)	{	edt_Impairment_Rating_Left_Upper.text =	"53";	}
        if(test1==	89	)	{	edt_Impairment_Rating_Left_Upper.text =	"53";	}
        if(test1==	90	)	{	edt_Impairment_Rating_Left_Upper.text =	"54";	}
        if(test1==	91	)	{	edt_Impairment_Rating_Left_Upper.text =	"55";	}
        if(test1==	92	)	{	edt_Impairment_Rating_Left_Upper.text =	"55";	}
        if(test1==	93	)	{	edt_Impairment_Rating_Left_Upper.text =	"56";	}
        if(test1==	94	)	{	edt_Impairment_Rating_Left_Upper.text =	"56";	}
        if(test1==	95	)	{	edt_Impairment_Rating_Left_Upper.text =	"57";	}
        if(test1==	96	)	{	edt_Impairment_Rating_Left_Upper.text =	"58";	}
        if(test1==	97	)	{	edt_Impairment_Rating_Left_Upper.text =	"58";	}
        if(test1==	98	)	{	edt_Impairment_Rating_Left_Upper.text =	"59";	}
        if(test1==	99	)	{	edt_Impairment_Rating_Left_Upper.text =	"59";	}
        if(test1==	100	)	{	edt_Impairment_Rating_Left_Upper.text =	"60";	}









        double a = edt_Impairment_Rating_Left_Upper.text.toString() == "" ? 0.00 : double.parse(edt_Impairment_Rating_Left_Upper.text.toString());

        double avgweek = edt_avg_weekly_wage.text.toString() == ""
            ? 0.00
            : double.parse(edt_avg_weekly_wage.text);
        double max_aww = edt_MAX_AWW.text.toString() == ""
            ? 0.00
            : double.parse(edt_MAX_AWW.text);
        double compRate = edt_COMP_RATE.text.toString() == ""
            ? 0.00
            : double.parse(edt_COMP_RATE.text);
        if(avgweek > max_aww){
          TTDRate = compRate;
        }
        else
        {
          TTDRate = (avgweek * 2)/3;
        }
        double resultb1 =  TTDRate * 400 * AgeFactorForInjury;
        double resultb = (resultb1 * a) / 100;
        edt_Value_of_the_Rating_Left_Upper.text = resultb.toStringAsFixed(2);


        LessMore3 =0.00;
        LessMore3 = leftUppervalue - resultb ;
        ISErrorleftUppervalue = true;
      }
      else{
        print("dfdfeer" + edt_left_upper_extremity_rating.text.toString());


        leftupperExtremlyRatecalculation(edt_left_upper_extremity_rating.text);
        ISErrorleftUppervalue = false;

      }
    }



  }

  void RightUpperExtremlyCovertFormula(bool value) {
    print("sd00dff" + value.toString());

    if(edt_right_upper_extremity_rating.text.isNotEmpty)
    {
      if(value==true)
      {

        double TTDRate=0.00;
        // double a = edt_Impairment_Rating_Right_Lower.text.toString() == "" ? 0.00 : double.parse(edt_Impairment_Rating_Right_Lower.text.toString());

        double test = edt_right_upper_extremity_rating.text.toString() == "" ? 0.00 : double.parse(edt_right_upper_extremity_rating.text.toString());

        int test1 = test.toInt();
        if(test1==	0	)	{	edt_Impairment_Rating_Right_Upper.text=	"0";	}
        if(test1==	1	)	{edt_Impairment_Rating_Right_Upper.text =	"1";	}
        if(test1==	2	)	{edt_Impairment_Rating_Right_Upper.text =	"1";	}
        if(test1==	3	)	{edt_Impairment_Rating_Right_Upper.text =	"2";	}
        if(test1==	4	)	{edt_Impairment_Rating_Right_Upper.text =	"2";	}
        if(test1==	5	)	{edt_Impairment_Rating_Right_Upper.text =	"3";	}
        if(test1==	6	)	{edt_Impairment_Rating_Right_Upper.text =	"4";	}
        if(test1==	7	)	{edt_Impairment_Rating_Right_Upper.text =	"4";	}
        if(test1==	8	)	{edt_Impairment_Rating_Right_Upper.text =	"5";	}
        if(test1==	9	)	{edt_Impairment_Rating_Right_Upper.text =	"5";	}
        if(test1==	10	)	{	edt_Impairment_Rating_Right_Upper.text =	"6";	}
        if(test1==	11	)	{	edt_Impairment_Rating_Right_Upper.text =	"7";	}
        if(test1==	12	)	{	edt_Impairment_Rating_Right_Upper.text =	"7";	}
        if(test1==	13	)	{	edt_Impairment_Rating_Right_Upper.text =	"8";	}
        if(test1==	14	)	{	edt_Impairment_Rating_Right_Upper.text =	"8";	}
        if(test1==	15	)	{	edt_Impairment_Rating_Right_Upper.text =	"9";	}
        if(test1==	16	)	{	edt_Impairment_Rating_Right_Upper.text =	"10";	}
        if(test1==	17	)	{	edt_Impairment_Rating_Right_Upper.text =	"10";	}
        if(test1==	18	)	{	edt_Impairment_Rating_Right_Upper.text =	"11";	}
        if(test1==	19	)	{	edt_Impairment_Rating_Right_Upper.text =	"11";	}
        if(test1==	20	)	{	edt_Impairment_Rating_Right_Upper.text =	"12";	}
        if(test1==	21	)	{	edt_Impairment_Rating_Right_Upper.text =	"13";	}
        if(test1==	22	)	{	edt_Impairment_Rating_Right_Upper.text =	"13";	}
        if(test1==	23	)	{	edt_Impairment_Rating_Right_Upper.text =	"14";	}
        if(test1==	24	)	{	edt_Impairment_Rating_Right_Upper.text =	"14";	}
        if(test1==	25	)	{	edt_Impairment_Rating_Right_Upper.text =	"15";	}
        if(test1==	26	)	{	edt_Impairment_Rating_Right_Upper.text =	"16";	}
        if(test1==	27	)	{	edt_Impairment_Rating_Right_Upper.text =	"16";	}
        if(test1==	28	)	{	edt_Impairment_Rating_Right_Upper.text =	"17";	}
        if(test1==	29	)	{	edt_Impairment_Rating_Right_Upper.text =	"17";	}
        if(test1==	30	)	{	edt_Impairment_Rating_Right_Upper.text =	"18";	}
        if(test1==	31	)	{	edt_Impairment_Rating_Right_Upper.text =	"19";	}
        if(test1==	32	)	{	edt_Impairment_Rating_Right_Upper.text =	"19";	}
        if(test1==	33	)	{	edt_Impairment_Rating_Right_Upper.text =	"20";	}
        if(test1==	34	)	{	edt_Impairment_Rating_Right_Upper.text =	"20";	}
        if(test1==	35	)	{	edt_Impairment_Rating_Right_Upper.text =	"21";	}
        if(test1==	36	)	{	edt_Impairment_Rating_Right_Upper.text =	"22";	}
        if(test1==	37	)	{	edt_Impairment_Rating_Right_Upper.text =	"22";	}
        if(test1==	38	)	{	edt_Impairment_Rating_Right_Upper.text =	"23";	}
        if(test1==	39	)	{	edt_Impairment_Rating_Right_Upper.text =	"23";	}
        if(test1==	40	)	{	edt_Impairment_Rating_Right_Upper.text =	"24";	}
        if(test1==	41	)	{	edt_Impairment_Rating_Right_Upper.text =	"25";	}
        if(test1==	42	)	{	edt_Impairment_Rating_Right_Upper.text =	"25";	}
        if(test1==	43	)	{	edt_Impairment_Rating_Right_Upper.text =	"26";	}
        if(test1==	44	)	{	edt_Impairment_Rating_Right_Upper.text =	"26";	}
        if(test1==	45	)	{	edt_Impairment_Rating_Right_Upper.text =	"27";	}
        if(test1==	46	)	{	edt_Impairment_Rating_Right_Upper.text =	"28";	}
        if(test1==	47	)	{	edt_Impairment_Rating_Right_Upper.text =	"28";	}
        if(test1==	48	)	{	edt_Impairment_Rating_Right_Upper.text =	"29";	}
        if(test1==	49	)	{	edt_Impairment_Rating_Right_Upper.text =	"29";	}
        if(test1==	50	)	{	edt_Impairment_Rating_Right_Upper.text =	"30";	}
        if(test1==	51	)	{	edt_Impairment_Rating_Right_Upper.text =	"31";	}
        if(test1==	52	)	{	edt_Impairment_Rating_Right_Upper.text =	"31";	}
        if(test1==	53	)	{	edt_Impairment_Rating_Right_Upper.text =	"32";	}
        if(test1==	54	)	{	edt_Impairment_Rating_Right_Upper.text =	"32";	}
        if(test1==	55	)	{	edt_Impairment_Rating_Right_Upper.text =	"33";	}
        if(test1==	56	)	{	edt_Impairment_Rating_Right_Upper.text =	"34";	}
        if(test1==	57	)	{	edt_Impairment_Rating_Right_Upper.text =	"34";	}
        if(test1==	58	)	{	edt_Impairment_Rating_Right_Upper.text =	"35";	}
        if(test1==	59	)	{	edt_Impairment_Rating_Right_Upper.text =	"35";	}
        if(test1==	60	)	{	edt_Impairment_Rating_Right_Upper.text =	"36";	}
        if(test1==	61	)	{	edt_Impairment_Rating_Right_Upper.text =	"37";	}
        if(test1==	62	)	{	edt_Impairment_Rating_Right_Upper.text =	"37";	}
        if(test1==	63	)	{	edt_Impairment_Rating_Right_Upper.text =	"38";	}
        if(test1==	64	)	{	edt_Impairment_Rating_Right_Upper.text =	"38";	}
        if(test1==	65	)	{	edt_Impairment_Rating_Right_Upper.text =	"39";	}
        if(test1==	66	)	{	edt_Impairment_Rating_Right_Upper.text =	"40";	}
        if(test1==	67	)	{	edt_Impairment_Rating_Right_Upper.text =	"40";	}
        if(test1==	68	)	{	edt_Impairment_Rating_Right_Upper.text =	"41";	}
        if(test1==	69	)	{	edt_Impairment_Rating_Right_Upper.text =	"41";	}
        if(test1==	70	)	{	edt_Impairment_Rating_Right_Upper.text =	"42";	}
        if(test1==	71	)	{	edt_Impairment_Rating_Right_Upper.text =	"43";	}
        if(test1==	72	)	{	edt_Impairment_Rating_Right_Upper.text =	"43";	}
        if(test1==	73	)	{	edt_Impairment_Rating_Right_Upper.text =	"44";	}
        if(test1==	74	)	{	edt_Impairment_Rating_Right_Upper.text =	"44";	}
        if(test1==	75	)	{	edt_Impairment_Rating_Right_Upper.text =	"45";	}
        if(test1==	76	)	{	edt_Impairment_Rating_Right_Upper.text =	"46";	}
        if(test1==	77	)	{	edt_Impairment_Rating_Right_Upper.text =	"46";	}
        if(test1==	78	)	{	edt_Impairment_Rating_Right_Upper.text =	"47";	}
        if(test1==	79	)	{	edt_Impairment_Rating_Right_Upper.text =	"47";	}
        if(test1==	80	)	{	edt_Impairment_Rating_Right_Upper.text =	"48";	}
        if(test1==	81	)	{	edt_Impairment_Rating_Right_Upper.text =	"49";	}
        if(test1==	82	)	{	edt_Impairment_Rating_Right_Upper.text =	"49";	}
        if(test1==	83	)	{	edt_Impairment_Rating_Right_Upper.text =	"50";	}
        if(test1==	84	)	{	edt_Impairment_Rating_Right_Upper.text =	"50";	}
        if(test1==	85	)	{	edt_Impairment_Rating_Right_Upper.text =	"51";	}
        if(test1==	86	)	{	edt_Impairment_Rating_Right_Upper.text =	"52";	}
        if(test1==	87	)	{	edt_Impairment_Rating_Right_Upper.text =	"52";	}
        if(test1==	88	)	{	edt_Impairment_Rating_Right_Upper.text =	"53";	}
        if(test1==	89	)	{	edt_Impairment_Rating_Right_Upper.text =	"53";	}
        if(test1==	90	)	{	edt_Impairment_Rating_Right_Upper.text =	"54";	}
        if(test1==	91	)	{	edt_Impairment_Rating_Right_Upper.text =	"55";	}
        if(test1==	92	)	{	edt_Impairment_Rating_Right_Upper.text =	"55";	}
        if(test1==	93	)	{	edt_Impairment_Rating_Right_Upper.text =	"56";	}
        if(test1==	94	)	{	edt_Impairment_Rating_Right_Upper.text =	"56";	}
        if(test1==	95	)	{	edt_Impairment_Rating_Right_Upper.text =	"57";	}
        if(test1==	96	)	{	edt_Impairment_Rating_Right_Upper.text =	"58";	}
        if(test1==	97	)	{	edt_Impairment_Rating_Right_Upper.text =	"58";	}
        if(test1==	98	)	{	edt_Impairment_Rating_Right_Upper.text =	"59";	}
        if(test1==	99	)	{	edt_Impairment_Rating_Right_Upper.text =	"59";	}
        if(test1==	100	)	{	edt_Impairment_Rating_Right_Upper.text =	"60";	}









        double a = edt_Impairment_Rating_Right_Upper.text.toString() == "" ? 0.00 : double.parse(edt_Impairment_Rating_Right_Upper.text.toString());

        double avgweek = edt_avg_weekly_wage.text.toString() == ""
            ? 0.00
            : double.parse(edt_avg_weekly_wage.text);
        double max_aww = edt_MAX_AWW.text.toString() == ""
            ? 0.00
            : double.parse(edt_MAX_AWW.text);
        double compRate = edt_COMP_RATE.text.toString() == ""
            ? 0.00
            : double.parse(edt_COMP_RATE.text);
        if(avgweek > max_aww){
          TTDRate = compRate;
        }
        else
        {
          TTDRate = (avgweek * 2)/3;
        }
        double resultb1 =  TTDRate * 400 * AgeFactorForInjury;
        double resultb = (resultb1 * a) / 100;
        edt_Value_of_the_Rating_Right_Upper.text = resultb.toStringAsFixed(2);


        LessMore4 =0.00;
        LessMore4 = rightUppervalue - resultb ;
        ISErrorrightUppervalue = true;
      }
      else{
        print("dfdfeer" + edt_right_upper_extremity_rating.text.toString());


        rightupperExtremlyRatecalculation(edt_right_upper_extremity_rating.text);
        ISErrorrightUppervalue = false;

      }


    }

  }

}


