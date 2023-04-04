import 'package:app/blocs/other/mainbloc/main_bloc.dart';
import 'package:app/models/api_response/customer/customer_details_api_response.dart';
import 'package:app/models/api_response/recent_view_list/recent_view_list_response.dart';
import 'package:app/models/common/all_name_id_list.dart';
import 'package:app/ui/res/color_resources.dart';
import 'package:app/ui/res/image_resources.dart';
import 'package:app/ui/screens/base/base_screen.dart';
import 'package:app/ui/screens/dashboard/calculate_net_present_value.dart';
import 'package:app/ui/screens/dashboard/home_screen.dart';
import 'package:app/utils/general_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

//import 'package:whatsapp_share/whatsapp_share.dart';

class MaximumBenefitsScreenArguments {
  String editModel;

  MaximumBenefitsScreenArguments(this.editModel);
}

class MaximumBenefitsScreen extends BaseStatefulWidget {
  static const routeName = '/MaximumBenefitsScreen';

  final MaximumBenefitsScreenArguments arguments;

  MaximumBenefitsScreen(this.arguments);

  @override
  _MaximumBenefitsScreenState createState() => _MaximumBenefitsScreenState();
}

class _MaximumBenefitsScreenState extends BaseState<MaximumBenefitsScreen>
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
  final TextEditingController edt_PPD_Weekly_Rate = TextEditingController();
  final TextEditingController edt_TTD_Weekly_Rate = TextEditingController();
  final TextEditingController edt_Scheduled_Impairment_Weekly_Rate =
      TextEditingController();

  final TextEditingController edt_W_O_Extensive_Scar_or_Stumps =
      TextEditingController();
  final TextEditingController edt_W_Extensive_Scars_Stumps_or_Burns =
      TextEditingController();
  final TextEditingController edt_Whole_Person_Impairment_Less =
      TextEditingController();
  final TextEditingController Whole_Person_Impairment_More_than =
      TextEditingController();
  final TextEditingController edt_left_lower_extremity_rating =
      TextEditingController();
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
                                                      textAlign: TextAlign.left,
                                                      controller:
                                                          edt_date_of_inquiry,
                                                      enabled: false,
                                                      decoration:
                                                          InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 10.0),
                                                        border:
                                                            UnderlineInputBorder(),
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
                                                  child: TextFormField(
                                                      controller:
                                                          edt_Ave_Weekly_Wage,
                                                      keyboardType: TextInputType
                                                          .numberWithOptions(
                                                              decimal: true),
                                                      decoration: InputDecoration(
                                                          border:
                                                              UnderlineInputBorder(),
                                                          labelText:
                                                              'Ave. Weekly Wage',
                                                          labelStyle: TextStyle(
                                                              overflow:
                                                                  TextOverflow
                                                                      .clip),
                                                          hintText: "0.00"),
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
                                                child: TextFormField(
                                                    controller:
                                                        edt_PPD_Weekly_Rate,
                                                    decoration: InputDecoration(
                                                      // border: UnderlineInputBorder(),
                                                      labelText:
                                                          'PPD Weekly Rate',
                                                      labelStyle: TextStyle(
                                                          overflow: TextOverflow
                                                              .clip),
                                                    ),
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
                                                    keyboardType: TextInputType
                                                        .numberWithOptions(
                                                            decimal: true),
                                                    controller:
                                                        edt_TTD_Weekly_Rate,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    decoration: InputDecoration(
                                                        border:
                                                            UnderlineInputBorder(),
                                                        labelText:
                                                            'TTD Weekly Rate',
                                                        labelStyle: TextStyle(
                                                            overflow:
                                                                TextOverflow
                                                                    .clip),
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
                                              controller:
                                                  edt_Scheduled_Impairment_Weekly_Rate,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: InputDecoration(
                                                  border:
                                                      UnderlineInputBorder(),
                                                  labelText:
                                                      'Scheduled Impairment Weekly Rate',
                                                  labelStyle: TextStyle(
                                                      overflow:
                                                          TextOverflow.clip),
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

                        /// DISFIGUREMENT Maximum
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
                                    child: Text("Disfigurement Maximums",
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
                                    margin: EdgeInsets.only(
                                        top: 20,
                                        bottom: 20,
                                        left: 20,
                                        right: 20),
                                    child: Column(
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextFormField(
                                            controller:
                                                edt_W_O_Extensive_Scar_or_Stumps,
                                            decoration: InputDecoration(
                                              // border: UnderlineInputBorder(),
                                              labelText:
                                                  'W/O Extensive Scar or Stumps',
                                              labelStyle: TextStyle(
                                                  overflow: TextOverflow.clip),
                                            ),
                                            style: TextStyle(
                                              fontSize: 15,
                                            )),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                            maxLines: null,
                                            keyboardType:
                                                TextInputType.multiline,
                                            /*keyboardType: TextInputType
                                                .numberWithOptions(
                                                    decimal: true),*/
                                            controller:
                                                edt_W_Extensive_Scars_Stumps_or_Burns,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: InputDecoration(
                                                border: UnderlineInputBorder(),
                                                labelText:
                                                    'W Extensive Scars, Stumps, or Burns',
                                                labelStyle: TextStyle(
                                                    overflow:
                                                        TextOverflow.clip),
                                                hintText: "0.00"),
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xFF000000),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        /// Benefit Caps
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
                                    child: Text("Benefit Caps",
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
                                    margin: EdgeInsets.only(
                                        top: 20,
                                        bottom: 20,
                                        left: 20,
                                        right: 20),
                                    child: Column(
                                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextFormField(
                                            controller:
                                                edt_Whole_Person_Impairment_Less,
                                            decoration: InputDecoration(
                                              // border: UnderlineInputBorder(),
                                              labelText:
                                                  'Whole Person Impairment, 25% or Less',
                                              labelStyle: TextStyle(
                                                  overflow: TextOverflow.clip),
                                            ),
                                            style: TextStyle(
                                              fontSize: 15,
                                            )),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        TextFormField(
                                            maxLines: null,
                                            keyboardType:
                                                TextInputType.multiline,
                                            /*keyboardType: TextInputType
                                                .numberWithOptions(
                                                    decimal: true),*/
                                            controller:
                                                Whole_Person_Impairment_More_than,
                                            textInputAction:
                                                TextInputAction.next,
                                            decoration: InputDecoration(
                                                border: UnderlineInputBorder(),
                                                labelText:
                                                    'Whole Person Impairment, More than 25%',
                                                labelStyle: TextStyle(
                                                    overflow:
                                                        TextOverflow.clip),
                                                hintText: "0.00"),
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Color(0xFF000000),
                                            )),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        InkWell(
                          onTap: () {
                            navigateTo(
                                context, CalculateNetPresentValue.routeName);
                          },
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: InkWell(
                              onTap: () {
                                _launchURL(
                                    "https://www.lipsum.com/privacy.pdf");
                                //
                              },
                              child: Text(
                                "Privacy Policy",
                                style: TextStyle(
                                    color: Colors.red,
                                    decoration: TextDecoration.underline),
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
                            "Max Benefit Rates",
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
}
