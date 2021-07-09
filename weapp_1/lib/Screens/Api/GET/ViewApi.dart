import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart' as provider;
import 'package:weapp_1/Button.dart';
import 'package:weapp_1/Screens/Api/GET/UserDetail.dart';
import 'package:weapp_1/Screens/Api/ApiList.dart';
import 'package:weapp_1/Screens/Api/POST/GetPostApiContent.dart';
import 'package:weapp_1/Screens/Api/POST/SubmitPostApiContent.dart';

// if (value.statusCode == 200) {
//     setState(() {
//       listArray.addAll(json.decode(value.body)['data']);
//     });
//     print(listArray.toString());
//   }

class ViewGETApiContent extends StatefulWidget {
  @override
  _ViewGETApiContentState createState() => _ViewGETApiContentState();
}

class _ViewGETApiContentState extends State<ViewGETApiContent> {
  bool _isFetching = false;
  List listArray = [];
  String apiResponseText = "";
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    _isFetching = true;
    Map<String, String> header = {
      "Token":
          'dyGyy4ST5P8:APA91bFDJ_X9qdRcWvdAnXxnrKXU0DlVUpGf5CQez4mLSn9y6vo0qQUslK2Zj2YLO2eEH-x7K6dyf40Ltd5aCGoNs9Kk2ZRx_oCb88D3l_53SVqjhdKlLKz0enqdtvxDN3K0lg_eISlc'
    };
    try {
      var response = await http.get(
          "http://192.168.1.17/Practical_Api/api/get_user_list",
          headers: header);

      if (response.statusCode == 200 &&
          json.decode(response.body)["statusCode"] == 3) {
        setState(() {
          isLoading = false;
          listArray.addAll(json.decode(response.body)['data']);
        });
      } else if (json.decode(response.body)["statusCode"] == 101) {
        setState(() {
          isLoading = false;
          apiResponseText = "Authentication Error...";
        });
        print("Authentication Error : 101");
      } else {
        setState(() {
          isLoading = false;
          apiResponseText = "Something went wrong.";
        });
        throw HttpException('${response.statusCode}');
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
    _isFetching = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => FirstPageButtonExamples()),
            (route) => false);
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("GET"),
            centerTitle: true,
            leading: Container(),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SubmitPostApiContent()));
            },
            child: Icon(Icons.add),
          ),
          // body: listArray.length == 0 ?
          // isLoading ? CircularProgressIndicator() :
          //      Center(child: Text(apiResponseText,style: TextStyle(color: Colors.red),))
          //     : Container(
          //         child: ListView.builder(
          //           primary: false,
          //           shrinkWrap: true,
          //           itemCount: listArray.length,
          //           itemBuilder: (context, index) {
          //             return GestureDetector(
          //               onTap: () {
          //                 Navigator.push(
          //                     context,
          //                     MaterialPageRoute(
          //                       builder: (context) => GetPostApiContent(
          //                           id: listArray[index]['user_id'].toString()),
          //                     ));
          //               },
          //               child: Card(
          //                 elevation: 5.0,
          //                 child: Container(
          //                   height: 100,
          //                   width: double.infinity,
          //                   child: Stack(
          //                     children: [
          //                       Positioned(
          //                         top: 9,
          //                         left: 10,
          //                         child: CircleAvatar(
          //                           backgroundImage: NetworkImage(
          //                               listArray[index]['profile_pic']),
          //                           radius: 40,
          //                         ),
          //                       ),
          //                       Positioned(
          //                         bottom: 3,
          //                         left: 60,
          //                         child: CircleAvatar(
          //                           radius: 17,
          //                           backgroundColor: Color(0x50000000),
          //                           child: Text(
          //                             '${listArray[index]['user_id']}',
          //                             style: TextStyle(color: Colors.white),
          //                           ),
          //                         ),
          //                       ),
          //                       Positioned(
          //                           top: 20,
          //                           left: 110,
          //                           child: Text(
          //                             listArray[index]['name'],
          //                             style: TextStyle(
          //                                 fontSize: 30,
          //                                 fontWeight: FontWeight.w500),
          //                           )),
          //                       Positioned(
          //                           top: 60,
          //                           left: 110,
          //                           child: Text(
          //                             listArray[index]['email'],
          //                             style: TextStyle(
          //                                 fontSize: 17, color: Colors.white70),
          //                           )),
          //                       Positioned(
          //                           bottom: 5,
          //                           right: 10,
          //                           child: Text(
          //                             listArray[index]['created_at'],
          //                             style: TextStyle(
          //                                 fontSize: 13, color: Colors.white70),
          //                           )),
          //                     ],
          //                   ),
          //                 ),
          //               ),
          //             );
          //           },
          //         ),
          //       )
          body: isLoading
              ? Center(child: CircularProgressIndicator())
              : apiResponseText != ""
                  ? Center(
                      child: Text(
                      apiResponseText,
                      style: TextStyle(color: Colors.red),
                    ))
                  : listArray.length == 0
                      ? Text("No More Data")
                      : Container(
            child: ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: listArray.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GetPostApiContent(
                              id: listArray[index]['user_id'].toString()),
                        ));
                  },
                  child: Card(
                    elevation: 5.0,
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 9,
                            left: 10,
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  listArray[index]['profile_pic']),
                              radius: 40,
                            ),
                          ),
                          Positioned(
                            bottom: 3,
                            left: 60,
                            child: CircleAvatar(
                              radius: 17,
                              backgroundColor: Color(0x50000000),
                              child: Text(
                                '${listArray[index]['user_id']}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Positioned(
                              top: 20,
                              left: 110,
                              child: Text(
                                listArray[index]['name'],
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500),
                              )),
                          Positioned(
                              top: 60,
                              left: 110,
                              child: Text(
                                listArray[index]['email'],
                                style: TextStyle(
                                    fontSize: 17, color: Colors.white70),
                              )),
                          Positioned(
                              bottom: 5,
                              right: 10,
                              child: Text(
                                listArray[index]['created_at'],
                                style: TextStyle(
                                    fontSize: 13, color: Colors.white70),
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          )
      ),
    );
  }
}

class GetProvider extends ChangeNotifier {
  GetProvider();

  bool _isFetching = false;
  List listArray = [];

  bool get isFetching => _isFetching;
}

class FetchDataException extends AppException {
  FetchDataException([String message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppException {
  InvalidInputException([String message]) : super(message, "Invalid Input: ");
}

class AppException implements Exception {
  final _message;
  final _prefix;

  AppException([this._message, this._prefix]);

  String toString() {
    return "$_prefix$_message";
  }
}
