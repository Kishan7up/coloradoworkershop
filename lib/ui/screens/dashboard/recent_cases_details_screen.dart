import 'package:app/blocs/other/mainbloc/main_bloc.dart';
import 'package:app/models/DB_Models/recent_view_list_db_tabel.dart';
import 'package:app/models/api_response/customer/customer_details_api_response.dart';
import 'package:app/models/api_response/recent_view_list/recent_view_list_response.dart';
import 'package:app/models/common/all_name_id_list.dart';
import 'package:app/ui/res/color_resources.dart';
import 'package:app/ui/screens/base/base_screen.dart';
import 'package:app/ui/screens/dashboard/home_screen.dart';
import 'package:app/ui/screens/dashboard/recent_cases_list_screen.dart';
import 'package:app/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

//import 'package:whatsapp_share/whatsapp_share.dart';

class RecentCasesDetailsScreenArgument {
  RecentViewDBTable recentViewDBTable;

  RecentCasesDetailsScreenArgument(this.recentViewDBTable);
}

class RecentCasesDetailsScreen extends BaseStatefulWidget {
  static const routeName = '/RecentCasesDetailsScreen';

  final RecentCasesDetailsScreenArgument arguments;

  RecentCasesDetailsScreen(this.arguments);

  @override
  _RecentCasesDetailsScreenState createState() =>
      _RecentCasesDetailsScreenState();
}

class _RecentCasesDetailsScreenState extends BaseState<RecentCasesDetailsScreen>
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

  RecentViewDBTable _editModel;

  @override
  void initState() {
    super.initState();

    _CustomerBloc = MainBloc(baseBloc);

    if (widget.arguments != null) {
      _editModel = widget.arguments.recentViewDBTable;
      // _editModel2 = widget.arguments.editModel2;
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
              Container(
                margin: EdgeInsets.all(10),
                child: Card(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.white70, width: 1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            _editModel.title,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Text(
                            _editModel.caseDetailShort.toString(),
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 2,
                          color: colorLightGray,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Text(_editModel.caseDetailLong.toString(),
                              style: TextStyle(
                                fontSize: 13,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFFF9E910),
          onPressed: () {
            if (_editModel.link != "") {
              _launchURL(
                  "https://admin.appcoloworkcomp.com/" + _editModel.link);
            } else {
              showCommonDialogWithSingleOption(
                  context, "Download Link is Not Valid !",
                  positiveButtonTitle: "OK", onTapOfPositiveButton: () {
                Navigator.pop(context);
              });
            }
            //https://www.buds.com.ua/images/Lorem_ipsum.pdf
          },
          child: Icon(
            Icons.download_rounded,
            color: Colors.black,
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
                        navigateTo(context, RecentCasesListScreen.routeName);
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

  _launchURL(String pdfURL) async {
    var url123 = pdfURL;
    if (await canLaunch(url123)) {
      await launch(url123);
    } else {
      throw 'Could not launch $url123';
    }
  }
}
