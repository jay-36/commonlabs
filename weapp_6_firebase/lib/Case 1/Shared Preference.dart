import 'dart:convert';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weapp_6_firebase/Case%201/Topics.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   var email = prefs.getString('email');
//   print(email);
//   runApp(MaterialApp(home: email == null ? NewPage() : Home()));
// }

class SharedPreferenceDemo extends StatefulWidget {
  @override
  _SharedPreferenceDemoState createState() => _SharedPreferenceDemoState();
}

class _SharedPreferenceDemoState extends State<SharedPreferenceDemo> {
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String path = "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text("Shared Preference"),centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: <Widget>[

            Container(
              height: 100,
              width: 100,
              child: Image.file(File(path),fit: BoxFit.cover,),
            ),

            Container(
              child: const Text(
                'Enter Something Here...',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              alignment: Alignment.center,
            ),
            SizedBox(height: 10),
            RaisedButton(
              onPressed: () async {
                final pickedFile = await _picker.getImage(source: ImageSource.gallery);
                print(pickedFile.path);
                print(json.encode(pickedFile.path));
                setState(() {
                  path = pickedFile.path;
                });

              },child: Text("Pick Image"),
            ),
            Form(
              key: _formKey,
              autovalidate: true,
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 20),
                validator: textValidator,
                decoration: InputDecoration(
                  hintText: "Enter Something..",
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ),
            ),
            SizedBox(height: 10),
            RaisedButton(
                onPressed: () async {
                    if(_formKey.currentState.validate())
                     {
                       _formKey.currentState.save();
                       SharedPreferences prefs = await SharedPreferences.getInstance();
                       prefs.setString('email', _emailController.text);
                       prefs.setString('image', path);
                       Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home()), (route) => false);
                     }
                },
                child: Text("Go.."))
          ],
        ),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  FirebaseAnalytics analytics = FirebaseAnalytics();
 var email = "";
 var image = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getShared();
  }

  void getShared() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email');
    image = prefs.getString('image');
    print(email);
    print(image);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                height: 100,
                width: 100,
                child: Image.file(File(image),fit: BoxFit.cover,)),
            Text(email),
            SizedBox(height: 20,),
            RaisedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.remove('email');
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext ctx) => Topics(analytics: analytics)));
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}


String textValidator(val){
  if (val.isEmpty) {
    return "Empty is not valid";
  } else {
    return null;
  }
}
