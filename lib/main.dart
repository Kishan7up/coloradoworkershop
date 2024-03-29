import 'package:app/ui/res/localizations/app_localizations.dart';
import 'package:app/ui/res/style_resources.dart';
import 'package:app/ui/screens/dashboard/about_us.dart';
import 'package:app/ui/screens/dashboard/calculate_net_present_value.dart';
import 'package:app/ui/screens/dashboard/contact_us.dart';
import 'package:app/ui/screens/dashboard/home_screen.dart';
import 'package:app/ui/screens/dashboard/maximum_benifits.dart';
import 'package:app/ui/screens/dashboard/new_ppd_award_screen.dart';
import 'package:app/ui/screens/dashboard/notification_screen.dart';
import 'package:app/ui/screens/dashboard/ppd_award_screen.dart';
import 'package:app/ui/screens/dashboard/recent_cases_details_screen.dart';
import 'package:app/ui/screens/dashboard/web_view_remote_page.dart';
import 'package:app/ui/screens/splash_screen.dart';
import 'package:app/utils/general_utils.dart';
import 'package:app/utils/offline_db_helper.dart';
import 'package:app/utils/push_notification_service.dart';
import 'package:app/utils/shared_pref_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

import 'ui/screens/dashboard/recent_cases_list_screen.dart';

Size mq;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PushNotificationService().setupInteractedMessage();

  await SharedPrefHelper.createInstance();
  await OfflineDbHelper.createInstance();

  runApp(MyApp());

  RemoteMessage initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    // App received a notification when it was killed
  }

  await Permission.notification.isDenied.then(
    (bool value) {
      if (value) {
        Permission.notification.request();
      }
    },
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  ///handles screen transaction based on route name
  static MaterialPageRoute globalGenerateRoute(RouteSettings settings) {
    //if screen have no argument to pass data in next screen while transiting
    // final GlobalKey<ScaffoldState> key = settings.arguments;

    switch (settings.name) {
      case SplashScreen.routeName:
        return getMaterialPageRoute(SplashScreen());
      case HomeScreen.routeName:
        return getMaterialPageRoute(HomeScreen());
      case RecentCasesListScreen.routeName:
        return getMaterialPageRoute(RecentCasesListScreen());

      case RecentCasesDetailsScreen.routeName:
        return getMaterialPageRoute(
            RecentCasesDetailsScreen(settings.arguments));
      case PpdAwardScreen.routeName:
        return getMaterialPageRoute(PpdAwardScreen(settings.arguments));
      case CalculateNetPresentValue.routeName:
        return getMaterialPageRoute(
            CalculateNetPresentValue(settings.arguments));

      case MaximumBenefitsScreen.routeName:
        return getMaterialPageRoute(MaximumBenefitsScreen(settings.arguments));

      case AboutUsScreen.routeName:
        return getMaterialPageRoute(AboutUsScreen(settings.arguments));

      case ContactUsScreen.routeName:
        return getMaterialPageRoute(ContactUsScreen(settings.arguments));
      case NotificationScreen.routeName:
        return getMaterialPageRoute(NotificationScreen(settings.arguments));

      case WebViewRemotePage.routeName:
        return getMaterialPageRoute(WebViewRemotePage(settings.arguments));
      case NewPpdAwardScreen.routeName:
        return getMaterialPageRoute(NewPpdAwardScreen(settings.arguments));

      default:
        return null;
    }
  }
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        onGenerateRoute: MyApp.globalGenerateRoute,
        debugShowCheckedModeBanner: false,
        supportedLocales: [
          Locale('en', 'US'),
        ],
        localizationsDelegates: [
          // A class which loads the translations from JSON files
          AppLocalizations.delegate,
          // Built-in localization of basic text for Material widgets
          GlobalMaterialLocalizations.delegate,
          // Built-in localization for text direction LTR/RTL
          GlobalWidgetsLocalizations.delegate,
        ],
        // Returns a locale which will be used by the app
        localeResolutionCallback: (locale, supportedLocales) {
          // Check if the current device locale is supported
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale.languageCode &&
                supportedLocale.countryCode == locale.countryCode) {
              return supportedLocale;
            }
          }
          // If the locale of the device is not supported, use the first one
          // from the list (English, in this case).
          return supportedLocales.first;
        },
        title: "Flutter base app",
        theme: buildAppTheme(),
        home: SplashScreen());
  }

  ///returns initial route based on condition of logged in/out
/*  getInitialRoute() {
    // return LoginScreen.routeName;

    return SplashScreen.routeName;
  }*/
}
