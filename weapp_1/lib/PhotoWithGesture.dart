

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewDemo extends StatefulWidget {
  @override
  _PhotoViewDemoState createState() => _PhotoViewDemoState();
}

class _PhotoViewDemoState extends State<PhotoViewDemo> {

  double startPositionV;
  double startPositionH;
  double endPositionV;
  double endPositionH;
  int inx = 0;

  Axis axisDirection = Axis.horizontal;

  bool horizontal = true;
  bool vertical = false;
  double visibilityHorizontal = 1.0;
  double visibilityVertical = 0.0;

  final imageList = [
    'assets/travelimage0.jpg',
    'assets/Image144.png',
    'assets/travelimage1.jpg',
    'assets/aLIEz.jpg',
    'assets/travelimage2.jpg',
    'assets/Image1024.png',
    'assets/travelimage3.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PhotoView Demo"),
      ),
      body: Center(
        child: GestureDetector(
          onVerticalDragUpdate: (val) {
            setState(() {
              axisDirection = Axis.vertical;
              endPositionV = val.globalPosition.dy;
            });
          },
          onVerticalDragStart: (val){
            setState(() {
              axisDirection = Axis.vertical;
              startPositionV = val.globalPosition.dy;
            });
          },
          onVerticalDragEnd: (val){
            setState(() {
              axisDirection = Axis.vertical;
            });
            if(startPositionV > endPositionV){
              print("up");
              if(inx != (imageList.length-1)){
                setState(() {
                  inx= inx +1;
                });
              }
            }else{
              print("down");
              if(inx != 0){
                setState(() {
                  inx= inx - 1;
                });
              }
            }
          },
          onHorizontalDragStart: (val){
            setState(() {
              axisDirection = Axis.horizontal;
              startPositionH = val.globalPosition.dx;
            });
          },
          onHorizontalDragEnd: (val){
            setState(() {
              axisDirection = Axis.horizontal;
            });
            if(inx != imageList.length){
              if(startPositionH > endPositionH){
                print("right");
                if(inx != (imageList.length-1)){
                  print("s");
                  setState(() {
                    inx = inx + 1;
                  });
                }
              }else{
                print("left");
                setState(() {
                  axisDirection = Axis.horizontal;
                  if(inx != 0){
                    inx = inx - 1;
                  }
                });
              }
            }
          },
          onHorizontalDragUpdate: (val){
            setState(() {
              endPositionH = val.globalPosition.dx;
            });
          },
          child: horizontal ? Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Visibility(
              visible: horizontal,
              child: PhotoViewGallery.builder(scrollDirection: axisDirection,
                itemCount: imageList.length,
                builder: (context, index) {
                  inx = index;
                  return PhotoViewGalleryPageOptions(
                    imageProvider: AssetImage(
                      imageList[inx],
                    ),
                    minScale: PhotoViewComputedScale.contained * 0.8,
                    maxScale: PhotoViewComputedScale.covered * 2,
                  );
                },
                backgroundDecoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Theme.of(context).canvasColor,
                ),
                enableRotation: true,
                loadingBuilder: (context, event) => Center(
                  child: Container(
                    width: 30.0,
                    height: 30.0,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.orange,
                      value: event == null
                          ? 0
                          : event.cumulativeBytesLoaded /
                          event.expectedTotalBytes,
                    ),
                  ),
                ),
              ),
            ),
          ) : Visibility(
              visible: vertical,
              child: PhotoView(
                imageProvider: AssetImage(imageList[inx]),
                minScale: 1.0,
                maxScale: 5.0,
                enableRotation: true,
              )
          ),
        ),
      ),
    );
  }
}