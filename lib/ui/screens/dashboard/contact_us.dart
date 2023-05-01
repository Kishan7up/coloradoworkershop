import 'package:app/blocs/other/mainbloc/main_bloc.dart';
import 'package:app/models/api_request/contact_us/contact_us_request.dart';
import 'package:app/models/api_response/customer/customer_details_api_response.dart';
import 'package:app/models/api_response/recent_view_list/recent_view_list_response.dart';
import 'package:app/models/common/all_name_id_list.dart';
import 'package:app/ui/res/color_resources.dart';
import 'package:app/ui/screens/base/base_screen.dart';
import 'package:app/ui/screens/dashboard/home_screen.dart';
import 'package:app/utils/general_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsArguments {
  String editModel;

  ContactUsArguments(this.editModel);
}

class ContactUsScreen extends BaseStatefulWidget {
  static const routeName = '/ContactUsScreen';

  final ContactUsArguments arguments;

  ContactUsScreen(this.arguments);

  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends BaseState<ContactUsScreen>
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
          if (state is ContactUsResponseState) {
            getContactUsResponse(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is ContactUsResponseState) {
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
                                        left: 10,
                                        top: 20,
                                        bottom: 10,
                                        right: 10),
                                    child: Text("Let’s Connect!",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold)),
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
                                      children: [
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
                                                    controller: edt_FirstName,
                                                    decoration: InputDecoration(
                                                      // border: UnderlineInputBorder(),
                                                      labelText: 'First Name',
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
                                                    keyboardType:
                                                        TextInputType.text,
                                                    controller: edt_LastName,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    decoration: InputDecoration(
                                                        border:
                                                            UnderlineInputBorder(),
                                                        labelText: 'Last Name',
                                                        labelStyle: TextStyle(
                                                            overflow:
                                                                TextOverflow
                                                                    .clip),
                                                        hintText: "Enter Name"),
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
                                                  TextInputType.emailAddress,
                                              controller: edt_EmailAddress,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: InputDecoration(
                                                  border:
                                                      UnderlineInputBorder(),
                                                  labelText: 'Email Address',
                                                  labelStyle: TextStyle(
                                                      overflow:
                                                          TextOverflow.clip),
                                                  hintText: "Enter Email"),
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
                                              maxLength: 14,
                                              keyboardType: TextInputType.phone,
                                              controller: edt_PhoneNumber,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: InputDecoration(
                                                  border:
                                                      UnderlineInputBorder(),
                                                  labelText: 'Phone Number',
                                                  labelStyle: TextStyle(
                                                      overflow:
                                                          TextOverflow.clip),
                                                  hintText: "Enter Number"),
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
                                                  TextInputType.multiline,
                                              controller: edt_Message,
                                              textInputAction:
                                                  TextInputAction.next,
                                              decoration: InputDecoration(
                                                  border:
                                                      UnderlineInputBorder(),
                                                  labelText: 'Message',
                                                  labelStyle: TextStyle(
                                                      overflow:
                                                          TextOverflow.clip),
                                                  hintText: "Enter Details"),
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
                        InkWell(
                          onTap: () {
                            if (edt_FirstName.text != "") {
                              if (edt_LastName.text != "") {
                                if (edt_EmailAddress.text != "") {
                                  if (edt_EmailAddress.text != "") {
                                    if (edt_Message.text != "") {
                                      _CustomerBloc.add(ContactUsRequestEvent(
                                          ContactUsRequest(
                                              firstName: edt_FirstName.text,
                                              lastName: edt_LastName.text,
                                              email: edt_EmailAddress.text,
                                              message: edt_Message.text,
                                              phoneNumber:
                                                  edt_PhoneNumber.text)));
                                      // _showModalSheet();
                                    } else {
                                      showCommonDialogWithSingleOption(
                                          context, "Message is required!",
                                          positiveButtonTitle: "OK");
                                    }
                                  } else {
                                    showCommonDialogWithSingleOption(
                                        context, "Phone Number is required!",
                                        positiveButtonTitle: "OK");
                                  }
                                } else {
                                  showCommonDialogWithSingleOption(
                                      context, "Email is required!",
                                      positiveButtonTitle: "OK");
                                }
                              } else {
                                showCommonDialogWithSingleOption(
                                    context, "Last Name is required!",
                                    positiveButtonTitle: "OK");
                              }
                            } else {
                              showCommonDialogWithSingleOption(
                                  context, "First Name is required!",
                                  positiveButtonTitle: "OK");
                            }
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
                                    child: Text("Submit",
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
                            "Contact Us",
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
                        navigateTo(context, HomeScreen.routeName);
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

  void getContactUsResponse(ContactUsResponseState state) {
    _showModalSheet(state.contactUsResponse.message);
  }
}
