import 'package:flutter/material.dart';
import 'package:weapp_6_firebase/Case%201/Player/DemoAudioNetwork.dart';
import 'package:weapp_6_firebase/Case%201/Player/DemoAudioPlayer.dart';
import 'package:weapp_6_firebase/Case%201/Player/DemoVideoNetworkPlayer.dart';
import 'package:weapp_6_firebase/Case%201/Player/DemoVideoPlayer.dart';
import 'package:weapp_6_firebase/Case%201/video.dart';
import 'package:weapp_6_firebase/Case%201/AudioList.dart';

class VideoAudioButtonList extends StatefulWidget {
  @override
  _VideoAudioButtonListState createState() => _VideoAudioButtonListState();
}

class _VideoAudioButtonListState extends State<VideoAudioButtonList> {
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
              //     onPressed: () {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => DemoAudioPlayer(),
              //           ));
              //     },
              //     child: Text("Audio")),
              RaisedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyAppExample(),
                        ));
                  },
                  child: Text("Audio List")),
              // RaisedButton(
              //     onPressed: () {
              //       Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) => DemoNetworkAudio(),
              //           ));
              //     },
              //     child: Text("Audio Network")),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // RaisedButton(
                  //   onPressed: (){
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //           builder: (context) => DemoNetworkVideo(),
                  //         ));
                  //   },
                  //   child: Text("Video Player Chiew"),
                  // ),
                  RaisedButton(
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VideoViewerList(),
                          ));
                    },
                    child: Text("Video Viewer"),
                  ),
                ],
              ),
              // RaisedButton(
              //   onPressed: (){
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute(
              //           builder: (context) => VideoPlayerScreen(),
              //         ));
              //   },
              //   child: Text("Network Video"),
              // ),
              RaisedButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DemoVideoPlayer(),
                      ));
                },
                child: Text("Choose Video And Audio From Gallery"),
              ),

            ],
          ),
        )
    );
  }
}
