import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';


class CrashAppDemo extends StatefulWidget {
  @override
  _CrashAppDemoState createState() => _CrashAppDemoState();
}

class _CrashAppDemoState extends State<CrashAppDemo> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Crash"),),
      body: Container(
        child: Center(
          child: RaisedButton(
            onPressed: (){
              FirebaseCrashlytics.instance.crash();
            },
            child: Text("Crash Now"),
          ),
        ),
      ),
    );
  }
}
