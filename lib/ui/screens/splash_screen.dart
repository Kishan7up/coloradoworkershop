/*
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

    const delay = const Duration(seconds: 5);

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
*/
import 'dart:io';

import 'package:app/ui/res/image_resources.dart';
import 'package:app/ui/screens/dashboard/home_screen.dart';
import 'package:app/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../main.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/SplashScreen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();
    /* Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isAnimate = true;
      });
    });*/

    /// GIF related Site : https://ezgif.com/loop-count/ezgif-2-6885959fb6.gif
    /// https://onlinegiftools.com/

    Future.delayed(const Duration(seconds: 3), () {
      navigateTo(context, HomeScreen.routeName, clearAllStack: true);

      /// navigateTo(context, HomeScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        body: Container(
            /* constraints: BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(SPLASH_SCREEN_BACKGOUND), fit: BoxFit.cover),
          ),*/

            height: double.infinity,
            width: double.infinity,
            child: Image.asset(SPLASH_SCREEN_BACKGOUND,
                gaplessPlayback: false, fit: BoxFit.fill)
            // child:,
            ),
      ),
    );
  }

  Widget getbackupanimation() {
    return Stack(children: [
      Container(
        child: AnimatedPositioned(
            left: mq.width * .25,
            top: mq.height * .15,
            width: mq.width * .5,
            bottom: _isAnimate ? mq.width * .25 : -mq.width * .15,
            duration: const Duration(seconds: 1),
            child: Image.asset(
              COLORADO_LOGO,
              height: 200,
              width: 200,
            )),
      ),
      /*Container(
                padding: EdgeInsets.only(top: 400),
                child: AnimatedTextKit(
                  animatedTexts: [
                    RotateAnimatedText('Instagram',
                        textStyle: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            backgroundColor: Colors.blue)),
                  ],
                  isRepeatingAnimation: false,
                  totalRepeatCount: 1,
                  pause: Duration(milliseconds: 1000),
                ),
              ),*/
    ]);
  }

  Future<bool> _onBackPressed() {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else if (Platform.isIOS) {
      exit(0);
    }
  }
}
