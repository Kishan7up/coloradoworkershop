import 'package:app/blocs/other/mainbloc/main_bloc.dart';
import 'package:app/models/api_response/customer/customer_details_api_response.dart';
import 'package:app/models/api_response/recent_view_list/recent_view_list_response.dart';
import 'package:app/models/common/all_name_id_list.dart';
import 'package:app/ui/res/color_resources.dart';
import 'package:app/ui/res/image_resources.dart';
import 'package:app/ui/screens/base/base_screen.dart';
import 'package:app/ui/screens/dashboard/home_screen.dart';
import 'package:app/ui/screens/dashboard/maximum_benifits.dart';
import 'package:app/utils/general_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

//import 'package:whatsapp_share/whatsapp_share.dart';

class CalculateNetPresentValueArguments {
  String editModel;

  CalculateNetPresentValueArguments(this.editModel);
}

class CalculateNetPresentValue extends BaseStatefulWidget {
  static const routeName = '/CalculateNetPresentValue';

  final CalculateNetPresentValueArguments arguments;

  CalculateNetPresentValue(this.arguments);

  @override
  _CalculateNetPresentValueState createState() =>
      _CalculateNetPresentValueState();
}

class _CalculateNetPresentValueState extends BaseState<CalculateNetPresentValue>
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

  final TextEditingController edt_PPD_benefits_already_paid =
      TextEditingController();
  final TextEditingController edt_TTD_rate = TextEditingController();
  final TextEditingController edt_SSDI_Monthly = TextEditingController();
  final TextEditingController edt_PPD_weekly_benefit = TextEditingController();
  final TextEditingController edt_Discount_rate = TextEditingController();
  final TextEditingController Age_or_rated_age_at_MMI = TextEditingController();
  final TextEditingController Life_expectancy = TextEditingController();
  final TextEditingController
      edt_Net_present_value_before_PPD_benefits_already_paid =
      TextEditingController();
  final TextEditingController
      Net_present_value_after_PPD_benefits_already_paid =
      TextEditingController();

  //
  bool IS_TTD = false;

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
        backgroundColor: Color(0xfff5f5f5),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderPart(),
              Container(
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: Image.asset(NET_PRESENT_LABEL)),
              Container(
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                child: Text(
                  "For a free accurate quote reflecting the injured worker's and the market's unique circumstances please contact:",
                  style: TextStyle(fontSize: 14, color: colorBlack),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 20,
                        ),
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
                                                  edt_PPD_benefits_already_paid,
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
                                                      'PPD benefits already paid',
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
                                              controller: edt_TTD_rate,
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
                                                  labelText: 'TTD rate',
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
                                              controller: edt_SSDI_Monthly,
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
                                                  labelText: 'SSDI (Monthly)',
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
                                                  edt_PPD_weekly_benefit,
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
                                                      'PPD weekly benefit',
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
                                              controller: edt_Discount_rate,
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
                                                  labelText: 'Discount rate',
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
                                                  Age_or_rated_age_at_MMI,
                                              textInputAction:
                                                  TextInputAction.done,
                                              decoration: InputDecoration(
                                                  border:
                                                      UnderlineInputBorder(),
                                                  labelText:
                                                      'Age or rated age at MMI',
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
                                              controller: Life_expectancy,
                                              textInputAction:
                                                  TextInputAction.done,
                                              decoration: InputDecoration(
                                                  border:
                                                      UnderlineInputBorder(),
                                                  labelText: 'Life expectancy',
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
                                                  edt_Net_present_value_before_PPD_benefits_already_paid,
                                              textInputAction:
                                                  TextInputAction.done,
                                              decoration: InputDecoration(
                                                  border:
                                                      UnderlineInputBorder(),
                                                  labelText:
                                                      'Net present value before PPD benefits already paid',
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
                                                  Net_present_value_after_PPD_benefits_already_paid,
                                              textInputAction:
                                                  TextInputAction.done,
                                              decoration: InputDecoration(
                                                  border:
                                                      UnderlineInputBorder(),
                                                  labelText:
                                                      'Net present value after PPD benefits already paid',
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
                        InkWell(
                          onTap: () {
                            navigateTo(
                                context, MaximumBenefitsScreen.routeName);
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
                                        left: 20,
                                        right: 20,
                                        top: 10,
                                        bottom: 10),
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
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Container(
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 10),
                            child: Text(
                              "While the calculation closely replicate the DOWC website, please contact Settlement Partners to obtain a free quote that reflacts the worker's and the market's unique circumstances.",
                              style: TextStyle(fontSize: 14, color: colorBlack),
                            )),
                        Container(
                          margin: EdgeInsets.all(10),
                          height: 3,
                          color: colorLightGray,
                        ),
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
                        )
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
                            "Net Present Value",
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
                          "While the calculation closely replicate the DOWC website, please contact Settlement Partners to obtain a free quote that reflacts the worker's and the market's unique circumstances.",
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
