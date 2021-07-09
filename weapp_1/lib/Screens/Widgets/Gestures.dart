import 'package:flutter/material.dart';

class DemoGestures extends StatefulWidget {
  @override
  _DemoGesturesState createState() => _DemoGesturesState();
}
class _DemoGesturesState extends State<DemoGestures> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              print("OnTap");
            },
            onDoubleTap: () {
              print("OnDoubleTap");
            },
            onTapDown: (_) {
              print("onTapDown");
            },
            onTapUp: (_) {
              print("onTapUp");
            },
            onTapCancel: () {
              print("onTapCancel");
            },
            onPanStart: (_) {
              print("onPanStart");
            },
            onPanEnd: (_) {
              print("onPanEnd");
            },
            onLongPress: () {
              print("onLongPress");
            },
            onForcePressPeak: (_) {
              print("onForcePressPeak");
            },
            onDoubleTapDown: (_) {
              print("onDoubleTapDown");
            },
            onLongPressStart: (_) {
              print("onLongPressStart");
            },
            onLongPressEnd: (_) {
              print("onLongPressEnd");
            },
            onLongPressUp: () {
              print("onLongPressUp");
            },
            onSecondaryLongPress: () {
              print("onSecondaryLongPress");
            },
            //(_){print("");},

            child: Container(
                height: 50,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(10.0)),
                child: Center(
                    child: Text(
                      "Button",
                      style: TextStyle(fontSize: 25),
                    ))),
          )
        ],
      ),
    );
  }
}
