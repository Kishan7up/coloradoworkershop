import 'package:app/blocs/base/base_bloc.dart';
import 'package:app/models/common/globals.dart';
import 'package:app/repositories/custom_exception.dart';
import 'package:app/ui/res/color_resources.dart';
import 'package:app/ui/res/localizations/app_localizations.dart';
import 'package:app/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseStatefulWidget extends StatefulWidget
    with WidgetsBindingObserver {}

abstract class BaseState<Screen extends BaseStatefulWidget>
    extends State<Screen> with RouteAware {}

mixin BasicScreen<Screen extends BaseStatefulWidget> on BaseState<Screen> {
  AppLocalizations localizations;
  BaseBloc baseBloc;
  ThemeData baseTheme;

  ///progress bar related declarations
  bool _showProgressDialog = false;
  GlobalKey _progressBarKey = GlobalKey();
  final GlobalKey<ScaffoldState> mainScaffoldKey =
      new GlobalKey<ScaffoldState>();

  ///top bar related declarations
  Color screenStatusBarColor;
  GlobalKey appBarKey = GlobalKey();

  ///initializes base bloc
  @override
  initState() {
    super.initState();
    baseBloc = BaseBloc();
  }

  ///listens base blocs states
  ///builds screen
  @override
  Widget build(BuildContext context) {
    Globals.context = context;
    localizations = AppLocalizations.of(context);
    baseTheme = Theme.of(context);

    return WillPopScope(
      child: BlocProvider(
        child: BlocConsumer<BaseBloc, BaseStates>(
          //defining conditions for builder function about when it should rebuild screen
          buildWhen: (previousState, currentState) {
            if (currentState is ShowProgressIndicatorState ||
                currentState is ApiCallFailureState) {
              //no need to rebuild for these states
              return false;
            }
            return true;
          },
          builder: (context, state) {
            return _buildScreen();
          },
          //all base listeners are handled below
          listener: (BuildContext context, BaseStates state) async {
            if (state is ApiCallFailureState) {
              if (state.exception is UnauthorisedException) {
                //redirecting to login screen as session is expired
                //TODO
              } else {
                /*showCommonDialogWithSingleOption(
                    context, state.exception.toString(),
                    positiveButtonTitle: "OK");*/
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor:Colors.black,

                    content: Text(state.exception.toString(),style: TextStyle(color: Colors.white),)));

              }
            }
            if (state is ShowProgressIndicatorState) {
              if (state.showProgress) {
                showProgressBar();
              } else {
                hideProgressBar();
              }
            }
          },
        ),
        create: (BuildContext context) => baseBloc,
      ),
      onWillPop: onPop,
    );
  }

  ///builds and returns screen as a widget
  Widget _buildScreen() {
    return Stack(
      children: [
        Scaffold(
          key: mainScaffoldKey,
          extendBody: false,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset(),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(0),
            child: StatefulBuilder(
              key: appBarKey,
              builder: (BuildContext context,
                  void Function(void Function()) setState) {
                return AppBar(
                  backgroundColor: screenStatusBarColor ?? colorPrimary,
                  elevation: 0,
                );
              },
            ),
          ),
          backgroundColor: Colors.white,
          bottomNavigationBar: buildBottomNavigationBar(context),
          body: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onVerticalDragDown: isBottomSheet()
                ? null
                : (value) {
                    FocusScope.of(context).unfocus();
                  },
            child: SafeArea(
              child: Container(
                  width: double.maxFinite,
                  color: Colors.white,
                  child: buildBody(context)),
            ),
          ),
        ),
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Visibility(
              visible: _showProgressDialog,
              child: Container(
                width: double.maxFinite,
                height: double.maxFinite,
                color: Colors.black26,
                child: Center(
                    child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(colorRED),
                )),
              ),
            );
          },
          key: _progressBarKey,
        )
      ],
    );
  }

  ///can be override following method in any screen if its bottomSheet
  ///if returns true gesture detector to hide keyboard while scrolling will disable
  ///if returns false gesture detector to hide keyboard while scrolling will enable
  bool isBottomSheet() {
    return false;
  }

  ///abstract method to be override following method in any screen to build main body of screen
  Widget buildBody(BuildContext context);

  ///can be override following method in any screen to provide bottom navigation bar
  Widget buildBottomNavigationBar(BuildContext context) {
    return null;
  }

  ///can be override following method in any screen if want to perform anything on pop
  Future<bool> onPop() async {
    return true;
  }

  ///can be override following method in any screen if want to resize avoiding bottom inset
  bool resizeToAvoidBottomInset() {
    return true;
  }

  ///shows progressbar
  void showProgressBar() {
    _progressBarKey.currentState.setState(() {
      _showProgressDialog = true;
    });
  }

  ///hides progressbar
  void hideProgressBar() {
    _progressBarKey.currentState.setState(() {
      _showProgressDialog = false;
    });
  }

  ///returns true/false if progressbar is showing
  bool isProgressBarShowing() {
    return _showProgressDialog;
  }
}
