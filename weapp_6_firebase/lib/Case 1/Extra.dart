import 'package:flutter/material.dart';
import 'package:weapp_6_firebase/Case%201/Email%20OTP.dart';
import 'package:weapp_6_firebase/Case%201/SaveAndGetFileDemo.dart';

import 'Share.dart';

class ExtraButtonList extends StatefulWidget {
  @override
  _ExtraButtonListState createState() => _ExtraButtonListState();
}

class _ExtraButtonListState extends State<ExtraButtonList> {
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
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReadWriteDemo(storage: TextStorage())
                      ));
                },
                child: Text("Read-Write"),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmailOTPDemo(),
                      ));
                },
                child: Text("Email OTP"),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShareMeDemo(),
                      ));
                },
                child: Text("Share"),
              ),
            ],
          ),
        ));
  }
}
