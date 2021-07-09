import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart' as provider;
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weapp_6_firebase/Case 1/Topics.dart';
import 'package:weapp_6_firebase/Case%201/FirebaseButtonList.dart';
import 'package:weapp_6_firebase/Case%201/Provider.dart';
import 'package:weapp_6_firebase/Case%201/Shared%20Preference.dart';
import 'package:weapp_6_firebase/JsonDemo/Result.dart';
import 'package:weapp_6_firebase/JsonDemo/Saturday.dart';
import 'package:weapp_6_firebase/Theme.dart';
import 'package:http/http.dart' as http;

List<SingleChildWidget> providers = [
  provider.ChangeNotifierProvider<ItemProvider>(create: (_) => ItemProvider()),
  provider.ChangeNotifierProvider<ProviderClass>(
      create: (_) => ProviderClass()),
];

var email;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  email = prefs.getString('email');
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  runApp(provider.MultiProvider(
    providers: providers,
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo',
      theme: theme(),
      debugShowCheckedModeBanner: false,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analytics),
      ],
      // home: email != null ? Home() : SplashScreen(),
      home: FireBaseButtonList(),
      // home: SatDay(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  FirebaseAnalytics analytics = FirebaseAnalytics();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Topics(analytics: analytics)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            "assets/images/travelimage3.jpg",
            fit: BoxFit.cover,
          ),
          Container(
              child: Center(
                  child: Text(
            "SharePreference Is Empty",
            style: TextStyle(fontSize: 20, color: Colors.white),
          )))
        ],
      ),
    ));
  }
}

// 5.6.2


class SatDay extends StatefulWidget {
  @override
  _SatDayState createState() => _SatDayState();
}

class _SatDayState extends State<SatDay> {
  Saturday saturday;
  List<Result> res = List<Result>();
  Future<void> getApiData() async {
    var response = await http.get("https://rss.itunes.apple.com/api/v1/us/apple-music/coming-soon/all/10/explicit.json");
    saturday = Saturday.fromJson(jsonDecode(response.body));
    // print(saturday.toJson()["feed"]["results"]);
    // res.add(Result.fromJson(jsonDecode(response.body)["feed"]["results"][0]));
    res.forEach((element) { print(element.toJson());});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: RaisedButton(
            onPressed: (){
              getApiData();
            },
            child: Text("Get"),
          ),
        ),
      ),
    );
  }
}




