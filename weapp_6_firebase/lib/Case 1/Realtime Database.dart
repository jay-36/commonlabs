import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:weapp_6_firebase/Case%201/FireStore%20Cloud.dart';
import 'package:weapp_6_firebase/Case%201/Resister.dart';


class RealTimeDatabaseDemo extends StatefulWidget {
  final FirebaseAuth auth;
  RealTimeDatabaseDemo({this.auth});
  @override
  _RealTimeDatabaseDemoState createState() => _RealTimeDatabaseDemoState();
}
class _RealTimeDatabaseDemoState extends State<RealTimeDatabaseDemo> {


  final referenceDatabase = FirebaseDatabase.instance;
  TextEditingController _edit = new TextEditingController();
  String name = '';
  DatabaseReference _std;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final FirebaseDatabase database = FirebaseDatabase();
    _std = database.reference().child('Users');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return showDialog(
          context: context,
          child: new AlertDialog(
            title: const Text("Sign Out"),
            content: Text("Are you sure...?"),
            actions: [
              RaisedButton(
                  child:Text("Cancel"),
                  onPressed: (){
                    Navigator.pop(context);
                  }),
              RaisedButton(
                  child: Text("Signout"),
                  onPressed: () {
                    Navigator.pop(context);
                    widget.auth.signOut().then((value) {
                      Future.delayed(Duration(seconds: 1),(){Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Register(),));});
                    }).catchError((onError){
                      print("Error 1");
                    });
                  })
            ],
          ),
        );

      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("Realtime Database"),
            centerTitle: true,leading: Container(),
            actions: [
              IconButton(
                onPressed: (){
                  showDialog(
                    context: context,
                    child: new AlertDialog(
                      title: const Text("Sign Out"),
                      content: Text("Are you sure...?"),
                      actions: [
                        RaisedButton(
                            child:Text("Cancel"),
                            onPressed: (){
                              Navigator.pop(context);
                            }),
                        RaisedButton(
                            child: Text("Sign out"),
                            onPressed: () {
                              Navigator.pop(context);
                              widget.auth.signOut().then((value) {
                                Future.delayed(Duration(seconds: 1),(){Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Register(),));});
                              }).catchError((onError){
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
            child: Column(
              children: [
                Flexible(
                  child: FirebaseAnimatedList(
                    shrinkWrap: true,
                    query: FirebaseDatabase.instance.reference().child('Users').orderByChild("Key"), 
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      var name = snapshot.value['Name'];
                      var key = snapshot.value['Key'].toString();
                      var key2 = key.substring(1);
                      var email = snapshot.value['Email'];
                      var image = snapshot.value['Image'];
                      return GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateData(name: name,image: image,id: key,realTime : true)));
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
                                  margin: EdgeInsets.only(top: 5,bottom: 5),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(7.0),
                                      child: CachedNetworkImage(
                                        imageUrl: image,fit: BoxFit.cover,
                                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      )),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text("Name : ",style: TextStyle(fontWeight: FontWeight.bold),),
                                        Text(name)
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Email : ",style: TextStyle(fontWeight: FontWeight.bold),),
                                        Text(email)
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Key : ",style: TextStyle(fontWeight: FontWeight.bold),),
                                        Text("$key2",style: TextStyle(fontSize: 10),)
                                      ],
                                    ),

                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [

                                    IconButton(
                                            icon: Icon(Icons.delete),
                                            onPressed: (){
                                              showDialog(
                                                context: context,
                                                child: new AlertDialog(
                                                  title: const Text("Delete"),
                                                  content: Text("Are you sure...?"),
                                                  actions: [
                                                    RaisedButton(
                                                        child:Text("Cancel"),
                                                        onPressed: (){
                                                          Navigator.pop(context);
                                                        }),
                                                    RaisedButton(
                                                        child:Text("Done"),
                                                        onPressed: (){
                                                         _std.child(snapshot.key).remove().then((value){
                                                           Navigator.pop(context);
                                                         }).catchError((onError){
                                                           print("Error 1");
                                                         });
                                                        })
                                                  ],
                                                ),
                                              );
                                            }
                                          ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );

                    },
                  ),
                )
              ],
            ),
          ),
      ),
    );
  }
}
