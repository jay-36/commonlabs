import 'dart:convert';

import 'package:flutter/material.dart';
import 'student.dart';

class ViewJsonData extends StatefulWidget {
  @override
  ViewJsonDataState createState() => ViewJsonDataState();
}

class ViewJsonDataState extends State<ViewJsonData> {
  // List data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Load Json'),
      ),
      body: FutureBuilder(
        future: DefaultAssetBundle.of(context).loadString('assets/student.json'),
        builder: (context, snapshot) {
          var myData = json.decode(snapshot.data.toString());

            return ListView.builder(
                itemCount: myData == null ? 0 : myData.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                      elevation: 5.0,
                      child: ListTile(
                        onTap: () {},
                        title:  Text('Name : ' + myData[index]['studentName']),
                        trailing:  Text('Scores : ' + myData[index]['studentScores']),
                        leading: Text('Id : ' + myData[index]['studentId']),
                      ));
                });
        },
      ),
    );
  }
}
