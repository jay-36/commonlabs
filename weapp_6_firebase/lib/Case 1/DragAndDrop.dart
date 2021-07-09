import 'package:flutter/material.dart';

class DragAndDropDemo extends StatefulWidget {
  @override
  _DragAndDropDemoState createState() => _DragAndDropDemoState();
}
class _DragAndDropDemoState extends State<DragAndDropDemo> {

  Offset _offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF424242),
      body: Container(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                Positioned(
                  left: _offset.dx,
                  top: _offset.dy,
                  child: LongPressDraggable(
                    feedback: FlutterLogo( size: 100),
                    child: FlutterLogo(size: 100),
                    onDragEnd: (details) {
                      setState(() {
                        final adjustment = MediaQuery.of(context).size.height  -constraints.maxHeight;

                        _offset = Offset(details.offset.dx, details.offset.dy - adjustment);

                      });
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
