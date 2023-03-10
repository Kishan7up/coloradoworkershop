import 'package:app/blocs/other/mainbloc/main_bloc.dart';
import 'package:app/models/api_request/customer/customer_paggination_request.dart';
import 'package:app/models/api_response/customer/customer_details_api_response.dart';
import 'package:app/models/api_response/recent_view_list/recent_view_list_response.dart';
import 'package:app/ui/res/color_resources.dart';
import 'package:app/ui/res/dimen_resources.dart';
import 'package:app/ui/screens/base/base_screen.dart';
import 'package:app/ui/screens/dashboard/home_screen.dart';
import 'package:app/utils/general_utils.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  List<CustomerDetails> arrRecent_view_list = [];
  final TextEditingController edt_searchDetails = TextEditingController();

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
/*
  bool _hasPermission;
*/

  @override
  void initState() {
    super.initState();
/*
    _askPermissions();
*/
    _CustomerBloc = MainBloc(baseBloc);
    //_CustomerBloc.add(RecentListCallEvent());
    _CustomerBloc.add(CustomerPaginationRequestEvent(CustomerPaginationRequest(
      companyId: 4132,
      loginUserID: "admin",
      CustomerID: "",
      ListMode: "L",
    )));

    _CustomerBloc.add(RecentViewRetriveEvent());
/*    edt_searchDetails.addListener(() {
      List<CustomerDetails> temp = [];
      _allUsers.forEach((item) {
        if (item.customerName
            .toLowerCase()
            .contains(edt_searchDetails.text.toLowerCase())) {
          temp.add(item);
        }
      });
      setState(() {
        arrRecent_view_list = temp;
      });
    });*/
    //RecentViewEvent
    //getDBdetails();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => _CustomerBloc,
      child: BlocConsumer<MainBloc, MainStates>(
        builder: (BuildContext context, MainStates state) {
          if (state is CustomerDetailsResponseState) {
            _onInquiryListCallSuccess(state);
          }

          if (state is RecentViewRetriveState) {
            _onGetDetailsofrecentviewfromdb(state);
          }

          return super.build(context);
        },
        buildWhen: (oldState, currentState) {
          if (currentState is CustomerDetailsResponseState ||
              currentState is RecentViewRetriveState) {
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
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Recent List'),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.water_damage_sharp,
                  color: colorWhite,
                ),
                onPressed: () {
                  //_onTapOfLogOut();
                  navigateTo(context, HomeScreen.routeName,
                      clearAllStack: true);
                })
          ],
        ),
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
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _CustomerBloc.add(CustomerPaginationRequestEvent(
                        CustomerPaginationRequest(
                      companyId: 4132,
                      loginUserID: "admin",
                      CustomerID: "",
                      ListMode: "L",
                    )));
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.only(left: 10, right: 20),
          child: Text("Min. 3 chars to search details",
              style: TextStyle(
                  fontSize: 12,
                  color: colorPrimary,
                  fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 5,
        ),
        Card(
          elevation: 5,
          color: colorLightGray,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(
            height: 60,
            padding: EdgeInsets.only(left: 20, right: 20),
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
                      _runFilter(value);
                    },
                    decoration: InputDecoration(
                      hintText: "Tap to search details",
                      border: InputBorder.none,
                    ),
                    style: baseTheme.textTheme.subtitle2
                        .copyWith(color: colorBlack),
                  ),
                ),
                Icon(
                  Icons.search,
                  color: colorGrayDark,
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  ///builds inquiry list
  Widget _buildInquiryList() {
    if (arrRecent_view_list.isEmpty) {
      return Container();
    }
    return ListView.builder(
      key: Key('selected $selected'),
      itemBuilder: (context, index) {
        return _buildInquiryListItem(index);
      },
      shrinkWrap: true,
      itemCount: arrRecent_view_list.length,
    );
  }

  ///builds row item view of inquiry list
  Widget _buildInquiryListItem(int index) {
    return ExpantionCustomer(context, index);
  }

  ///updates data of inquiry list
  void _onInquiryListCallSuccess(CustomerDetailsResponseState state) async {
    _CustomerBloc.add(RecentViewRetriveEvent());

    //  getDBdetails();

    //arrRecent_view_list.add(state.response);
  }

  ExpantionCustomer(BuildContext context, int index) {
    CustomerDetails model = arrRecent_view_list[index];

    return Container(
        padding: EdgeInsets.all(15),
        child: ExpansionTileCard(
          // key:Key(index.toString()),
          initialElevation: 5.0,
          elevation: 5.0,
          elevationCurve: Curves.easeInOut,
          shadowColor: Color(0xFF504F4F),
          baseColor: Color(0xFFFCFCFC),
          expandedColor: Color(0xFFC1E0FA),
          leading: CircleAvatar(
              backgroundColor: Color(0xFF504F4F),
              child: Image.network(
                "http://demo.sharvayainfotech.in/images/profile.png",
                height: 35,
                fit: BoxFit.fill,
                width: 35,
              )),
          title: Text(
            model.customerID.toString(),
            style: TextStyle(color: Colors.black),
          ),

          children: <Widget>[
            Divider(
              thickness: 1.0,
              height: 1.0,
            ),
            Text(
              model.customerName,
              style: TextStyle(color: Colors.black),
            ),
          ],
        ));
  }

  Future<bool> _onBackPressed() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

  void _onGetDetailsofrecentviewfromdb(RecentViewRetriveState state) {
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
  }

  Future<void> _runFilter(String query) async {
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
  }
}
