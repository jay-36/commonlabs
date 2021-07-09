import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:async/async.dart';

import 'package:http_parser/http_parser.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:weapp_1/Screens/Api/GET/ViewApi.dart';
import 'AddUser.dart';

class SubmitPostApiContent extends StatefulWidget {
  @override
  _SubmitPostApiContentState createState() => _SubmitPostApiContentState();
}

class _SubmitPostApiContentState extends State<SubmitPostApiContent> {


  String imgPath = "";
  String error = "";
  bool passed = false;
  bool show = false;
  String userId = "";
  String authorizationToken = 'dyGyy4ST5P8:APA91bFDJ_X9qdRcWvdAnXxnrKXU0DlVUpGf5CQez4mLSn9y6vo0qQUslK2Zj2YLO2eEH-x7K6dyf40Ltd5aCGoNs9Kk2ZRx_oCb88D3l_53SVqjhdKlLKz0enqdtvxDN3K0lg_eISlc';
  bool isLoading = false;
  String apiResponseText = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  AddUser _user;
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();

  // Future<AddUser> submitPostApiData(String name, String email, image) async {
  //   Map<String, String> params = {
  //     "name": name,
  //     "email": email,
  //     "profile_pic": image
  //   };
  //   Map<String, String> header = {
  //     "Token":
  //         'dyGyy4ST5P8:APA91bFDJ_X9qdRcWvdAnXxnrKXU0DlVUpGf5CQez4mLSn9y6vo0qQUslK2Zj2YLO2eEH-x7K6dyf40Ltd5aCGoNs9Kk2ZRx_oCb88D3l_53SVqjhdKlLKz0enqdtvxDN3K0lg_eISlc'
  //   };
  //   var response = await http.post(
  //       "http://192.168.29.72/Practical_Api/api/add_user",
  //       body: params,
  //       headers: header,
  //   );
  //   print(response.body.toString());
  //   return AddUser.fromJson(json.decode(response.body.toString()));
  // }

  @override
  Widget build(BuildContext context) {
    upload(File imageFile, String name, String email) async {
      var stream = new http.ByteStream(
          DelegatingStream.typed(imageFile.openRead()));
      var length = await imageFile.length();
      var uri = Uri.parse("http://192.168.1.17/Practical_Api/api/add_user");
      var request = new http.MultipartRequest("POST", uri);

      Map<String, String> header = {
        "Token":
        'dyGyy4ST5P8:APA91bFDJ_X9qdRcWvdAnXxnrKXU0DlVUpGf5CQez4mLSn9y6vo0qQUslK2Zj2YLO2eEH-x7K6dyf40Ltd5aCGoNs9Kk2ZRx_oCb88D3l_53SVqjhdKlLKz0enqdtvxDN3K0lg_eISlc'
      };
      request.headers.addAll(header);
      request.fields['name'] = name;
      request.fields['email'] = email;

      var multipartFile = new http.MultipartFile('profile_pic', stream, length,
          filename: basename(imageFile.path));

      request.files.add(multipartFile);

      await request.send().then((value2) {

        value2.stream.transform(utf8.decoder).listen((value) {
          print("Done >> ");
          print(value);
          setState(() {
            userId = jsonDecode(value)["data"]["user_id"].toString();
            passed = true;
          });
        });

        isLoading = false;
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => ViewGETApiContent()), (
                route) => false);
      }).catchError((onError) {
        print(onError.message);
        isLoading = false;
        setState(() {
          apiResponseText = onError.toString();
        });
        print("Error 1");
      });
      // response.stream.transform(utf8.decoder).listen((value) {
      //   print("Done >> ");
      //   print(value);
      //   setState(() {
      //     userId = jsonDecode(value)["data"]["user_id"].toString();
      //     passed = true;
      //   });
      // });
    }
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => ViewGETApiContent()), (
                route) => false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("POST"), centerTitle: true, leading: Container(),
        ),
        body: Container(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              children: [
                SizedBox(height: 10,),
                GestureDetector(
                    onTap: () async {
                      var file = await ImagePicker.pickImage(
                          source: ImageSource.gallery);
                      print(file);
                      setState(() {
                        imgPath = file.path;
                        show = false;
                        error = "";
                      });
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(100.0)
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: imgPath == ""
                              ? Center(child: Text("pick"))
                              : Image.file(
                            File(imgPath), fit: BoxFit.cover,)),)
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                    if (imgPath != "") {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        apiResponseText = "";
                        isLoading = true;
                        setState(() {});
                        String name = nameController.text;
                        String email = emailController.text;
                        final AddUser user = await upload(File(imgPath),name,email);
                        setState(() {
                          _user = user;
                        });
                      }
                    } else {
                      setState(() {
                        error = "Pick image";
                        show = true;
                      });
                    }
                  },
                  child: Text("Submit"),
                ),
                show ? Text(
                  '$error', style: TextStyle(color: Colors.red),) : SizedBox(),
                SizedBox(height: 20),
                isLoading ? Center(child: CircularProgressIndicator()) : Text(apiResponseText,style: TextStyle(color: Colors.red),),
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