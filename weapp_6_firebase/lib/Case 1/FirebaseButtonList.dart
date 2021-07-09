import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weapp_6_firebase/Case%201/Crash%20Application.dart';
import 'package:weapp_6_firebase/Case%201/FireStore%20Cloud.dart';
import 'package:weapp_6_firebase/Case%201/LocalNotificationDemo.dart';
import 'package:weapp_6_firebase/Case%201/Notification.dart';
import 'package:weapp_6_firebase/Case%201/Realtime%20Database.dart';
import 'package:weapp_6_firebase/Case%201/Resister.dart';
import 'package:weapp_6_firebase/Case%201/Sign%20In.dart';
import 'package:weapp_6_firebase/Case%201/Storage.dart';

class FireBaseButtonList extends StatefulWidget {
  @override
  _FireBaseButtonListState createState() => _FireBaseButtonListState();
}

class _FireBaseButtonListState extends State<FireBaseButtonList> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RaisedButton(
              onPressed: () {
                FirebaseAnalytics().logEvent(
                    name: 'Register', parameters: {'Value': DateTime
                    .now()
                    .microsecondsSinceEpoch
                    .toString()});
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Register(),
                    ),
                );
              },
              child: Text("Register"),
            ),
            RaisedButton(
              onPressed: () {
                if(_auth.currentUser == null){
                  print(">>>> null user");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignIn(auth:_auth),
                    ),
                  );
                }else{
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage(auth: _auth)));
                }


                //
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => SignIn(),
                //     ),
                // );
              },
              child: Text("Sign In"),
            ),
            // RaisedButton(
            //   onPressed: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => FireStoreCloudDemo(),
            //         ));
            //   },
            //   child: Text("Firebase CloudFireStore"),
            // ),
            // RaisedButton(
            //   onPressed: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => RealTimeDatabaseDemo(),
            //         ));
            //   },
            //   child: Text("Real Time Database"),
            // ),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          FirebaseStorageDemo(title: 'Storage',),
                    ),
                );
              },
              child: Text("Firebase Storage"),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationDemo(),
                    ),
                );
              },
              child: Text("Cloud Messaging"),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CrashAppDemo(),
                    ),
                );
              },
              child: Text("Crashlytics"),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocalNotificationDemo(),
                  ),
                );
              },
              child: Text("Local Notification"),
            ),
          ],
        ),
      ),
    );
  }
}
