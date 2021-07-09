import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:weapp_1/Screens/Widgets/Images.dart';


class WidgetsDemo extends StatefulWidget {
  @override
  _WidgetsDemoState createState() => _WidgetsDemoState();
}

class _WidgetsDemoState extends State<WidgetsDemo> {
  String _base64;

  @override
  void initState() {
    super.initState();
    (() async {
      http.Response response = await http.get(
        'https://thebhakti.com/wp-content/uploads/2019/01/mahakal.jpg',
      );
      if (mounted) {
        setState(() {
          _base64 = Base64Encoder().convert(response.bodyBytes);
        });
      }
    })();
  }



  @override
  Widget build(BuildContext context) {
    if (_base64 == null)
      return new Container();
    Uint8List bytes = Base64Codec().decode(_base64);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 100,
        toolbarOpacity: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.elliptical(300, 40),
          ),
        ),
        elevation: 5.0,
        shadowColor: Colors.red,
        title: Text("AppBar"),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Flexible(
            child: Image.network(
              "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MXx8aHVtYW58ZW58MHx8MHw%3D&ixlib=rb-1.2.1&w=1000&q=80",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black54,
          ),
          Align(
              alignment: AlignmentDirectional.bottomCenter,
              child: Container(
                  height: 150,
                  child: Stack(
                    children: [
                      Image.asset(
                        "assets/jay.png",
                      ),
                      Text(
                        "Image.Assets",
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ))),
          Align(
            alignment: AlignmentDirectional.bottomStart,
            child: CircleAvatar(
              radius: 70.0,
              backgroundImage: NetworkImage(
                  "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MXx8aHVtYW58ZW58MHx8MHw%3D&ixlib=rb-1.2.1&w=1000&q=80"),
              child: Text("NetworkImage"),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: CircleAvatar(
              radius: 70.0,
              backgroundImage: AssetImage("assets/jay.png"),
              child: Text(
                "AssetImage",
              ),
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Container(
              height: 180.0,
              child: Column(
                  children: [
                    Container(
                      height: 150,
                        child: Image.memory(bytes)),
                    Text("Image.Memory",style: TextStyle(fontSize:15,color: Colors.white,fontWeight: FontWeight.w500),)
                  ],)
            ),
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: CircleAvatar(
              radius: 60.0,
              backgroundImage: MemoryImage(bytes),
              child: Text(
                "MemoryImage",
              ),
            ),
          ),
          Center(
            heightFactor: 5,
            widthFactor: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 100,
                  width: 180,
                  // foregroundDecoration: BoxDecoration(
                  //   color: Colors.blue
                  // ),
                  // child: Text(
                  //   "Container",
                  //   textAlign: TextAlign.end,
                  //   overflow: TextOverflow.visible,
                  //   semanticsLabel: "aaa",
                  //   softWrap: true,
                  //   strutStyle: StrutStyle.fromTextStyle(TextStyle(
                  //     fontSize: 15,
                  //     height: 1.7,
                  //   )),
                  //   style: TextStyle(
                  //       fontSize: 25,
                  //       fontFamily: 'Exo2',
                  //       // decoration: TextDecoration.underline,
                  //       // backgroundColor: Colors.red[200],
                  //       // decorationStyle: TextDecorationStyle.dashed,
                  //       // fontWeight: FontWeight.w500,
                  //       fontStyle: FontStyle.italic,
                  //       // inherit: false,
                  //       decorationThickness: 5.0,
                  //       height: 2.0,
                  //       shadows: <Shadow>[
                  //         Shadow(
                  //           offset: Offset(10.0, 10.0),
                  //           blurRadius: 3.0,
                  //           color: Color.fromARGB(255, 0, 0, 0),
                  //         ),
                  //       ]),
                  // ),
                  decoration: BoxDecoration(color: Colors.redAccent),
                  // alignment: Alignment.center,
                  child: Text.rich(
                    TextSpan(
                      text: '       he candle flickered\n',
                      style: TextStyle(fontSize: 14, fontFamily: 'Exo2'),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'T',
                          style: TextStyle(fontSize: 37, fontFamily: 'Exo2'),
                        ),
                        TextSpan(
                          text: 'in the moonlight as\n',
                          style: TextStyle(fontSize: 14, fontFamily: 'Exo2'),
                        ),
                        TextSpan(
                          text: 'Dash the bird fluttered\n',
                          style: TextStyle(fontSize: 14, fontFamily: 'Exo2'),
                        ),
                        TextSpan(
                          text: 'off into the distance.',
                          style: TextStyle(fontSize: 14, fontFamily: 'Exo2'),
                        ),
                      ],
                    ),
                  ),
                  transform: Matrix4.rotationZ(0.1),
                  constraints: BoxConstraints.loose(Size.infinite),
                  clipBehavior: Clip.hardEdge,
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 200,
            left: 150,
            right: 150,
            child: RaisedButton(
              color: Colors.green,
              highlightColor: Colors.red,
              // focusColor: Colors.red,
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => DemoImagePicker(),));
              },
              child: Text("Button"),
              autofocus: true,
              disabledColor: Colors.red,
              disabledElevation: 2.0,
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          )
        ],
      ),
    );
  }
}
