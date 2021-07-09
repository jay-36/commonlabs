import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerTopic extends StatelessWidget {

  final String title;
  final String description;
  final Function fun;
  final Widget wi;

  const ShimmerTopic({this.title, this.description, this.fun,this.wi,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Stack(
        children: [
          Shimmer.fromColors(
            baseColor: Color(0x4003fceb),
            highlightColor: Color(0x6003fc8c),
            child: Stack(
              children: [
                Card(
                  elevation: 10,
                  child: Container(
                    width: double.infinity,
                    height: 110.0,
                    color: Color(0x50FFA23A),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 15,
            left: 20,
            child: Text(
              title,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
            ),
          ),
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              width: 275.0,
              child: Text(
                  description,
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis),
            ),
          ),
          Positioned(
              right: 20,
              top: 35,
              child: wi
          ),
          InkWell(
            onTap: fun,
            child: Container(
              width: double.infinity,
              height: 110.0,
            ),
          ),
        ],
      ),
    );
  }
}
