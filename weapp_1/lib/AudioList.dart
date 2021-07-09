import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:audio_manager/audio_manager.dart';



String _platformVersion = 'Unknown';
bool isPlaying = false;
Duration _duration;
Duration _position;
double _slider;
String _error;
num curIndex = 0;
PlayMode playMode = AudioManager.instance.playMode;

final list = [
  {
    "title": "Ashiqui 2",
    "desc": "Tum Hi Ho",
    "url": "assets/ashi.mp3",
    "coverUrl": "assets/jay.png"
  },
  {
    "title": "Kai Po Che",
    "desc": "Shubharambh",
    "url": "assets/che.mp3",
    "coverUrl": "assets/jay.png"
  },
  {
    "title": "Hollywood",
    "desc": "Solo",
    "url": "assets/solo.mp3",
    "coverUrl": "assets/jay.png"
  },
  {
    "title": "Jai Mummy Di",
    "desc": "Mummy Nu Pasand",
    "url": "assets/mummy.mp3",
    "coverUrl": "assets/jay.png"
  },
  {
    "title": "network",
    "desc": "network resouce playback",
    "url": "https://dl.espressif.com/dl/audio/ff-16b-2c-44100hz.m4a",
    "coverUrl": "assets/jay.png"
  }
];

class MyAppExample extends StatefulWidget {
  @override
  _MyAppExampleState createState() => _MyAppExampleState();
}

class _MyAppExampleState extends State<MyAppExample> {


  @override
  void initState() {
    super.initState();

    initPlatformState();
    if(mounted){
      setState(() {
        isPlaying = AudioManager.instance.isPlaying;
      });
    }
    setupAudio();
  }

  void setupAudio() {
    List<AudioInfo> _list = [];
    list.forEach((item) => _list.add(AudioInfo(item["url"],
        title: item["title"], desc: item["desc"], coverUrl: item["coverUrl"])));

    AudioManager.instance.audioList = _list;
    AudioManager.instance.intercepter = true;
    AudioManager.instance.play(auto: false);

    AudioManager.instance.onEvents((events, args) {
      print("$events, $args");
      switch (events) {
        case AudioManagerEvents.start:
          print("start load data callback, curIndex is ${AudioManager.instance.curIndex}");
          if(mounted) {
            setState(() {
              _position = AudioManager.instance.position;
              _duration = AudioManager.instance.duration;
              _slider = 0;
            });
          }
          break;
        case AudioManagerEvents.ready:
          print("ready to play");

          if(mounted){
            setState(() {
              _error = null;
              _position = AudioManager.instance.position;
              _duration = AudioManager.instance.duration;
            });
          }
          // if you need to seek times, must after AudioManagerEvents.ready event invoked
          // AudioManager.instance.seekTo(Duration(seconds: 10));
          break;
        case AudioManagerEvents.seekComplete:
          if(mounted){
            setState(() {
              _position = AudioManager.instance.position;
              _slider = _position.inMilliseconds / _duration.inMilliseconds;
            });
          }
          print("seek event is completed. position is [$args]/ms");
          break;
        case AudioManagerEvents.buffering:
          print("buffering $args");
          break;
        case AudioManagerEvents.playstatus:
          if(mounted){
            setState(() {
              isPlaying = AudioManager.instance.isPlaying;
            });
          }
          break;
        case AudioManagerEvents.timeupdate:
          if(mounted){
            print("time?>>");
            setState(() {
              _position = AudioManager.instance.position;
              _slider = _position.inMilliseconds / _duration.inMilliseconds;
            });
          }
          AudioManager.instance.updateLrc(args["position"].toString());
          break;
        case AudioManagerEvents.error:
          if(mounted){
            setState(() {
              _error = args;
            });
          }
          break;
        case AudioManagerEvents.ended:
          AudioManager.instance.next();
          break;
        default:
          break;
      }
    });
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await AudioManager.instance.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio player'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text('Running on: $_platformVersion\n'),
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(list[index]["coverUrl"]),
                      ),
                      title: Text(list[index]["title"],
                          style: TextStyle(fontSize: 18)),
                      subtitle: Text(list[index]["desc"]),
                      onTap: () =>AudioManager.instance.play(index: index),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(),
                  itemCount: list.length),
            ),
            Center(
                child: Text(_error != null
                    ? _error
                    : "${AudioManager.instance.info.desc} $_position")),
            bottomPanel()
          ],
        ),
      ),
    );
  }

  Widget bottomPanel() {
    return Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: songProgress(context),
      ),
      Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
                iconSize: 36,
                icon: Icon(
                  Icons.skip_previous,
                  color: Colors.black,
                ),
                onPressed: () => AudioManager.instance.previous()),
            IconButton(
              onPressed: () async {
                bool playing = await AudioManager.instance.playOrPause();
                print("await -- $playing");
              },
              padding: const EdgeInsets.all(0.0),
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                size: 48.0,
                color: Colors.black,
              ),
            ),
            IconButton(
                iconSize: 36,
                icon: Icon(
                  Icons.skip_next,
                  color: Colors.black,
                ),
                onPressed: () => AudioManager.instance.next(),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget songProgress(BuildContext context) {
    var style = TextStyle(color: Colors.black);
    return Row(
      children: <Widget>[
        Text(
          _formatDuration(_position),
          style: style,
        ),
         _slider != null ? Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 2,
                  thumbColor: Colors.blueAccent,
                  overlayColor: Colors.blue,
                  thumbShape: RoundSliderThumbShape(
                    disabledThumbRadius: 5,
                    enabledThumbRadius: 5,
                  ),
                  overlayShape: RoundSliderOverlayShape(
                    overlayRadius: 10,
                  ),
                  activeTrackColor: Colors.blueAccent,
                  inactiveTrackColor: Colors.grey,
                ),
                child: Slider(
                  value: _slider ?? 0,
                  onChanged: (value) {
                    setState(() {
                      _slider = value;
                    });
                  },
                  min: 0.0,
                  max: 1.0,
                  onChangeEnd: (value) {
                    if (_duration != null) {
                      Duration msec = Duration(
                          milliseconds:
                          (_duration.inMilliseconds * value).round());
                      AudioManager.instance.seekTo(msec);
                    }
                  },
                )
            ),
          ),
        ) : Container(),
        Text(
          _formatDuration(_duration),
          style: style,
        ),
      ],
    );
  }

  String _formatDuration(Duration d) {
    if (d == null) return "--:--";
    int minute = d.inMinutes;
    int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
    String format = ((minute < 10) ? "0$minute" : "$minute") +
        ":" +
        ((second < 10) ? "0$second" : "$second");
    return format;
  }

}
