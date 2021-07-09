import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;

class ProviderClass with ChangeNotifier {
  String _dataUrl = "https://reqres.in/api/users?per_page=20";

  ProviderClass();

  String _displayText = "";
  // String _jsonResponse = "";
  bool _isFetching = false;
  List arraylist = [];

  void setDisplayText(String text) {
    _displayText = text;
    notifyListeners();
  }

  String get getDisplayText => _displayText;

  bool get isFetching => _isFetching;

  Future<void> fetchData() async {
    _isFetching = true;
    notifyListeners();

    var response = await http.get(_dataUrl);
    if (response.statusCode == 200) {
      // _jsonResponse = response.body;
      arraylist.addAll(json.decode(response.body)['data']);
      notifyListeners();
    }

    _isFetching = false;
    notifyListeners();
  }

  // String get getResponseText => _jsonResponse;

  // List<dynamic> getResponseJson() {
  //   if (_jsonResponse.isNotEmpty) {
  //     Map<String, dynamic> json = jsonDecode(_jsonResponse);
  //     arraylist.add(json['data']);
  //     return json['data'];
  //   }
  //   return null;
  // }
}


class ProviderDemo extends StatefulWidget {
  @override
  _ProviderDemoState createState() => _ProviderDemoState();
}
class _ProviderDemoState extends State<ProviderDemo> {

  @override
  Widget build(BuildContext context) {
    final providerState = provider.Provider.of<ProviderClass>(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                RaisedButton(
                  onPressed: () => providerState.fetchData(),
                  child: Text("Fetch Data from Network"),
                ),
                ResponseDisplay(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ResponseDisplay extends StatefulWidget {
  @override
  _ResponseDisplayState createState() => _ResponseDisplayState();
}

class _ResponseDisplayState extends State<ResponseDisplay> {


  @override
  Widget build(BuildContext context) {
    final providerState = provider.Provider.of<ProviderClass>(context);

    // print(providerState.getResponseText.toString());
    print(providerState.arraylist.toString());
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: providerState.isFetching
          ? CircularProgressIndicator()
          : providerState.arraylist != null
          ? ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: providerState.arraylist.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                  providerState.arraylist[index]['avatar']),
            ),
            title: Text(
              providerState.arraylist[index]["first_name"],
            ),
          );
        },
      )
          : Text("Press Button above to fetch data"),
    );
  }
}


