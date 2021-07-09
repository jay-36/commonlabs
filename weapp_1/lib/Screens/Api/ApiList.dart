import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:weapp_1/Screens/Api/POST/DeleteApiContent.dart';
import 'package:weapp_1/Screens/Api/POST/UpdatePutApiContent.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart' as provider;
import 'GET/ViewApi.dart';
import 'POST/GetPostApiContent.dart';
import 'POST/SubmitPostApiContent.dart';

class ApiList extends StatefulWidget {
  @override
  _ApiListState createState() => _ApiListState();
}

class _ApiListState extends State<ApiList> {

  int counter = 0;

  @override
  Widget build(BuildContext context) {
    final providerState = provider.Provider.of<GetProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("API Types"),centerTitle: true,),
      body: Container(
        height: double.infinity,
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
                        builder: (context) => ViewGETApiContent()
                      ));
                },
                child: Text("GET")),
            RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubmitPostApiContent(),
                      ));
                },
                child: Text("POST Submit")),
            RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GetPostApiContent(),
                      ));
                },
                child: Text("POST Get")),
            RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdatePutApiContent(),
                      ));
                },
                child: Text("PUT Update")),
            RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeleteApiContent(),
                      ));
                },
                child: Text("DELETE Data")),
          ],
        ),
      ),
    );
  }
}



