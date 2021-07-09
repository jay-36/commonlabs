import 'package:flutter/material.dart';
import 'package:weapp_1/Screens/drawer/page1.dart';

import '../../main.dart';
class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Drawer And BottomNavigation"),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(color: Color(0x90000000)),
                child: DrawerHeader(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            // CircleAvatar(child: Icon(Icons.person,size: 50,),radius: 30.0,),
                            CircleAvatar(child: Image.network("https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MXx8aHVtYW58ZW58MHx8MHw%3D&ixlib=rb-1.2.1&w=1000&q=80",fit: BoxFit.cover,),radius: 30.0,),
                            Text("Jay",style: TextStyle(fontSize: 20,color:Colors.white,),)
                          ],
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("+91 743407xxxx",style: TextStyle(fontSize: 17,color: Colors.white),),
                                SizedBox(height: 4,),
                                Text("jaylukhi@gmaiil.com",style: TextStyle(fontSize: 17,color: Colors.white),),

                              ],
                            ),
                          ],
                        )
                      ],
                    )),
              ),
              Card(
                elevation: 5.0,
                child: ListTile(
                  title: Text("Navigation Example"),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Page1(),));
                    // Navigator.pushNamed(context, pageB);
                    // Navigator.pushReplacementNamed(context, pageB);
                    // Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder: (context) => PageB(),), (routes)=>false);
                  },
                ),
              ),
            ],
          ),
        ),
        body: Container()
    );
  }
}
