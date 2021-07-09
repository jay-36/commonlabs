import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:weapp_6_firebase/Case%201/Loading.dart';
import 'package:weapp_6_firebase/Case%201/Resister.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;

class FireStoreCloudDemo extends StatefulWidget {
  final FirebaseAuth auth;

  FireStoreCloudDemo({this.auth});

  @override
  _FireStoreCloudDemoState createState() => _FireStoreCloudDemoState();
}

class _FireStoreCloudDemoState extends State<FireStoreCloudDemo> {
  TextEditingController _editName = new TextEditingController();
  final fireStoreInstance = FirebaseFirestore.instance;

  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("Users");

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return showDialog(
          context: context,
          child: new AlertDialog(
            title: const Text("Sign Out"),
            content: Text("Are you sure...?"),
            actions: [
              RaisedButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              RaisedButton(
                child: Text("Signout"),
                onPressed: () {
                  Navigator.pop(context);
                  widget.auth.signOut().then((value) {
                    Future.delayed(Duration(seconds: 1), () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => Register(),
                      ));
                    });
                  }).catchError((onError) {
                    print("Error 1");
                  });
                },
              )
            ],
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("FireStore Cloud"),
          centerTitle: true,
          leading: Container(),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  child: new AlertDialog(
                    title: const Text("Sign Out"),
                    content: Text("Are you sure...?"),
                    actions: [
                      RaisedButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      RaisedButton(
                          child: Text("Sign out"),
                          onPressed: () {
                            Navigator.pop(context);
                            widget.auth.signOut().then((value) {
                              Future.delayed(Duration(seconds: 1), () {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) => Register(),
                                ));
                              });
                            }).catchError((onError) {
                              print("Error 1");
                            });
                          })
                    ],
                  ),
                );
              },
              icon: Icon(Icons.logout),
            )
          ],
        ),
        body: Container(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .orderBy("Date", descending: true)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) return Text("Error : ${snapshot.error}");
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Text("Loading..");
                default:
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (_, int index) {
                      var name = snapshot.data.docs[index]["Name"];
                      var key = snapshot.data.docs[index]["Key"];
                      var email = snapshot.data.docs[index]["Email"];
                      var image = snapshot.data.docs[index]["Image"].toString();
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateData(
                                      name: name,
                                      image: image,
                                      id: key,
                                      realTime: false)));
                        },
                        child: Card(
                          child: Container(
                            height: 100,
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  width: 90,
                                  height: 90,
                                  margin: EdgeInsets.only(top: 5, bottom: 5),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(7.0),
                                      child: CachedNetworkImage(
                                        imageUrl: image,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Center(
                                            child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      )),
                                ),
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Name : ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(name)
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Email : ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(email)
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Key : ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          key,
                                          style: TextStyle(fontSize: 10),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // IconButton(
                                    //   icon: Icon(Icons.edit),
                                    //   onPressed: (){
                                    //     _editName.text = name;
                                    //     showDialog<String>(
                                    //       context: context,
                                    //       child: AlertDialog(
                                    //         title: Text("Update Data"),
                                    //         content: SingleChildScrollView(
                                    //           child: Column(
                                    //             children: [
                                    //               TextField(
                                    //                 controller: _editName,
                                    //                 decoration: InputDecoration(hintText: "Edit Name"),
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ),
                                    //         actions: [
                                    //           RaisedButton(
                                    //               onPressed: () async {
                                    //                 QuerySnapshot querySnapshot = await collectionReference.get();
                                    //                 querySnapshot.docs[index].reference.update({
                                    //                   'Name' : _editName.text,
                                    //                 });
                                    //                 _editName.clear();
                                    //                 Navigator.pop(context);
                                    //               },
                                    //               child: Text("Update Data"))
                                    //         ],
                                    //       ),
                                    //     );
                                    //   },
                                    // ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () async {
                                        QuerySnapshot qs =
                                            await collectionReference.get();
                                        showDialog(
                                          context: context,
                                          child: new AlertDialog(
                                            title: const Text("Delete"),
                                            content: Text("Are you sure...?"),
                                            actions: [
                                              RaisedButton(
                                                  child: Text("Cancel"),
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  }),
                                              RaisedButton(
                                                  child: Text("Done"),
                                                  onPressed: () {
                                                    qs.docs[index].reference
                                                        .delete()
                                                        .then((value) {
                                                      Navigator.pop(context);
                                                    }).catchError((onError) {
                                                      print("Error 1");
                                                    });
                                                  })
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                      // return Card(
                      //   elevation: 5.0,
                      //   child: ListTile(
                      //     leading: IconButton(
                      //       icon: Icon(Icons.edit),
                      //       onPressed: (){
                      //         _editName.text = name;
                      //         showDialog<String>(
                      //             context: context,
                      //             child: AlertDialog(
                      //               title: Text("Update Data"),
                      //               content: SingleChildScrollView(
                      //                 child: Column(
                      //                   children: [
                      //                     TextField(
                      //                       controller: _editName,
                      //                       decoration: InputDecoration(hintText: "Edit Name"),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //               actions: [
                      //                 RaisedButton(
                      //                     onPressed: () async {
                      //                       QuerySnapshot querySnapshot = await collectionReference.get();
                      //                       querySnapshot.docs[index].reference.update({
                      //                         'Name' : _editName.text,
                      //                       });
                      //                       _editName.clear();
                      //                       Navigator.pop(context);
                      //                     },
                      //                     child: Text("Update Data"))
                      //               ],
                      //             ),
                      //         );
                      //       },
                      //     ),
                      //     trailing: IconButton(
                      //       icon: Icon(Icons.delete),
                      //       onPressed: ()async{
                      //         QuerySnapshot qs = await collectionReference.get();
                      //         showDialog(
                      //           context: context,
                      //           child: new AlertDialog(
                      //             title: const Text("Delete"),
                      //             content: Text("Are you sure...?"),
                      //             actions: [
                      //               RaisedButton(
                      //                   child:Text("Cancel"),
                      //                   onPressed: (){
                      //                     Navigator.pop(context);
                      //                   }),
                      //               RaisedButton(
                      //                   child:Text("Done"),
                      //                   onPressed: (){
                      //                     qs.docs[index].reference.delete().then((value){
                      //                       Navigator.pop(context);
                      //                     }).catchError((onError){
                      //                       print("Error 1");
                      //                     });
                      //                   })
                      //             ],
                      //           ),
                      //         );
                      //       },
                      //     ),
                      //     title: Text(name),
                      //     subtitle: Column(
                      //       mainAxisAlignment: MainAxisAlignment.start,
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(key,style:TextStyle(fontSize:10)),
                      //         Text(email,style:TextStyle(fontSize:10)),
                      //       ],
                      //     ),
                      //   ),
                      // );
                    },
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}

class UpdateData extends StatefulWidget {
  final String id;
  final String name;
  final String image;
  final bool realTime;

  UpdateData({this.name, this.id, this.image, this.realTime});

  @override
  _UpdateDataState createState() => _UpdateDataState();
}

class _UpdateDataState extends State<UpdateData> {
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("Users");

  String pathImage = "";
  String error = "";
  String uploadImagePath = "";
  final ImagePicker _picker = ImagePicker();
  firebase_storage.Reference storage;
  TextEditingController editName;
  String nameUpdate = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    editName = TextEditingController()..text = widget.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Update"),
        ),
        body: Container(
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  print("s");
                  final pick =
                      await _picker.getImage(source: ImageSource.gallery);
                  setState(() {
                    pathImage = pick.path;
                  });
                },
                child: Container(
                  width: 150,
                  height: 150,
                  margin: EdgeInsets.all(10),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: pathImage == ""
                      ? CachedNetworkImage(
                    imageUrl: widget.image,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                        child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error),
                  )
                      : Image.file(File(pathImage), fit: BoxFit.cover),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: TextFormField(
                  controller: editName,
                  onChanged: (val) {
                    setState(() {
                      nameUpdate = val;
                    });
                  },
                ),
              ),
              RaisedButton(
                onPressed: () async {
                  handleSubmit(context);
                  widget.realTime
                      ? uploadDataRealTime()
                      : uploadDataFireStoreCloud();
                },
                child: Text("Update"),
              )
            ],
          ),
        ));
  }

  GlobalKey<State> globalKey = new GlobalKey<State>();

  Future<void> handleSubmit(BuildContext context) async {
    try {
      Dialogs.showLoadingDialog(context, globalKey);
      Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
    } catch (error) {
      print(error);
    }
  }

  Future<void> uploadDataFireStoreCloud() async {
    if (pathImage != "") {
      storage = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(pathImage)}');
      await storage.putFile(File(pathImage)).whenComplete(() async {
        await storage.getDownloadURL().then((imageData) async {
          FirebaseFirestore.instance.collection("Users").doc(widget.id).update(
              {"Name": editName.text, "Image": imageData}).then((value) {
            Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
            Navigator.pop(context);
          }).catchError((onError) {
            Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
            print("Error 3>>");
            setState(() {
              error = onError.message;
            });
          });
        }).catchError((onError) {
          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
          print("Error 2>>");
          setState(() {
            error = onError.message;
          });
        });
      }).catchError((onError) {
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        print("Error 1>>");
        setState(() {
          error = onError.message;
        });
      });
    } else {
      FirebaseFirestore.instance.collection("Users").doc(widget.id).update({
        "Name": editName.text,
      }).then((value) {
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Navigator.pop(context);
      }).catchError((onError) {
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        print("Error 3>>");
        setState(() {
          error = onError.message;
        });
      });
    }
  }

  Future<void> uploadDataRealTime() async {
    if (pathImage != "") {
      storage = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(pathImage)}');
      await storage.putFile(File(pathImage)).whenComplete(() async {
        await storage.getDownloadURL().then((imageData) async {
          FirebaseDatabase.instance
              .reference()
              .child('Users')
              .child(widget.id)
              .update({"Name": editName.text,"Image" : imageData}).then((value) {
            Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
            Navigator.pop(context);
          }).catchError((onError) {
            Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
            print("Error 3>>");
            setState(() {
              error = onError.message;
            });
          });
        }).catchError((onError) {
          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
          print("Error 2>>");
          setState(() {
            error = onError.message;
          });
        });
      }).catchError((onError) {
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        print("Error 1>>");
        setState(() {
          error = onError.message;
        });
      });
    } else {
      print("s");

      FirebaseDatabase.instance
          .reference()
          .child('Users')
          .child(widget.id)
          .update({"Name": editName.text}).then((value) {
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        Navigator.pop(context);
      }).catchError((onError) {
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
        print("Error 3>>");
        setState(() {
          error = onError.message;
        });
      });
    }
  }
}
