import 'package:flutter/material.dart';
import 'package:weapp_6_firebase/Case%201/Mail-SMS-CALL/Call.dart';
import 'package:weapp_6_firebase/Case%201/Mail-SMS-CALL/Email.dart';
import 'package:weapp_6_firebase/Case%201/Mail-SMS-CALL/SMS.dart';

class EmailCallSMSButton extends StatefulWidget {
  @override
  _EmailCallSMSButtonState createState() => _EmailCallSMSButtonState();
}

class _EmailCallSMSButtonState extends State<EmailCallSMSButton> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SmsDemo(),
                          ));
                    },
                    child: Text("SMS"),
                  ),
                  RaisedButton(
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DirectSmsDemo(),
                          ));
                    },
                    child: Text("SMS Direct"),
                  ),
                ],
              ),
              RaisedButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CallDemo(),
                      ));
                },
                child: Text("Call"),
              ),
              RaisedButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EmailDemo(),
                      ));
                },
                child: Text("Email"),
              ),
            ],
          ),
        )
    );
  }
}
