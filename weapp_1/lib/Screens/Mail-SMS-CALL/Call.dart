import 'dart:async';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CallDemo extends StatefulWidget {

  @override
  _CallDemoState createState() => _CallDemoState();
}

class _CallDemoState extends State<CallDemo> {
  String _phone = '';
  final _formKey = GlobalKey<FormState>();

  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Call"),centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            if(_formKey.currentState.validate())
              _formKey.currentState.save();
            setState(() {
              _phone = phoneController.text;
            });
            launch("tel://$_phone");
          });
        },
        child: Icon(Icons.call),
      ),
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Form(
              key: _formKey,
              autovalidate: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextFormField(
                      controller: phoneController,
                      maxLength: 10,
                      validator: phoneValidator,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            counter: Offstage(),
                            hintText: 'Enter The Phone Number')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String phoneValidator(val){
  RegExp phoneValid = RegExp(r"^[0-9]");
  if(!phoneValid.hasMatch(val)){
    return "Example : 0123456789";
  }else if(val.length < 10){
   return "Enter Atleast 10 Digits";
  } else{
    return null;
  }
}
