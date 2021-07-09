import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class DemoVideoPlayer extends StatefulWidget {
  @override
  _DemoVideoPlayerState createState() => _DemoVideoPlayerState();
}

class _DemoVideoPlayerState extends State<DemoVideoPlayer> {
  PickedFile _imageFile;
  dynamic _pickImageError;
  bool isVideo = false;
  VideoPlayerController _controller;
  VideoPlayerController _toBeDisposed;
  String _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  Future<void> _playVideo(PickedFile file) async {
    if (file != null && mounted) {
      await _disposeVideoController();
      if (kIsWeb) {
        _controller = VideoPlayerController.network(file.path);
        // In web, most browsers won't honor a programmatic call to .play
        // if the video has a sound track (and is not muted).
        // Mute the video so it auto-plays in web!
        // This is not needed if the call to .play is the result of user
        // interaction (clicking on a "play" button, for example).
        await _controller.setVolume(0.0);
      } else {
        _controller = VideoPlayerController.file(File(file.path));
        await _controller.setVolume(1.0);
      }
      await _controller.initialize();
      await _controller.setLooping(true);
      await _controller.play();
      setState(() {});
    }
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    if (_controller != null) {
      await _controller.setVolume(0.0);
    }
    if (isVideo) {
      final PickedFile file = await _picker.getVideo(
          source: source, maxDuration: const Duration(seconds: 10));
      await _playVideo(file);
    } else {
      await _displayPickImageDialog(context,
          (double maxWidth, double maxHeight, int quality) async {
        try {
          final pickedFile = await _picker.getImage(
            source: source,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
            imageQuality: quality,
          );
          setState(() {
            _imageFile = pickedFile;
          });
        } catch (e) {
          setState(() {
            _pickImageError = e;
          });
        }
      });
    }
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller.setVolume(0.0);
      _controller.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _disposeVideoController();
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

  Future<void> _disposeVideoController() async {
    if (_toBeDisposed != null) {
      await _toBeDisposed.dispose();
    }
    _toBeDisposed = _controller;
    _controller = null;
  }

  Widget _previewVideo() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_controller == null) {
      return const Text(
        'You have not yet picked a video',
        textAlign: TextAlign.center,
      );
    }
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AspectRatioVideo(_controller),
    );
  }

  Widget _previewImage() {
    final Text retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFile != null) {
      if (kIsWeb) {
        // Why network?
        // See https://pub.dev/packages/image_picker#getting-ready-for-the-web-platform
        return Image.network(_imageFile.path);
      } else {
        return Semantics(
            child: Image.file(File(_imageFile.path)),
            label: 'image_picker_example_picked_image');
      }
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return const Text(
        'You have not yet picked an image.',
        textAlign: TextAlign.center,
      );
    }
  }

  Future<void> retrieveLostData() async {
    final LostData response = await _picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.video) {
        isVideo = true;
        await _playVideo(response.file);
      } else {
        isVideo = false;
        setState(() {
          _imageFile = response.file;
        });
      }
    } else {
      _retrieveDataError = response.exception.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("player"),
      ),
      body: Center(
        child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
            ? FutureBuilder<void>(
                future: retrieveLostData(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Text(
                        'You have not yet picked an image.',
                        textAlign: TextAlign.center,
                      );
                    case ConnectionState.done:
                      return isVideo ? _previewVideo() : _previewImage();
                    default:
                      if (snapshot.hasError) {
                        return Text(
                          'Pick image/video error: ${snapshot.error}}',
                          textAlign: TextAlign.center,
                        );
                      } else {
                        return const Text(
                          'You have not yet picked an image.',
                          textAlign: TextAlign.center,
                        );
                      }
                  }
                },
              )
            : (isVideo ? _previewVideo() : _previewImage()),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () {
                isVideo = true;
                _onImageButtonPressed(ImageSource.gallery);
              },
              heroTag: 'video0',
              tooltip: 'Pick Video from gallery',
              child: const Icon(Icons.video_library),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () {
                isVideo = true;
                _onImageButtonPressed(ImageSource.camera);
              },
              heroTag: 'video1',
              tooltip: 'Take a Video',
              child: const Icon(Icons.videocam),
            ),
          ),
        ],
      ),
    );
  }

  Text _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add optional parameters'),
            content: Column(
              children: <Widget>[
                TextField(
                  controller: maxWidthController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration:
                      InputDecoration(hintText: "Enter maxWidth if desired"),
                ),
                TextField(
                  controller: maxHeightController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration:
                      InputDecoration(hintText: "Enter maxHeight if desired"),
                ),
                TextField(
                  controller: qualityController,
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(hintText: "Enter quality if desired"),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: const Text('PICK'),
                  onPressed: () {
                    double width = maxWidthController.text.isNotEmpty
                        ? double.parse(maxWidthController.text)
                        : null;
                    double height = maxHeightController.text.isNotEmpty
                        ? double.parse(maxHeightController.text)
                        : null;
                    int quality = qualityController.text.isNotEmpty
                        ? int.parse(qualityController.text)
                        : null;
                    onPick(width, height, quality);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }
}

typedef void OnPickImageCallback(
    double maxWidth, double maxHeight, int quality);

class AspectRatioVideo extends StatefulWidget {
  AspectRatioVideo(this.controller);

  final VideoPlayerController controller;

  @override
  AspectRatioVideoState createState() => AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {
  VideoPlayerController get controller => widget.controller;
  bool initialized = false;

  void _onVideoControllerUpdate() {
    if (!mounted) {
      return;
    }
    if (initialized != controller.value.initialized) {
      initialized = controller.value.initialized;
      setState(() {});
    }
  }

  double _slider;
  double _volume = 0.5;
  bool seekStatus = false;
  bool play = true;
  Timer timer;
  List _positionList = [];
  List _positionListFinal = [];
  String _position = "";
  String _positionFinal = "00:00";

  List _durationList = [];
  List _durationListFinal = [];
  String _duration = "";
  String _durationFinal = "00:00";

  @override
  void initState() {
    super.initState();
    controller.addListener(_onVideoControllerUpdate);
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (seekStatus == false) {
        setState(() {
          _slider = double.parse(controller.value.position.inSeconds.toString());
          _positionList = controller.value.position.toString().split(".");
          _position = _positionList[0];
          _positionListFinal = _position.toString().split(":");
          _positionFinal = _positionListFinal[1]+":"+_positionListFinal[2];

        });
      }
      print(_positionFinal);
    });
    _durationList =  controller.value.duration.toString().split(".");
    _duration = _durationList[0];
    _durationListFinal = _duration.toString().split(":");
    _durationFinal = _durationListFinal[1] + ":" + _durationListFinal[2];
    setState(() {

    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.removeListener(_onVideoControllerUpdate);
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    double _max = double.parse(controller.value.duration.inSeconds.toString());

    if (initialized) {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: controller.value?.aspectRatio,
                child: VideoPlayer(controller),
              ),
              Row(
                children: [
                  play ? IconButton(
                      icon: Icon(Icons.pause),
                      onPressed: () {
                        setState(() {
                          play = false;
                        });
                        controller.pause();
                      }
                      ) :
                  IconButton(
                      icon: Icon(Icons.play_arrow),
                      onPressed: () {
                        setState(() {
                          play = true;
                        });
                        controller.play();
                      }
                  ),
                 Text(_positionFinal),
                  Slider(
                    value: _slider ?? 0,
                    min: 0.0,
                    max: _max,
                    onChanged: (value) {
                      setState(() {
                        seekStatus = true;
                      });
                      setState(() {
                        _slider = value;
                      });
                    },
                    onChangeEnd: (value) {
                      setState(() {
                        seekStatus = false;
                      });
                      controller.seekTo(Duration(seconds: value.round()));
                    },
                  ),
                  Text(_durationFinal),
                ],
              ),
              Slider(
                value: _volume ?? 0,
                min: 0.0,
                max: 1.0,
                onChanged: (value) {
                  controller.setVolume(value);
                  setState(() {
                    _volume = value;
                  });
                },
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
