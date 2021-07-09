import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weapp_6_firebase/Case%201/CalenderDemo.dart';
import 'package:weapp_6_firebase/Case%201/FirebaseButtonList.dart';
import 'package:weapp_6_firebase/Case%201/Gestures.dart';
import 'package:weapp_6_firebase/Case%201/Google.dart';
import 'package:weapp_6_firebase/Case%201/ImageIntegration.dart';
import 'package:weapp_6_firebase/Case%201/ImageWidget&Provider.dart';
import 'package:weapp_6_firebase/Case%201/InApp%20Purchase.dart';
import 'package:weapp_6_firebase/Case%201/Mail-SMS-CALL/ButtonList.dart';
import 'package:weapp_6_firebase/Case%201/Navigator.dart';
import 'package:weapp_6_firebase/Case%201/Player/VideoAudioButtonList.dart';
import 'package:weapp_6_firebase/Case%201/Provider.dart';
import 'package:weapp_6_firebase/Case%201/PullAndLazyLoading.dart';
import 'package:weapp_6_firebase/Case%201/SaveAndGetFileDemo.dart';
import 'package:weapp_6_firebase/Case%201/Shared%20Preference.dart';
import 'package:weapp_6_firebase/Case%201/Sqflite/SqfliteDatabase.dart';
import 'package:weapp_6_firebase/Case%201/UiComponent.dart';
import 'package:weapp_6_firebase/ShimmerTopic.dart';
//   cloud_firestore: ^0.14.1+3
//   firebase_auth: ^0.18.1+2
//   firebase_core: ^0.5.0
//   google_sign_in: ^4.5.3
//   email_auth: ^0.0.1+2
//   firebase_database: ^4.0.0
//   intl:
//   firebase_messaging: ^7.0.3
//   firebase_storage: ^5.1.0
//   image_picker: ^0.6.6+1
//   transparent_image: ^1.0.0
//   carousel_slider: ^2.3.1
//   flutter_staggered_grid_view: ^0.3.2


// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Topics(),
//     );
//   }
// }
//




class Topics extends StatefulWidget {

  final FirebaseAnalytics analytics;
  Topics({this.analytics});

  @override
  _TopicsState createState() => _TopicsState();
}

class _TopicsState extends State<Topics> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _currentScreen();

  }


  Future<Null> _currentScreen() async {
    await widget.analytics.setCurrentScreen(
        screenName: 'Topics', screenClassOverride: 'Topics');
  }

  Future<Null> _sendAnalytics() async {
    await widget.analytics
        .logEvent(name: 'RealTimeDatabaseDemo_taped', parameters: <String, dynamic>{});
  }

  Future<bool> _willPopCallback() {
    return SystemNavigator.pop() ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child:SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ShimmerTopic(
                    title: "AppLife Cycle",
                    description:
                    "Application Life Cycles. Resume, Stop, Inactive, Detached",
                    fun: () {FirebaseAnalytics().logEvent(name: 'Register',parameters:{'Value':DateTime.now().microsecondsSinceEpoch.toString()});Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AppLifeCycleDemo(),
                        ));},wi:text1("6")),
                ShimmerTopic(
                    title: "Navigator",
                    description:
                    "Push & Pop, Send Data Back On Pop.",
                    fun: () {
                      FirebaseAnalytics().logEvent(name: 'JAYNavigator',parameters:{'Value':DateTime.now().microsecondsSinceEpoch.toString()});
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FirstScreen(),
                        ));},wi:text1("7")),
                ShimmerTopic(
                    title: "Provider",
                    description:
                    "It Is State Management, Load Data From Api Once Only & Manage Variables.",
                    fun: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProviderDemoPage(),
                        )),wi:text1("8")),
                ShimmerTopic(title: "Ui",
                    description:
                    "Drawer, TabBar, Bottom Navigation Bar, Pop Over, Action Sheet Bar.",
                    fun: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UiComponentButtonList(),
                        )),wi:text1("11")),
                ShimmerTopic(title: "Gestures",
                    description:
                    "Gesture Methods, Drag And Drop And Animation",
                    fun: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GestureButtonList(),
                        )),wi:text1("12")),
                ShimmerTopic(title: "Shared Preferences",
                    description:
                    "Save Data in Shared Preferences",
                    fun: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SharedPreferenceDemo(),
                        )),wi:text1("15")),
                ShimmerTopic(title: "SQFlite",
                    description:
                    "Local Database With Insert, Update And Delete Query",
                    fun: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TodoList(),
                        )),wi:text1("16")),
                ShimmerTopic(title: "Video & Audio",
                    description:
                    "Play Video & Audio From File And Network",
                    fun: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoAudioButtonList(),
                        )),wi:text1("18")),
                ShimmerTopic(title: "Email-Call-SMS",
                    description:
                    "You Can Mack Direct Phone Calls, SMS And Mails From Gmail By Pressing Button.",
                    fun: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EmailCallSMSButton(),
                        )),wi:text1("21")),
                ShimmerTopic(title: "Social Login & Share",
                    description:
                    "Google, Facebook, Instagram & Share",
                    fun: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SocialLoginButtonList(),
                        )),wi:text1("22")),
                ShimmerTopic(title: "In App Purchase",
                    description:
                    "In Application Some Kind Of Feature is Not Free, You Can Buy it And Use It.",
                    fun: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentButtonList(),
                        )),wi:text1("24")),
                ShimmerTopic(title: "Universal App",
                    description:
                    "LayOut",
                    fun: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ImageIntegrationPage(),
                        )),wi:text1("25")),
                ShimmerTopic(title: "Download",
                    description:
                    "Download Different Types Of File And Save In Storage",
                    fun: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SaveImageDemo(),
                        )),wi:text1("26")),
                ShimmerTopic(title: "Save & Get",
                    description:
                    "Read & Write Data From File",
                    fun: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReadWriteDemo(storage: TextStorage())
                        )),wi:text1("28")),
              ],
            ),
          )
        ),
      ),
    );
  }
}

Widget text1(String text){
  return Text(text,style: TextStyle(fontSize: 40,fontWeight: FontWeight.bold,color: Colors.white),);
}



class AppLifeCycleDemo extends StatefulWidget {
  @override
  _AppLifeCycleDemoState createState() => _AppLifeCycleDemoState();
}

class _AppLifeCycleDemoState extends State<AppLifeCycleDemo> with WidgetsBindingObserver {


  String text = "Waiting...";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        setState(() {
          text = "Inactive";
        });
        print("Inactive");
        break;
      case AppLifecycleState.paused:
        setState(() {
          text = "Paused";
        });
        print("Paused");
        break;
      case AppLifecycleState.resumed:
        setState(() {
          text = "Resumed";
        });
        print("Resumed");
        break;
      case AppLifecycleState.detached:
        setState(() {
          text = "detached";
        });
        print("detached");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(child: Text(text))
    );
  }

}
