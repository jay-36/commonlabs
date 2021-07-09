import 'package:flutter/material.dart';

class DragAndDropDemo extends StatefulWidget {
  @override
  _DragAndDropDemoState createState() => _DragAndDropDemoState();
}
class _DragAndDropDemoState extends State<DragAndDropDemo> {
  Offset offset = Offset.zero;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[

            Positioned(
              left: offset.dx,
              top: offset.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  setState(() {
                    offset = Offset(offset.dx + details.localPosition.dx, offset.dy + details.delta.dy);
                  });
                },
                child: Container(width: 100, height: 100, color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
