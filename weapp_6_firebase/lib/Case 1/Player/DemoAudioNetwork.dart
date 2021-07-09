import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart';

class DemoNetworkAudio extends StatefulWidget {
  @override
  _DemoNetworkAudioState createState() => _DemoNetworkAudioState();
}

class _DemoNetworkAudioState extends State<DemoNetworkAudio> {
  AudioPlayer audioPlayer = new AudioPlayer();
  Duration position = new Duration();
  Duration duration = new Duration();
  bool playing = false;
  String currentTime = "00:00";
  String completeTime = "00:00";

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.dispose();
  }


  Widget slider() {
    return Slider.adaptive(
        min: 0.0,
        value: position.inSeconds.toDouble(),
        max: duration.inSeconds.toDouble(),
        onChanged: (double value) {
          setState(() {
            audioPlayer.seek(new Duration(seconds: value.toInt()));
          });
        });
  }

  void getAudio() async {
    String url =
        'https://jaylukhi.000webhostapp.com/music/mixkit-getting-ready-46.mp3';

    if (playing) {
      var res = await audioPlayer.pause();
      if (res == 1) {
        setState(() {
          playing = false;
        });
      }
    } else {
      var res = await audioPlayer.play(url, isLocal: true);
      if (res == 1) {
        setState(() {
          playing = true;
        });
      }
    }
    audioPlayer.onAudioPositionChanged.listen((Duration dd) {
      setState(() {
        position = dd;
      });
    });
    audioPlayer.onDurationChanged.listen((Duration dd) {
      setState(() {
        duration = dd;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("audio"),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            slider(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(position.toString().split(".")[0]),
                  Text(duration.toString().split(".")[0]),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                getAudio();
              },
              child:
              playing == false ? Icon(Icons.play_arrow) : Icon(Icons.pause),
            ),
          ],
        ),
      ),
    );
  }
}
