import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weapp_1/Screens/Api/POST/AddUser.dart';
import 'package:http/http.dart' as http;

class DeleteApiContent extends StatefulWidget {
  @override
  _DeleteApiContentState createState() => _DeleteApiContentState();
}

class _DeleteApiContentState extends State<DeleteApiContent> {

  AddUser user;
  bool passed = false;
  TextEditingController idController = TextEditingController();

  Future<AddUser> deleteApiById(String id) async {
    Map<String, String> header = {
      "Token":
      'dyGyy4ST5P8:APA91bFDJ_X9qdRcWvdAnXxnrKXU0DlVUpGf5CQez4mLSn9y6vo0qQUslK2Zj2YLO2eEH-x7K6dyf40Ltd5aCGoNs9Kk2ZRx_oCb88D3l_53SVqjhdKlLKz0enqdtvxDN3K0lg_eISlc'
    };
    var response = await http.delete(
        "http://192.168.29.72/Practical_Api/api/delete_user?user_id=$id",
        headers: header);
    print(response.body.toString());
    return AddUser.fromJson(json.decode(response.body.toString()));
  }
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get Data From Post Api"),
        centerTitle: true,
      ),
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
                    controller: idController,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter user id';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "Enter Id",
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
                      String id = idController.text.toString();
                      var _user = await deleteApiById(id);
                      setState(() {
                        user = _user;
                        passed = true;
                      });
                    }
                  },
                  child: Text("Delete Data"),
                ),
                passed ? Text('User Id : ${idController.text.toString()}  Is  Successfully  Deleted') : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
