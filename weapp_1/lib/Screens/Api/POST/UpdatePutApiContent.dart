import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weapp_1/Screens/Api/POST/AddUser.dart';
import 'package:weapp_1/Screens/Api/POST/GetPostApiContent.dart';

class UpdatePutApiContent extends StatefulWidget {
  final String id;
  String email;
  String name;


  UpdatePutApiContent({this.id,this.name,this.email});



  @override
  _UpdatePutApiContentState createState() => _UpdatePutApiContentState();
}

class _UpdatePutApiContentState extends State<UpdatePutApiContent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String apiResponseText = "";
  AddUser user;
  bool passed = false;
  bool isLoading = false;

   updateData(String name,String email,String id)async{
    Map<String, String> header = {
      "Token":
      'dyGyy4ST5P8:APA91bFDJ_X9qdRcWvdAnXxnrKXU0DlVUpGf5CQez4mLSn9y6vo0qQUslK2Zj2YLO2eEH-x7K6dyf40Ltd5aCGoNs9Kk2ZRx_oCb88D3l_53SVqjhdKlLKz0enqdtvxDN3K0lg_eISlc'
    };
      Map<String, String> params = {
        "name": name,
        "email": email,
      };

      try{
        var response = await http.put("http://192.168.1.17/Practical_Api/api/edit_user_details?user_id=$id",headers: header,body: params);
        if (response.statusCode == 200 && json.decode(response.body)["statusCode"] == 3) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => GetPostApiContent(id: widget.id,) ,), (route) => false);
          return AddUser.fromJson(json.decode(response.body));
        }else if(json.decode(response.body)["statusCode"] == 101) {
          setState(() {
            isLoading = false;
            apiResponseText = "Authentication Error...";
          });
        }else {
          setState(() {
            isLoading = false;
            apiResponseText = "Something went wrong.";
          });
        }
      } on SocketException catch (e) {
        setState(() {
          isLoading = false;
          apiResponseText = "SocketException...";
        });
      } on TimeoutException catch (e) {
        setState(() {
          isLoading = false;
          apiResponseText = "Time out...";
        });
      } on Error catch (e) {
        setState(() {
          isLoading = false;
          apiResponseText = "Something went wrong....";
        });
      }
  }



  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController()..text = widget.name;
    TextEditingController emailController = TextEditingController()..text = widget.email;
    return Scaffold(
      appBar: AppBar(title: Text("PUT"),centerTitle: true,leading: Container(),),
      body: Container(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  child: TextFormField(
                    controller: nameController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter Name",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.teal)),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  child: TextFormField(
                    controller: emailController,
                    validator: emailValidator,
                    decoration: InputDecoration(
                      hintText: "Enter Email",
                      hintStyle: TextStyle(color: Colors.grey),
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.teal)),
                    ),
                  ),
                ),
                RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      isLoading = true;
                      apiResponseText = "";
                      setState(() {});
                      String name = nameController.text;
                      String email = emailController.text;
                      var _user = await updateData(name,email,widget.id);
                      setState(() {
                        user = _user;
                        passed = true;
                      });
                    }
                  },
                  child: Text("Save Data"),
                ),
                isLoading ? Center(child: CircularProgressIndicator()) : Text(apiResponseText,style: TextStyle(color: Colors.red),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}


Function(String) emailValidator = (String val){
  RegExp emailValid = RegExp(
      r"^[a-z0-9.a-z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  if(val.isEmpty){
    return "Email Should Not Empty";
  }else if (!emailValid.hasMatch(val)) {
    return "Example : example@gmail.com";
  } else {
    return null;
  }
};