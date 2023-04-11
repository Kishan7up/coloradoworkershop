import 'package:app/blocs/other/mainbloc/main_bloc.dart';
import 'package:app/models/api_response/customer/customer_details_api_response.dart';
import 'package:app/models/api_response/recent_view_list/recent_view_list_response.dart';
import 'package:app/models/common/all_name_id_list.dart';
import 'package:app/ui/res/color_resources.dart';
import 'package:app/ui/res/image_resources.dart';
import 'package:app/ui/screens/base/base_screen.dart';
import 'package:app/ui/screens/dashboard/home_screen.dart';
import 'package:app/ui/screens/dashboard/ppd_award_next_screen.dart';
import 'package:app/utils/general_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

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
  final TextEditingController Total_TTD_TPD_benefits_you_have_received =
      TextEditingController();
  final TextEditingController Amount_Remaining_to_Reach_Cap =
      TextEditingController();
  //Amount_Remaining_to_Reach_Cap

  bool IsRightUpperValue = true;
  bool IsRightUpperState = false;

  bool IsLeftUpperValue = true;
  bool IsLeftUpperState = true;

  bool IsRightLowerValue = true;
  bool IsRightLowerState = false;

  bool IsLeftLowerValue = true;
  bool IsLeftLowerState = false;

  @override
  void initState() {
    super.initState();

    _CustomerBloc = MainBloc(baseBloc);

    if (widget.arguments != null) {
      _editModel = widget.arguments.editModel;
    } else {
      String CurrentDate = DateTime.now().day.toString() +
          "/" +
          DateTime.now().month.toString() +
          "/" +
          DateTime.now().year.toString();

      edt_date_of_birth.text = CurrentDate;
      edt_date_of_inquiry.text = CurrentDate;
      edt_date_of_mmi.text = CurrentDate;
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
                                              top: 10,
                                              bottom: 10,
                                              left: 10,
                                              right: 10),
                                          child: Row(
                                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    _showDateOfInquiry(context);
                                                  },
                                                  child: TextFormField(
                                                      controller:
                                                          edt_date_of_inquiry,
                                                      enabled: false,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 10.0),
                                                        // border: UnderlineInputBorder(),
                                                        labelText:
                                                            'Date of Inquiry',
                                                        suffixIcon: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(1.0),
                                                          child: Image.asset(
                                                            CALENDAR,
                                                            width: 12,
                                                            height: 12,
                                                          ),
                                                        ),
                                                      ),
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color:
                                                            Color(0xFF000000),
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
                                                      controller:
                                                          edt_date_of_birth,
                                                      enabled: false,
                                                      decoration:
                                                          InputDecoration(
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top:
                                                                          10.0),
                                                              border:
                                                                  UnderlineInputBorder(),
                                                              labelText:
                                                                  'Date Of Birth',
                                                              suffixIcon:
                                                                  Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        1.0),
                                                                child:
                                                                    Image.asset(
                                                                  CALENDAR,
                                                                  width: 12,
                                                                  height: 12,
                                                                ),
                                                              ),
                                                              hintText:
                                                                  "DD-MM-YYYY"),
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color:
                                                            Color(0xFF000000),
                                                      )),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 20,
                                              bottom: 10,
                                              left: 10,
                                              right: 10),
                                          child: Row(
                                            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    _showDateOfMMI(context);
                                                  },
                                                  child: TextFormField(
                                                      controller:
                                                          edt_date_of_mmi,
                                                      enabled: false,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 10.0),
                                                        // border: UnderlineInputBorder(),
                                                        labelText:
                                                            'Date of MMI',
                                                        suffixIcon: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(1.0),
                                                          child: Image.asset(
                                                            CALENDAR,
                                                            width: 12,
                                                            height: 12,
                                                          ),
                                                        ),
                                                      ),
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        color:
                                                            Color(0xFF000000),
                                                      )),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Expanded(
                                                child: TextFormField(
                                                    keyboardType: TextInputType
                                                        .numberWithOptions(
                                                            decimal: true),
                                                    controller:
                                                        edt_avg_weekly_wage,
                                                    decoration: InputDecoration(
                                                        border:
                                                            UnderlineInputBorder(),
                                                        labelText:
                                                            'Avg.Weekly Wage',
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
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
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
                                              controller: edt_total_ttd_tpd,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: InputDecoration(
                                                  suffixIcon: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0,
                                                            bottom: 10.0),
                                                    child: Text(
                                                      "\$",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  border:
                                                      UnderlineInputBorder(),
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
                        ),

                        /// ENTER EMPREMENTS
                        Container(
                          margin: EdgeInsets.only(
                              left: 10, right: 10, bottom: 10, top: 5),
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
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
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
                                                  edt_whole_person_impliment_rating,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: InputDecoration(
                                                  suffixIcon: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0,
                                                            bottom: 10.0),
                                                    child: Text(
                                                      "\%",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  border:
                                                      UnderlineInputBorder(),
                                                  labelText:
                                                      'Whole person impairment rating',
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
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
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
                                                  edt_right_upper_extremity_rating,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: InputDecoration(
                                                  suffixIcon: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0,
                                                            bottom: 10.0),
                                                    child: Text(
                                                      "\%",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  border:
                                                      UnderlineInputBorder(),
                                                  labelText:
                                                      'Right upper extremity rating',
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
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
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
                                                  edt_left_upper_extremity_rating,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: InputDecoration(
                                                  suffixIcon: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0,
                                                            bottom: 10.0),
                                                    child: Text(
                                                      "\%",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  border:
                                                      UnderlineInputBorder(),
                                                  labelText:
                                                      'Left upper extremity rating',
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
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
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
                                                  edt_right_lower_extremity_rating,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: InputDecoration(
                                                  suffixIcon: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0,
                                                            bottom: 10.0),
                                                    child: Text(
                                                      "\%",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  border:
                                                      UnderlineInputBorder(),
                                                  labelText:
                                                      'Right lower extremity rating',
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
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                      decimal: true),
                                              controller:
                                                  edt_left_lower_extremity_rating,
                                              textInputAction:
                                                  TextInputAction.done,
                                              decoration: InputDecoration(
                                                  suffixIcon: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0,
                                                            bottom: 10.0),
                                                    child: Text(
                                                      "\%",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                  border:
                                                      UnderlineInputBorder(),
                                                  labelText:
                                                      'Left lower extremity rating',
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

                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
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
                              Container(
                                margin: EdgeInsets.all(10),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.white70, width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Container(
                                    //margin: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          margin: EdgeInsets.only(
                                              top: 5, bottom: 10),
                                          height: 3,
                                          color: colorLightGray,
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    bottom: 10,
                                                    left: 10,
                                                    right: 10),
                                                child: Row(
                                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
                                                          controller:
                                                              edt_Whole_Person_Rating,
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10.0),
                                                            // border: UnderlineInputBorder(),
                                                            labelText:
                                                                'Whole Person Rating',
                                                          ),
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: Color(
                                                                0xFF000000),
                                                          )),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Expanded(
                                                      child: TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .numberWithOptions(
                                                                      decimal:
                                                                          true),
                                                          controller:
                                                              edt_Value_of_the_Rating,
                                                          decoration: InputDecoration(
                                                              border:
                                                                  UnderlineInputBorder(),
                                                              labelText:
                                                                  'Value of the Rating',
                                                              hintText: "0.00"),
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: Color(
                                                                0xFF000000),
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
                                    side: BorderSide(
                                        color: Colors.white70, width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Container(
                                    //margin: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          child: Text(
                                              "Right Upper Extremity (Scheduled)",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 5, bottom: 10),
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
                                                      setState(
                                                        () {},
                                                      );
                                                    },
                                                    thumbColor:
                                                        CupertinoColors.white,
                                                    activeColor: CupertinoColors
                                                        .destructiveRed,
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
                                                    bottom: 10,
                                                    left: 10,
                                                    right: 10),
                                                child: Row(
                                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
                                                          controller:
                                                              edt_Impairment_Rating_Right_Upper,
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10.0),
                                                            // border: UnderlineInputBorder(),
                                                            labelText:
                                                                'Impairment Rating',
                                                          ),
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: Color(
                                                                0xFF000000),
                                                          )),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Expanded(
                                                      child: TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .numberWithOptions(
                                                                      decimal:
                                                                          true),
                                                          controller:
                                                              edt_Value_of_the_Rating_Right_Upper,
                                                          decoration: InputDecoration(
                                                              border:
                                                                  UnderlineInputBorder(),
                                                              labelText:
                                                                  'Value of the Rating',
                                                              hintText: "0.00"),
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: Color(
                                                                0xFF000000),
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
                                    side: BorderSide(
                                        color: Colors.white70, width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Container(
                                    //margin: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          child: Text(
                                              "Left Upper Extremity (Scheduled)",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 5, bottom: 10),
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
                                                      setState(
                                                        () {},
                                                      );
                                                    },
                                                    thumbColor:
                                                        CupertinoColors.white,
                                                    activeColor: CupertinoColors
                                                        .destructiveRed,
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
                                                    bottom: 10,
                                                    left: 10,
                                                    right: 10),
                                                child: Row(
                                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
                                                          controller:
                                                              edt_Impairment_Rating_Left_Upper,
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10.0),
                                                            // border: UnderlineInputBorder(),
                                                            labelText:
                                                                'Impairment Rating',
                                                          ),
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: Color(
                                                                0xFF000000),
                                                          )),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Expanded(
                                                      child: TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .numberWithOptions(
                                                                      decimal:
                                                                          true),
                                                          controller:
                                                              edt_Value_of_the_Rating_Left_Upper,
                                                          decoration: InputDecoration(
                                                              border:
                                                                  UnderlineInputBorder(),
                                                              labelText:
                                                                  'Value of the Rating',
                                                              hintText: "0.00"),
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: Color(
                                                                0xFF000000),
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
                                    side: BorderSide(
                                        color: Colors.white70, width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Container(
                                    //margin: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          child: Text(
                                              "Right Lower Extremity (Scheduled)",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 5, bottom: 10),
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
                                                      setState(
                                                        () {},
                                                      );
                                                    },
                                                    thumbColor:
                                                        CupertinoColors.white,
                                                    activeColor: CupertinoColors
                                                        .destructiveRed,
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
                                                    bottom: 10,
                                                    left: 10,
                                                    right: 10),
                                                child: Row(
                                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
                                                          controller:
                                                              edt_Impairment_Rating_Right_Lower,
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10.0),
                                                            // border: UnderlineInputBorder(),
                                                            labelText:
                                                                'Impairment Rating',
                                                          ),
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: Color(
                                                                0xFF000000),
                                                          )),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Expanded(
                                                      child: TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .numberWithOptions(
                                                                      decimal:
                                                                          true),
                                                          controller:
                                                              edt_Value_of_the_Rating_Right_Lower,
                                                          decoration: InputDecoration(
                                                              border:
                                                                  UnderlineInputBorder(),
                                                              labelText:
                                                                  'Value of the Rating',
                                                              hintText: "0.00"),
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: Color(
                                                                0xFF000000),
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
                                    side: BorderSide(
                                        color: Colors.white70, width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Container(
                                    //margin: EdgeInsets.all(10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Container(
                                          margin: EdgeInsets.all(10),
                                          child: Text(
                                              "Left Lower Extremity (Scheduled)",
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: 5, bottom: 10),
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
                                                      setState(
                                                        () {},
                                                      );
                                                    },
                                                    thumbColor:
                                                        CupertinoColors.white,
                                                    activeColor: CupertinoColors
                                                        .destructiveRed,
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
                                                    bottom: 10,
                                                    left: 10,
                                                    right: 10),
                                                child: Row(
                                                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
                                                          controller:
                                                              edt_Impairment_Rating_Left_Lower,
                                                          decoration:
                                                              InputDecoration(
                                                            contentPadding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 10.0),
                                                            // border: UnderlineInputBorder(),
                                                            labelText:
                                                                'Impairment Rating',
                                                          ),
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: Color(
                                                                0xFF000000),
                                                          )),
                                                    ),
                                                    SizedBox(
                                                      width: 20,
                                                    ),
                                                    Expanded(
                                                      child: TextFormField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .numberWithOptions(
                                                                      decimal:
                                                                          true),
                                                          controller:
                                                              edt_Value_of_the_Rating_Left_Lower,
                                                          decoration: InputDecoration(
                                                              border:
                                                                  UnderlineInputBorder(),
                                                              labelText:
                                                                  'Value of the Rating',
                                                              hintText: "0.00"),
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: Color(
                                                                0xFF000000),
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

                              /// ENTER EMPREMENTS
                              Container(
                                margin: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 10, top: 5),
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.white70, width: 1),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                    keyboardType: TextInputType
                                                        .numberWithOptions(
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
                                                        edt_Total_Scheduled_Rate,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    decoration: InputDecoration(
                                                        border:
                                                            UnderlineInputBorder(),
                                                        labelText:
                                                            'Total Scheduled Rate',
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
                                                    keyboardType: TextInputType
                                                        .numberWithOptions(
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
                                                        edt_Combined_Whole_Person_Rate,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    decoration: InputDecoration(
                                                        border:
                                                            UnderlineInputBorder(),
                                                        labelText:
                                                            'Combined Whole Person Rate',
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
                                                    keyboardType: TextInputType
                                                        .numberWithOptions(
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
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    decoration: InputDecoration(
                                                        border:
                                                            UnderlineInputBorder(),
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
                                                    keyboardType: TextInputType
                                                        .numberWithOptions(
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
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    decoration: InputDecoration(
                                                        border:
                                                            UnderlineInputBorder(),
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
                                                    keyboardType: TextInputType
                                                        .numberWithOptions(
                                                            decimal: true),
                                                    controller:
                                                        edt_Benefits_Cap,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    decoration: InputDecoration(
                                                        border:
                                                            UnderlineInputBorder(),
                                                        labelText:
                                                            'Benefits Cap',
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
                                                    keyboardType: TextInputType
                                                        .numberWithOptions(
                                                            decimal: true),
                                                    controller:
                                                        Total_TTD_TPD_benefits_you_have_received,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    decoration: InputDecoration(
                                                        border:
                                                            UnderlineInputBorder(),
                                                        labelText:
                                                            'Total TTD/TPD benefits you have received',
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
                                                    keyboardType: TextInputType
                                                        .numberWithOptions(
                                                            decimal: true),
                                                    controller:
                                                        Amount_Remaining_to_Reach_Cap,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    decoration: InputDecoration(
                                                        border:
                                                            UnderlineInputBorder(),
                                                        labelText:
                                                            'Amount Remaining to Reach Cap',
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
                                        navigateTo(context,
                                            PpdAwardNextScreen.routeName);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        child: Card(
                                            elevation: 10,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Container(
                                              width: 100,
                                              height: 35,
                                              margin: EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  top: 10,
                                                  bottom: 10),
                                              child: Center(
                                                child: Text("Back",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ),
                                            )),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        navigateTo(context,
                                            PpdAwardNextScreen.routeName);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.all(10),
                                        child: Card(
                                            elevation: 10,
                                            color: APPButtonRed,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: Container(
                                              width: 100,
                                              height: 35,
                                              margin: EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  top: 10,
                                                  bottom: 10),
                                              child: Center(
                                                child: Text("Reset",
                                                    style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold)),
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
                    Container(
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      child: Text(
                        "Settlement Partners",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            letterSpacing: 2),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      child: Row(
                        children: [
                          Image.asset(CALL_ICON),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "303.691.9090s",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 10),
                      child: Row(
                        children: [
                          Image.asset(MESSAGE_ICON),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "mdavis@settlementpartners.com",
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
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

  void _showDateOfBirth(ctx) {
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
                            edt_date_of_birth.text = val.day.toString() +
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

  void _showDateOfMMI(ctx) {
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
                            edt_date_of_mmi.text = val.day.toString() +
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
}
