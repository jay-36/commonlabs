import 'package:email_auth/email_auth.dart';
import 'package:flutter/material.dart';

class EmailOTPDemo extends StatefulWidget {
  @override
  _EmailOTPDemoState createState() => _EmailOTPDemoState();
}

class _EmailOTPDemoState extends State<EmailOTPDemo> {

  bool submitValid = false;
  String otpSend = '';
  String otpVerified = '';


  TextEditingController _email = new TextEditingController();
  TextEditingController _otp = new TextEditingController();



  void sendOtp() async {
    EmailAuth.sessionName = "Company Name";
    var result =
    await EmailAuth.sendOtp(receiverMail: _email.text);
    if (result) {
      print('OTP send successfully');
      setState(() {
        otpSend = "OTP send successfully";
      });
    }else{
      print('OTP not sent ! try again');
      setState(() {
        otpSend = "OTP not sent ! try again";
      });
    }
  }

  void verifyOtp()  {
    EmailAuth.sessionName = "Company Name";
    var result =
     EmailAuth.validate(receiverMail: _email.text,userOTP: _otp.text);
    if (result) {
      print('OTP Verified');
      setState(() {
        otpVerified = "OTP Verified";
      });
    }else{
      print('Invalid OTP');
      setState(() {
        otpVerified = "Invalid OTP";
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _email,
             decoration: InputDecoration(
               hintText: 'Email'
             ),
            ),
            TextField(
              controller: _otp,
              decoration: InputDecoration(
                  hintText: 'OTP'
              ),
            ),
            RaisedButton(onPressed: ()=>sendOtp(),child: Text("Send"),),
            RaisedButton(onPressed: ()=>verifyOtp(),child: Text("Verified"),),
            Text(otpSend != null ? otpSend : Container()),
            Text(otpVerified != null ? otpVerified : Container()),

          ],
        ),
      )
    );
  }
}
