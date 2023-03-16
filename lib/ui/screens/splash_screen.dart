import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:app/ui/res/image_resources.dart';
import 'package:app/ui/screens/dashboard/home_screen.dart';
import 'package:app/utils/general_utils.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/SplashScreen';

  const SplashScreen({Key key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isAnimate = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _isAnimate = true;
      });
      onTimerFinished();
    });
  }

  void onTimerFinished() {
    navigateTo(context, HomeScreen.routeName, clearAllStack: true);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        constraints: BoxConstraints.expand(),
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage(SPLASH_SCREEN_BACKGOUND), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 200),
              child: AnimatedTextKit(
                animatedTexts: [
                  RotateAnimatedText('',
                      textStyle: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                          backgroundColor: Colors.blue)),
                ],
                isRepeatingAnimation: false,
                totalRepeatCount: 1,
                pause: Duration(milliseconds: 1000),
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Container(
              child: AnimatedPositioned(
                  duration: const Duration(seconds: 1),
                  child: /*Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 5,
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(5), //<-- SEE HERE
                      ),
                      child:*/
                      Image.asset(COLORADO_LOGO)) /*)*/,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Text(
                "Colorado Workers' Compensation",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins"),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/*import 'package:app/ui/res/image_resources.dart';
import 'package:app/ui/screens/dashboard/home_screen.dart';
import 'package:app/utils/general_utils.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/SplashScreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool launchAnimation = true;

  @override
  void initState() {
    //  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    //  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();
    */ /*_controller = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    )..repeat();*/ /*

    //Future.delayed(delay, () => onTimerFinished());
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
            */ /*height: 200,
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
                ),*/ /*
            child: Image.asset(
              MAX_BENEFIT,
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
}*/
