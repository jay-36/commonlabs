import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:weapp_6_firebase/Case%201/Animations/Animation.dart';


class AnimationsTypes extends StatefulWidget {
  @override
  _AnimationsTypesState createState() => _AnimationsTypesState();
}

class _AnimationsTypesState extends State<AnimationsTypes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animations"),centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DemoAnimation(),
                      ));
                },
                child: Text("Zoom Out")),

            RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Animationt(),
                      ));
                },
                child: Text("M-Rotate")),
            RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BouncingButton(),
                      ));
                },
                child: Text("Bounce")),
            RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyStatefulWidget(),
                      ));
                },
                child: Text("Sllider")),
            RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LogoFade(),
                      ));
                },
                child: Text("Fade")),

          ],
        ),
      ),
    );
  }
}

