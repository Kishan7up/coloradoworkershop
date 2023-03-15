import 'package:app/ui/res/image_resources.dart';
import 'package:app/ui/screens/dashboard/home_screen.dart';
import 'package:app/utils/general_utils.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/SplashScreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  bool launchAnimation = true;
  AnimationController controller;
  Animation offset;
  @override
  void initState() {
    //  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    //  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();
    /* controller
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    offset = Tween(begin: Offset.zero, end: const Offset(0.0, 1.0))
        .animate(controller);
*/
    const delay = const Duration(seconds: 5);

    /* switch (controller.status) {
      case AnimationStatus.completed:
        controller.reverse();
        break;
      case AnimationStatus.dismissed:
        controller.forward();
        break;
      default:
    }*/
    Future.delayed(delay, () => onTimerFinished());
  }

  void onTimerFinished() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

  @override
  Widget build(BuildContext context) {
    //428 * 926
    return Scaffold(
        body: DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(SPLASH_SCREEN_BACKGOUND), fit: BoxFit.cover),
      ),
      child: Stack(
        children: [
          /* Align(
            alignment: Alignment.bottomCenter,
            child: SlideTransition(
              position: offset,
              child: Padding(
                padding: EdgeInsets.all(70.0),
                child: LOGO(),
              ),
            ),
          )*/
          Center(child: LOGO()),
        ],
      ),
    ));
  }

  LOGO() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              border: Border.all(
                //<-- SEE HERE
                color: Colors.white, // Set border color

                width: 5,
              ),
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            /*height: 200,
            width: 200,
            decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                border: Border.all(
                    color: Colors.white, // Set border color
                    width: 3.0), // Set border width
                borderRadius: BorderRadius.all(
                    Radius.circular(10.0)), // Set rounded corner radius
                boxShadow: [
                  BoxShadow(
                      blurRadius: 10, color: Colors.white, offset: Offset(1, 3))
                ] // Make rounded corner of border
                ),*/
            child: Image.asset(
              COLORADO_LOGO,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Colorado Workers' Compensation",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                fontFamily: "Poppins"),
          ),
        ],
      ),
    );
  }
}
