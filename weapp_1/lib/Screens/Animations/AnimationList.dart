import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:weapp_1/Screens/Animations/Animation.dart';
import 'package:weapp_1/Screens/Widgets/Gestures.dart';
import 'package:weapp_1/Screens/Widgets/Images.dart';

class AnimationsTypes extends StatefulWidget {
  @override
  _AnimationsTypesState createState() => _AnimationsTypesState();
}

class _AnimationsTypesState extends State<AnimationsTypes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buttons"),
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

