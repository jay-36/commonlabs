import 'dart:math';
import 'dart:ui';
import 'dart:ui';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:weapp_6_firebase/Case%201/Animations/AnimationList.dart';
import 'package:weapp_6_firebase/Case%201/DragAndDrop.dart';
import 'package:vector_math/vector_math.dart' show Vector2;


class GestureButtonList extends StatefulWidget {
  @override
  _GestureButtonListState createState() => _GestureButtonListState();
}

class _GestureButtonListState extends State<GestureButtonList> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // RaisedButton(
          //   onPressed: () {
          //     Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (context) => GestureTransformable(child: Container(color: Colors.red,),size: Size.square(100.0),),
          //         ));
          //   },
          //   child: Text("Gesture"),
          // ),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnimationsTypes(),
                  ));
            },
            child: Text("Different Animations"),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DragAndDropDemo(),
                  ));
            },
            child: Text("Drag And Drop"),
          ),
        ],
      ),
    ));
  }
}


class Drag extends StatefulWidget {
  @override
  _DragState createState() => _DragState();
}

class _DragState extends State<Drag> {
  double x = 0, y = 0;
  double finalAngle = 0.0;
  double oldAngle = 0.0;
  double upsetAngle = 0.0;
  final _transformationController = TransformationController();
  TapDownDetails _doubleTapDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LayoutBuilder(
          builder: (context, constraints){
           return GestureDetector(
             behavior: HitTestBehavior.translucent,
            onDoubleTapDown: _handleDoubleTapDown,
            onDoubleTap: _handleDoubleTap,
             onPanUpdate: (details) {
               Offset centerOfGestureDetector = Offset(
                   constraints.maxWidth / 2,
                   constraints.maxHeight / 2);
               final touchPositionFromCenter =
                   details.localPosition - centerOfGestureDetector;
               print(touchPositionFromCenter.direction * 180 / pi);
               setState(
                     () {
                   finalAngle = touchPositionFromCenter.direction;
                 },
               );
             },
            child: Transform.rotate(
              angle: finalAngle,
              child: InteractiveViewer(
                  transformationController: _transformationController,
                  boundaryMargin: EdgeInsets.all(80),
                  panEnabled: true,
                  alignPanAxis: true,
                  scaleEnabled: true,
                  constrained: true,
                  minScale: 1.0,
                  maxScale: 5.0,
                  child: Image.network("https://pngimg.com/uploads/muffin/muffin_PNG123.png",
                    fit: BoxFit.fitWidth,
                  )
              ),
            ),
          );
  }
        ),
      )
    );
  }
  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails.localPosition;
      // For a 3x zoom
      _transformationController.value = Matrix4.identity()
      //   ..translate(-position.dx * 2, -position.dy * 2)
      //   ..scale(3.0);
      // Fox a 2x zoom
      ..translate(-position.dx, -position.dy)
      ..scale(2.0);
    }
  }

}
