import 'package:app/ui/res/image_resources.dart';
import 'package:app/ui/screens/dashboard/home_screen.dart';
import 'package:app/utils/general_utils.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/SplashScreen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                COLORADO_LOGO,
                height: 100,
                width: 100,
              ),
              Text(
                "Colorado Workers Comps",
                style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins"),
              ),
            ],
          ),
        ));
  }
}
