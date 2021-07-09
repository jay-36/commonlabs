import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weapp_6_firebase/Case%201/FireStore%20Cloud.dart';
import 'package:weapp_6_firebase/Case%201/Realtime%20Database.dart';
import 'package:weapp_6_firebase/Case%201/Loading.dart';
import 'package:weapp_6_firebase/Case%201/Topics.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final referenceDatabase = FirebaseDatabase.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _displayName;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  String error = "";
  String pathImage  = "";
  String uploadImagePath  = "";
  final  _picker = ImagePicker();
  firebase_storage.Reference storage;
  File file;


  @override
  void initState() {
    super.initState();
    print(DateTime.now().microsecondsSinceEpoch);
    _displayName = TextEditingController()..text = "";
    _emailController = TextEditingController()..text = "";
    _passwordController = TextEditingController()..text = "";
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Form(
            key: _formKey,
            child: Card(
              color: Color(0xFF424242),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(error,style: TextStyle(color: Colors.red),),
                      SizedBox(height: 20,),
                      GestureDetector(
                        onTap: ()  async {
                          await _picker.getImage(source: ImageSource.gallery).then((value){
                            setState(() {
                              pathImage = value.path.toString();
                            });
                            print(pathImage);
                          }).catchError((onError){
                            print(onError.message);
                          });

                        },
                        child: Container(
                        height: 100,
                          width: 100,
                          decoration: BoxDecoration(color: Colors.grey),
                          child: pathImage == "" ? Icon(Icons.camera_alt_outlined) : Image.file(File(pathImage),fit: BoxFit.cover,),
                        ),
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: _displayName,
                        decoration: const InputDecoration(labelText: 'Full Name'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        validator: emailValidator,
                      ),
                      SizedBox(height: 20,),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(labelText: 'Password'),
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }else if(value.length < 7){
                            return 'Length Should be at least 7';
                          }
                          return null;
                        },
                        obscureText: true,
                      ),
                      SizedBox(height: 20,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            alignment: Alignment.center,
                            child: OutlineButton(
                              child: Text("FireStore Cloud"),
                              onPressed: ()  async {
                                setState(() {
                                  error = "";
                                });
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  if(pathImage == ""){
                                    setState(() {
                                      error = "Image pick";
                                    });
                                  }else{
                                    handleSubmit(context);
                                    _registerAccountCloudFireStore();
                                  }
                                }
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            alignment: Alignment.center,
                            child: OutlineButton(
                              child: Text("Real Time"),
                              onPressed: () async {
                                setState(() {
                                  error = "";
                                });
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  if(pathImage == ""){
                                    setState(() {
                                      error = "Image pick";
                                    });
                                  }else{
                                    handleSubmit(context);
                                    _registerAccountRealTime();
                                  }
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ),
      ),
    );
  }

  GlobalKey<State> globalKey = new GlobalKey<State>();

  Future<void> handleSubmit(BuildContext context) async {
    try {
      Dialogs.showLoadingDialog(context, globalKey);
    } catch (error) {
      print(error);
    }
  }

  void _registerAccountCloudFireStore() async {
    print("fun");
    storage = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images/${Path.basename(pathImage)}');
    await storage.putFile(File(pathImage),).whenComplete(() async {
      print("put");
      await storage.getDownloadURL().then((imageData) async {
        print("url");
        await _auth
            .createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text).then((value) {
          value.user.updateProfile(photoURL: imageData,displayName: _displayName.text);
          print("Success");
          FirebaseFirestore.instance.collection("Users").doc(value.user.uid).set({
            "Key": value.user.uid,
            "Email": value.user.email,
            "Password" : _passwordController.text,
            "Name" : _displayName.text,
            "Image" : imageData,
            "Date" : "${DateTime.now().microsecondsSinceEpoch}"
          }).then((value){
            print("Add");
            Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
            setState(() {
              error = "";
              _displayName.clear();
              _passwordController.clear();
              _emailController.clear();
            });
            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => FireStoreCloudDemo(auth: _auth)));
          }).catchError((onError){
            Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
            print("Error 4>>");
            print(onError);
          });
        }).catchError((onError){
          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
          print("Error 3>>");
          setState(() {
            error = onError.message;
          });
        });
        print('Url is => ' + imageData);
      }).catchError((onError){

        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        print("Error 2>>");
        setState(() {
          error = onError.message;
        });
      });
    }).catchError((onError){
      Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
      print("Error 1>>");
      setState(() {
        error = onError.message;
      });
    });
  }

  void _registerAccountRealTime() async {
    final ref = referenceDatabase.reference().child("Users");
    DatabaseReference red = ref.child("${-1*DateTime.now().microsecondsSinceEpoch}");
    String newKey = red.key;
    storage = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images/${Path.basename(pathImage)}');
    await storage.putFile(File(pathImage)).whenComplete(() async {
      print("put");
      await storage.getDownloadURL().then((imageData) async {
        print("url");
        await _auth
            .createUserWithEmailAndPassword(
            email: _emailController.text,
            password: _passwordController.text).then((value) {
          value.user.updateProfile(photoURL: imageData,displayName: _displayName.text);
          red.set({
            "Key": int.parse(newKey),
            "Email": value.user.email,
            "Password" : _passwordController.text,
            "Name" : _displayName.text,
            "Image" : imageData
          }).then((value){
            Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
            setState(() {
              error = "";
            });
            _displayName.clear();
            _passwordController.clear();
            _emailController.clear();
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => RealTimeDatabaseDemo(auth: _auth)));
          }).catchError((onError){
            Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
            print("Error 4>>");
            print(onError);
          });
        }).catchError((onError){
          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
          print("Error 3>>");
          setState(() {
            error = onError.message;
          });
        });
        print('Url is => ' + imageData);
      }).catchError((onError){
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        print("Error 2>>");
        setState(() {
          error = onError.message;
        });
      });
    }).catchError((onError){
      Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
      print("Error 1>>");
      setState(() {
        error = onError.message;
      });
    });
  }

}

String emailValidator(val) {
  RegExp emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  if(val.isEmpty){
    return "Enter your email";
  }if (!emailValid.hasMatch(val)) {
    return "Example : jay.lukhi.36@gmail.co";
  } else {
    return null;
  }
}