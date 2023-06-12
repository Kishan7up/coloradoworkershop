import 'package:app/blocs/other/mainbloc/main_bloc.dart';
import 'package:app/models/DB_Models/recent_view_list_db_tabel.dart';
import 'package:app/models/api_request/view_recent_cases/view_recent_cases_request.dart';
import 'package:app/models/api_response/recent_view_list/recent_view_list_response.dart';
import 'package:app/models/common/all_name_id_list.dart';
import 'package:app/ui/res/color_resources.dart';
import 'package:app/ui/res/dimen_resources.dart';
import 'package:app/ui/res/image_resources.dart';
import 'package:app/ui/screens/base/base_screen.dart';
import 'package:app/ui/screens/dashboard/home_screen.dart';
import 'package:app/ui/screens/dashboard/recent_cases_details_screen.dart';
import 'package:app/ui/widgets/common_widgets.dart';
import 'package:app/utils/date_time_extensions.dart';
import 'package:app/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:readmore/readmore.dart';

//import 'package:whatsapp_share/whatsapp_share.dart';

class RecentCasesListScreen extends BaseStatefulWidget {
  static const routeName = '/RecentCasesListScreen';

  @override
  _RecentCasesListScreenState createState() => _RecentCasesListScreenState();
}

class _RecentCasesListScreenState extends BaseState<RecentCasesListScreen>
    with BasicScreen, WidgetsBindingObserver {
  MainBloc _CustomerBloc;
  int _pageNo = 0;
  Recent_view_list _inquiryListResponse;

  List<RecentViewDBTable> arrRecent_view_list = [];
  final TextEditingController edt_searchDetails = TextEditingController();
  final TextEditingController edt_FollowupEmployeeList =
      TextEditingController();

  //
  List<ALL_Name_ID> arr_ALL_Name_ID_For_Folowup_EmplyeeList = [];

  List<RecentViewDBTable> _allUsers = [];
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

  List<CheckBoxData> checkboxDataList =
  [
    new CheckBoxData(id: '1', displayId: 'ALL', checked: false),
    new CheckBoxData(id: '2', displayId: 'Appelate Review', checked: false),
    new CheckBoxData(id: '3', displayId: 'Apportionment', checked: false),
    new CheckBoxData(id: '4', displayId: 'Bad Faith', checked: false),
    new CheckBoxData(id: '5', displayId: 'Case Closure', checked: false),
    new CheckBoxData(id: '6', displayId: 'Compensability', checked: false),
    new CheckBoxData(id: '7', displayId: 'Compensability (Course & Scope)', checked: false),
    new CheckBoxData(id: '8', displayId: 'Compensability ( Independent Continuation)', checked: false),
    new CheckBoxData(id: '9', displayId: 'Compensability(Quasi - Course)', checked: false),
    new CheckBoxData(id: '10', displayId: 'Compensability (Substantial Deviation)', checked: false),
    new CheckBoxData(id: '11', displayId: 'Deadlines', checked: false),
    new CheckBoxData(id: '12', displayId: 'Death Benefits', checked: false),
    new CheckBoxData(id: '13', displayId: 'DIME’s', checked: false),
    new CheckBoxData(id: '14', displayId: 'Due Process', checked: false),
    new CheckBoxData(id: '15', displayId: 'Evidence', checked: false),
    new CheckBoxData(id: '16', displayId: 'Hearing ( Credibility)', checked: false),
    new CheckBoxData(id: '17', displayId: 'Hearing (Evidence)', checked: false),
    new CheckBoxData(id: '18', displayId: 'Hearing Procedure', checked: false),
    new CheckBoxData(id: '19', displayId: 'Hearings', checked: false),
    new CheckBoxData(id: '20', displayId: 'Interest', checked: false),
    new CheckBoxData(id: '21', displayId: 'Issue Preclusion', checked: false),
    new CheckBoxData(id: '22', displayId: 'Jurisdiction', checked: false),
    new CheckBoxData(id: '23', displayId: 'Lump Sum Benefits', checked: false),
    new CheckBoxData(id: '24', displayId: 'Maintenance Medical Care', checked: false),
    new CheckBoxData(id: '25', displayId: 'Medical Benefits (Authorized)', checked: false),
    new CheckBoxData(id: '26', displayId: 'Medical Treatment Guidelines', checked: false),
    new CheckBoxData(id: '27', displayId: 'Overpayment', checked: false),
    new CheckBoxData(id: '28', displayId: 'Penalties', checked: false),
    new CheckBoxData(id: '29', displayId: 'Penalties (Failing to FIle Admission)', checked: false),
    new CheckBoxData(id: '30', displayId: 'Penalties ( Failure to Carry WC)', checked: false),
    new CheckBoxData(id: '31', displayId: 'Permenant Total Disability', checked: false),
    new CheckBoxData(id: '32', displayId: 'Reopening', checked: false),
    new CheckBoxData(id: '33', displayId: 'Responsible for Termination', checked: false),
    new CheckBoxData(id: '34', displayId: 'Safety Rule Violation', checked: false),
    new CheckBoxData(id: '35', displayId: 'Temporary Disability', checked: false),
    new CheckBoxData(id: '36', displayId: 'TTD', checked: false),
    new CheckBoxData(id: '37', displayId: 'TTD (Modified Job Offers)', checked: false),
    new CheckBoxData(id: '38', displayId: 'Waiver (Concession)', checked: false),
  ];


  /*[
    new CheckBoxData(id: '1', displayId: 'Appellate Review', checked: false),
    new CheckBoxData(id: '2', displayId: 'Apportionment', checked: false),
    new CheckBoxData(id: '3', displayId: 'Bad Faith', checked: false),
    new CheckBoxData(id: '4', displayId: 'Case Closure)', checked: false),
    new CheckBoxData(
        id: '5', displayId: 'Computability', checked: false),
    new CheckBoxData(
        id: '6', displayId: 'Course & Scope', checked: false),
  ];
*/
  /*if (i == 0) {
        all_name_id.Name = "Appellate Review (125)";
        all_name_id.isChecked = false;
      } else if (i == 1) {
        all_name_id.Name = "Apportionment (87)";
        all_name_id.isChecked = false;
      } else if (i == 2) {
        all_name_id.Name = "Bad Faith (62)";
        all_name_id.isChecked = false;
      }
      if (i == 3) {
        all_name_id.Name = "Case Closure (14)";
        all_name_id.isChecked = false;
      } else if (i == 4) {
        all_name_id.Name = "Compensability (281)";
        all_name_id.isChecked = false;
      } else if (i == 5) {
        all_name_id.Name = "Course & Scope (652)";
        all_name_id.isChecked = false;
      }

      listStatus.add(all_name_id);
    }*/

  // a simple usage

/*
  bool _hasPermission;
*/

  @override
  void initState() {
    super.initState();

    _CustomerBloc = MainBloc(baseBloc);

    getListStatus();

    edt_FollowupEmployeeList.text = "ALL";

    /* edt_FollowupEmployeeList.addListener(() {
      _CustomerBloc.add(
          SearchRecentViewRetriveEvent("", edt_FollowupEmployeeList.text));
      setState(() {});
    });*/

    _CustomerBloc.add(
        SearchRecentViewRetriveEvent("", edt_FollowupEmployeeList.text));

    /*_CustomerBloc.add(
        ViewRecentCasesRequestEvent(ViewRecentCasesRequest(filter: "all")));*/
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _CustomerBloc
        ..add(SearchRecentViewRetriveEvent("", edt_FollowupEmployeeList.text)),
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (BuildContext context, MainStates state) {
          if (state is ViewRecentCasesResponseState) {
            _OnViewRecentCasesResponse(state);
          }
          if (state is CustomerDetailsResponseState) {
            _onInquiryListCallSuccess(state);
          }

          if (state is SearchRecentViewRetriveState) {
            _onsearchResult(state);
          }
          if (state is RecentViewRetriveState) {
            _ondropdownResult(state);
          }

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is CustomerDetailsResponseState ||
              currentState is SearchRecentViewRetriveState ||
              currentState is RecentViewRetriveState ||
              currentState is ViewRecentCasesResponseState) {
            return true;
          }
          return false;
        },
        listener: (BuildContext context, MainStates state) {
          if (state is SearchRecentViewRetriveState) {
            _onsearchResult(state);
          }
          return super.build(context);
        },
        listenWhen: (oldState, currentState) {
          if (currentState is SearchRecentViewRetriveState) {
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
        /* AppBar(
          backgroundColor: colorPrimary,
          title: Text("Customer List"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.water_damage_sharp,color: colorWhite,),
                onPressed: () {
                  //_onTapOfLogOut();
                  navigateTo(context, HomeScreen.routeName,
                      clearAllStack: true);
                })
          ],
        ),*/
        body: Container(
          child: Column(
            children: [
              HeaderPart(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    edt_searchDetails.text = "";
                    edt_FollowupEmployeeList.text = "ALL";

                    _CustomerBloc.add(ViewRecentCasesRequestEvent(
                        ViewRecentCasesRequest(filter: "all")));
                    _CustomerBloc.add(SearchRecentViewRetriveEvent("","ALL"));


                    /*  _CustomerBloc.add(CustomerPaginationRequestEvent(
                        CustomerPaginationRequest(
                      companyId: 4132,
                      loginUserID: "admin",
                      CustomerID: "",
                      ListMode: "L",
                    )));*/
                  },
                  child: Container(
                    padding: EdgeInsets.only(
                      left: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                      right: DEFAULT_SCREEN_LEFT_RIGHT_MARGIN2,
                      top: 25,
                    ),
                    child: Column(
                      children: [
                        _buildSearchView(),
                        SizedBox(
                          height: 10,
                        ),
                        //_buildEmplyeeListView(),
                        Expanded(child: _buildInquiryList())
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: IsAddRights == true
            ? /*FloatingActionButton(
                onPressed: () async {
                  // Add your onPressed code here!
                  // await _onTapOfDeleteALLContact();
                  // navigateTo(context, BankVoucherAddEditScreen.routeName);
                },
                child: const Icon(Icons.add),
                backgroundColor: colorPrimary,
              )*/
            Container()
            : Container(),
      ),
    );
  }

  ///builds header and title view
  Widget _buildSearchView() {
    return Container(
      margin: EdgeInsets.all(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              height: 42,
              padding: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                border: Border.all(width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(
                        10.0) //                 <--- border radius here
                    ),
              ),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      autofocus: true,
                      controller: edt_searchDetails,
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.words,
                      onChanged: (value) {
                        ///_runFilter(value);

                        _CustomerBloc.add(SearchRecentViewRetriveEvent(
                            value, edt_FollowupEmployeeList.text));
                      },
                      decoration: InputDecoration(
                        hintText: "Tap to search details",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(bottom: 5),
                      ),
                      style: baseTheme.textTheme.subtitle2
                          .copyWith(color: colorBlack),
                    ),
                  ),
                  Image.asset(
                    SEARCH_ICON,
                    height: 15,
                    width: 15,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            onTap: () {
              _showModalSheet();
            },
            child: Container(
                decoration: BoxDecoration(
                  color: Color(0xfff9e910),
                  // border: Border.all(width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(
                          10.0) //                 <--- border radius here
                      ),
                ),
                height: 42,
                width: 42,
                padding: EdgeInsets.all(10),
                child: Image.asset(
                  FILLTER_ICON,
                  color: Colors.black,
                  height: 24,
                  width: 24,
                )),
          )
        ],
      ),
    );
  }

  ///builds inquiry list
  Widget _buildInquiryList() {
    /* if (arrRecent_view_list.isEmpty) {
      return Container();
    }*/
    return arrRecent_view_list.isNotEmpty?ListView.builder(
        key: Key('selected $selected'),
        itemBuilder: (context, index) {
          //return _buildInquiryListItem(index);

          return InkWell(
            onTap: () {
              navigateTo(context, RecentCasesDetailsScreen.routeName,
                      arguments: RecentCasesDetailsScreenArgument(
                          "recentcaseslist", arrRecent_view_list[index]))
                  .then((value) {
                //_expenseBloc..add(ExpenseEventsListCallEvent(1,ExpenseListAPIRequest(CompanyId: CompanyID.toString(),LoginUserID: edt_FollowupEmployeeUserID.text,word: edt_FollowupStatus.text,needALL: "0")));
              });
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: false,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      margin: EdgeInsets.only(top: 10, right: 15),
                      child: Text(
                        index == 0
                            ? "26-01-2020".getFormattedDate(
                                fromFormat: "yyyy-MM-ddTHH:mm:ss",
                                toFormat: "yyyy-MM-dd")
                            : "27-0$index-2020".getFormattedDate(
                                fromFormat: "yyyy-MM-ddTHH:mm:ss",
                                toFormat: "yyyy-MM-dd"),
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white70, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          arrRecent_view_list[index].title,
                          //arrRecent_view_list[index].customerName,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),


                        arrRecent_view_list[index].judgeName.toString()==""?
                        Text(
                            arrRecent_view_list[index].subTitle.toString().replaceAll("\n", "") ,
                            // overflow: TextOverflow.ellipsis,
                            style:
                            TextStyle(color: Colors.black, fontSize: 13))
                            : Text(
                            arrRecent_view_list[index].subTitle.toString().replaceAll("\n", "") +

                                " [" +  arrRecent_view_list[index].judgeName.toString().replaceAll("\n", "") +"]",
                           // overflow: TextOverflow.ellipsis,
                            style:
                            TextStyle(color: Colors.black, fontSize: 13)),
                        Text(arrRecent_view_list[index].caseDetailShort.replaceAll("\n", ""),
                            overflow: TextOverflow.ellipsis,
                            style:
                                TextStyle(color: Colors.black, fontSize: 13)),

                       /* ReadMoreText(arrRecent_view_list[index].caseDetailShort,
                            trimLines: 1,
                            colorClickableText: Colors.pink,
                            trimMode: TrimMode.Line,
                            trimCollapsedText: '..Read More',
                            style: TextStyle(fontSize: 13), callback: (v) {

                        }
                            //trimExpandedText: ' Less',
                            ),*/
                        //Text(arrRecent_view_list[index].contactNo1)
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        shrinkWrap: true,
        itemCount: arrRecent_view_list.length // arrRecent_view_list.length,
        ):Center(child: Text("No Cases Found."),);
  }



  ///updates data of inquiry list
  void _onInquiryListCallSuccess(CustomerDetailsResponseState state) async {
    _CustomerBloc.add(
        SearchRecentViewRetriveEvent("", edt_FollowupEmployeeList.text));
    _CustomerBloc.add(RecentViewRetriveEvent());
    //  getDBdetails();

    //arrRecent_view_list.add(state.response);
  }


  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

/*  void _onGetDetailsofrecentviewfromdb(RecentViewRetriveState state) {
    arrRecent_view_list.clear();
    _allUsers.clear();
    for (int i = 0; i < state.recentViewDBTable.length; i++) {
      CustomerDetails customerDetails = CustomerDetails();
      customerDetails.customerID =
          int.parse(state.recentViewDBTable[i].CustomerID);

      customerDetails.customerName = state.recentViewDBTable[i].CustomerName;

      arrRecent_view_list.add(customerDetails);
      _allUsers.add(customerDetails);
    }
  }*/

  /* Future<void> _runFilter(String query) async {
    List<CustomerDetails> temp = [];
    _allUsers.forEach((item) {
      if (item.customerName.toLowerCase().contains(query.toLowerCase())) {
        temp.add(item);
      }
    });

    setState(() {
      arrRecent_view_list = temp;
      for (int i = 0; i < arrRecent_view_list.length; i++) {
        print(
            "resultFilter" + " Name : " + arrRecent_view_list[i].customerName);
      }
    });
  }*/

  Widget _buildEmplyeeListView() {
    return InkWell(
      onTap: () {
        // _onTapOfSearchView(context);

        showcustomdialogWithOnlyName(
            values: arr_ALL_Name_ID_For_Folowup_EmplyeeList,
            context1: context,
            controller: edt_FollowupEmployeeList,
            lable: "Select Item");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: 10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Select Item",
                  style: TextStyle(
                      fontSize: 12,
                      color: colorPrimary,
                      fontWeight: FontWeight
                          .bold) // baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                  ),
            ]),
          ),
          SizedBox(
            height: 3,
          ),
          Card(
            elevation: 5,
            color: colorLightGray,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Container(
              padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 10),
              width: double.maxFinite,
              child: Row(
                children: [
                  Expanded(
                    child: /* Text(
                        SelectedStatus =="" ?
                        "Tap to select Status" : SelectedStatus.Name,
                        style:TextStyle(fontSize: 12,color: Color(0xFF000000),fontWeight: FontWeight.bold)// baseTheme.textTheme.headline2.copyWith(color: colorBlack),

                    ),*/

                        TextField(
                      controller: edt_FollowupEmployeeList,
                      enabled: false,
                      /*  onChanged: (value) => {
                    print("StatusValue " + value.toString() )
                },*/
                      style: TextStyle(
                          color: Colors.black, // <-- Change this
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                      decoration: new InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          hintText: "Select"),
                    ),
                    // dropdown()
                  ),
                  /*  Icon(
                    Icons.arrow_drop_down,
                    color: colorGrayDark,
                  )*/
                ],
              ),
            ),
          )
        ],
      ),
    );
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

  void _ondropdownResult(RecentViewRetriveState state) {
    arr_ALL_Name_ID_For_Folowup_EmplyeeList.clear();

    ALL_Name_ID all_name_id = ALL_Name_ID();
    all_name_id.Name = "ALL";
    arr_ALL_Name_ID_For_Folowup_EmplyeeList.add(all_name_id);
    /* for (int i = 0; i < state.recentViewDBTable.length; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();
      all_name_id.Name = state.recentViewDBTable[i].CustomerID;
      arr_ALL_Name_ID_For_Folowup_EmplyeeList.add(all_name_id);
    }*/
  }

  HeaderPart() {
    return Container(
      height: 100,
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
                          // margin: EdgeInsets.only(left: 10),
                          child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            "Recent Cases",
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

  void getListStatus() {
    listStatus.clear();

    for (int i = 0; i < 5; i++) {
      ALL_Name_ID all_name_id = ALL_Name_ID();
      if (i == 0) {
        all_name_id.Name = "Appellate Review (125)";
        all_name_id.isChecked = false;
      } else if (i == 1) {
        all_name_id.Name = "Apportionment (87)";
        all_name_id.isChecked = false;
      } else if (i == 2) {
        all_name_id.Name = "Bad Faith (62)";
        all_name_id.isChecked = false;
      }
      if (i == 3) {
        all_name_id.Name = "Case Closure (14)";
        all_name_id.isChecked = false;
      } else if (i == 4) {
        all_name_id.Name = "Compensability (281)";
        all_name_id.isChecked = false;
      } else if (i == 5) {
        all_name_id.Name = "Course & Scope (652)";
        all_name_id.isChecked = false;
      }

      listStatus.add(all_name_id);
    }
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
                margin: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 10),
                      child: Text(
                        "Filter",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 10),
                      height: 2,
                      color: Colors.grey,
                    ),

                    /*Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: checkboxDataList.map<Widget>(
                        (data) {
                          return Container(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                CheckboxListTile(
                                  checkColor: Colors.red,
                                  activeColor: Colors.white,
                                  value: data.checked,
                                  title: Text(
                                    data.displayId,
                                    style: TextStyle(
                                        fontSize: 12, color: colorBlack),
                                  ),
                                  controlAffinity:
                                      ListTileControlAffinity.trailing,
                                  selectedTileColor: Colors.white,
                                  onChanged: (bool val) {
                                    state(() {
                                      data.checked = !data.checked;
                                    });
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ).toList(),
                    ),*/
                    Container(

                        height: 300,
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  CheckboxListTile(
                                    checkColor: Colors.red,
                                    activeColor: Colors.white,
                                    value: checkboxDataList[index].checked,
                                    title: Text(
                                      checkboxDataList[index].displayId,
                                      style: TextStyle(
                                          fontSize: 12, color: colorBlack),
                                    ),
                                    controlAffinity:
                                    ListTileControlAffinity.trailing,
                                    selectedTileColor: Colors.white,
                                    onChanged: (bool val) {
                                      state(() {
                                        checkboxDataList[index].checked = !checkboxDataList[index].checked;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          shrinkWrap: true,
                          itemCount: checkboxDataList.length,
                        )),

                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {

                              _CustomerBloc.add(SearchRecentViewRetriveEvent("","ALL"));

                              Navigator.pop(context);
                            },
                            child: Container(
                              width: double.infinity,
                              height: 38,
                              margin: EdgeInsets.only(left: 20, right: 10),
                              decoration: BoxDecoration(
                                border: Border.all(width: 1.0),
                                borderRadius: BorderRadius.all(Radius.circular(
                                        10.0) //                 <--- border radius here
                                    ),
                              ),
                              child: Center(
                                child: Text("Reset",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              //Navigator.pop(context);
                              List<String> comastring =[];

                              for(int i=0;i<checkboxDataList.length;i++)
                                {
                                  print("dsdkdfs45ddf" + " Checked : " +  checkboxDataList[i].checked.toString());
                                  if(checkboxDataList[i].checked==true)
                                    {
                                      comastring.add("'"+checkboxDataList[i].displayId+"'");
                                     // _CustomerBloc.add(SearchRecentViewRetriveEvent(edt_searchDetails.text,checkboxDataList[i].displayId));
                                    }
                                }

                              String strarray = comastring.join(', ');
                              print("fkdsfkd"+ " CommaSeperated : "+strarray.toString());
                             _CustomerBloc.add(SearchRecentViewRetriveEvent(edt_searchDetails.text,strarray));

                              Navigator.pop(context);

                            },
                            child: Container(
                              width: double.infinity,
                              height: 40,
                              margin: EdgeInsets.only(left: 10, right: 20),
                              decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(
                                          10.0) //                 <--- border radius here
                                      )),
                              child: Center(
                                child: Text("Apply",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ),
                      ],
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

  void _OnViewRecentCasesResponse(ViewRecentCasesResponseState state) async {
    // arrRecent_view_list.clear();
    print("KeyRecentResponse" +
        "API Response and Bind data details" +
        state.viewRecentCasesResponse.data.details[0].title);
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
}

class CheckBoxData {
  String id;
  String displayId;
  bool checked;

  CheckBoxData({
    this.id,
    this.displayId,
    this.checked,
  });

  factory CheckBoxData.fromJson(Map<String, dynamic> json) => CheckBoxData(
        id: json["id"] == null ? null : json["id"],
        displayId: json["displayId"] == null ? null : json["displayId"],
        checked: json["checked"] == null ? null : json["checked"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "displayId": displayId == null ? null : displayId,
        "checked": checked == null ? null : checked,
      };
}
