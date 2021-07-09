import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:weapp_1/Screens/Api/GET/ViewApi.dart';
import 'package:weapp_1/Screens/Api/POST/AddUser.dart';
import 'package:http/http.dart' as http;
import 'package:weapp_1/Screens/Api/POST/UpdatePutApiContent.dart';

class GetPostApiContent extends StatefulWidget {

  final String id;
  GetPostApiContent({this.id});

  @override
  _GetPostApiContentState createState() => _GetPostApiContentState();
}

class _GetPostApiContentState extends State<GetPostApiContent> {

  String apiResponseText = "Loading...";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // fetchData(widget.id);
  }

  Future<AddUser> getPostApiData(String id) async {
    Map<String, String> header = {
      "Token":
          'dyGyy4ST5P8:APA91bFDJ_X9qdRcWvdAnXxnrKXU0DlVUpGf5CQez4mLSn9y6vo0qQUslK2Zj2YLO2eEH-x7K6dyf40Ltd5aCGoNs9Kk2ZRx_oCb88D3l_53SVqjhdKlLKz0enqdtvxDN3K0lg_eISlc'
    };

    var response = await http.post(
        "http://192.168.1.17/Practical_Api/api/get_user_details?user_id=$id",
        headers: header).catchError((onError){
      setState(() {
        isLoading = false;
        apiResponseText = onError;
      });
    });
    if (response.statusCode == 200 && json.decode(response.body)["statusCode"] == 3) {
      return AddUser.fromJson(json.decode(response.body.toString()));
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




    return AddUser.fromJson(json.decode(response.body.toString()));
  }

  deleteApiById(String id) async {
    Map<String, String> header = {
      "Token":
      'dyGyy4ST5P8:APA91bFDJ_X9qdRcWvdAnXxnrKXU0DlVUpGf5CQez4mLSn9y6vo0qQUslK2Zj2YLO2eEH-x7K6dyf40Ltd5aCGoNs9Kk2ZRx_oCb88D3l_53SVqjhdKlLKz0enqdtvxDN3K0lg_eISlc'
    };

    try{
      var response = await http.delete(
          "http://192.168.1.17/Practical_Api/api/delete_user?user_id=$id",
          headers: header);
      print(json.decode(response.body)["statusCode"]);
      if (response.statusCode == 200 && json.decode(response.body)["statusCode"] == 3) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ViewGETApiContent()));
        return AddUser.fromJson(json.decode(response.body.toString()));
      }else if(json.decode(response.body)["statusCode"] == 101) {
        setState(() {
          apiResponseText = "Authentication Error...";
        });
      }else {
        setState(() {
          apiResponseText = "Something went wrong...";
        });
      }
    } on SocketException catch (e) {
      setState(() {
        apiResponseText = "Something went wrong..";
      });
    } on TimeoutException catch (e) {
      setState(() {
        apiResponseText = "Something went wrong...";
      });
    } on Error catch (e) {
      setState(() {
        apiResponseText = "Something went wrong....";
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => ViewGETApiContent()), (route) => false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Get Data From Post Api"),
          centerTitle: true,leading: Container(),
        ),
        body: Container(
          child: fetchData(widget.id)
        ),
      ),
    );
  }

  FutureBuilder<AddUser> fetchData(idController) {
    return FutureBuilder<AddUser>(
        future: getPostApiData(idController),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  dataListTile(snapshot),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePutApiContent(id: widget.id,email: snapshot.data.data.email,name: snapshot.data.data.name,)));
                      },child: Text("Update"),),
                      RaisedButton(onPressed: (){
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          child: new AlertDialog(
                            title: const Text("Delete"),content: Text("Are you sure...?"),
                            actions: [
                              RaisedButton(
                                  child: Text("Cancel"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              RaisedButton(
                                  child: Text("Done"),
                                  onPressed: () {
                                    deleteApiById(widget.id);
                                  })
                            ],
                          ),
                        );

                      },child: Text("Delete"),),
                    ],
                  )
                ],
              ),
            );
          } else if (snapshot.hasData) {
            return Text('${snapshot.error}');
          }
          return isLoading ? Center(child: CircularProgressIndicator()) : Center(child: Text(apiResponseText));
        });
  }

  Container dataListTile(AsyncSnapshot<AddUser> snapshot) {
    return Container(
      height: 300,
          width: 300,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(snapshot.data.data.profile_pic,fit: BoxFit.cover,),
          Container(
            decoration: BoxDecoration(
              color: Color(0x70000000)
            ),
          ),
          Positioned(
              bottom: 15,
              left: 15,
              child: CircleAvatar(backgroundImage: NetworkImage(snapshot.data.data.profile_pic),radius: 26,)),
          Positioned(
              bottom: 37,
              left: 80,
              child: Text(snapshot.data.data.name,style: TextStyle(fontSize: 29,fontWeight: FontWeight.w500),)),
          Positioned(
              bottom: 19,
              left: 80,
              child: Text(snapshot.data.data.email,style: TextStyle(fontSize: 16,color: Colors.white70),)),
          Positioned(
              top:10,
              right: 10,
              child: Text('${snapshot.data.data.user_id}',style: TextStyle(fontSize: 30,color: Colors.white),)),
          Positioned(
              bottom:5,
              right: 10,
              child: Text('${snapshot.data.data.created_at}',style: TextStyle(fontSize: 13,color: Colors.white70),)),
        ],
      ),
    );
  }
}
