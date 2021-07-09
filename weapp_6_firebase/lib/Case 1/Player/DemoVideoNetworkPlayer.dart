// import 'dart:io';
//
// import 'package:chewie/chewie.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:video_player/video_player.dart';
//
// class DemoNetworkVideo extends StatefulWidget {
//
//
//   @override
//   State<StatefulWidget> createState() {
//     return _DemoNetworkVideoState();
//   }
// }
//
// class _DemoNetworkVideoState extends State<DemoNetworkVideo> {
//   TargetPlatform _platform;
//   VideoPlayerController _videoPlayerController1;
//   VideoPlayerController _videoPlayerController2;
//   ChewieController _chewieController;
//
//   bool isVideo = true;
//   final ImagePicker _picker = ImagePicker();
//
//   @override
//   void initState() {
//     super.initState();
//     _videoPlayerController1 = VideoPlayerController.network(
//         'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
//     _chewieController = ChewieController(
//       videoPlayerController: _videoPlayerController1,showControls: false,
//       aspectRatio: 3 / 2,
//       autoPlay: false,
//       looping: true,
//     );
//   }
//
//   @override
//   void dispose() {
//     _videoPlayerController1.dispose();
//     _videoPlayerController2.dispose();
//     _chewieController.dispose();
//     super.dispose();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData.light().copyWith(
//         platform: _platform ?? Theme.of(context).platform,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text("Network Video"),
//         ),
//         body: Column(
//           children: <Widget>[
//             Expanded(
//               child: Center(
//                 child: Chewie(
//                   controller: _chewieController,
//                 ),
//               ),
//             ),
//             // FlatButton(
//             //   onPressed: () {
//             //     _chewieController.enterFullScreen();
//             //   },
//             //   child: Text('Fullscreen'),
//             // ),
//             Row(
//               children: <Widget>[
//                 // Expanded(
//                 //   child: FlatButton(
//                 //     onPressed: () {
//                 //       setState(() {
//                 //         _chewieController.dispose();
//                 //         /*_videoPlayerController2.pause();
//                 //         _videoPlayerController2.seekTo(Duration(seconds: 0));*/
//                 //
//                 //         _chewieController = ChewieController(
//                 //           videoPlayerController: _videoPlayerController1,
//                 //           aspectRatio: 3 / 2,
//                 //           autoPlay: false,
//                 //           looping: true,
//                 //         );
//                 //
//                 //         _videoPlayerController1..initialize().then((_){
//                 //           setState(() {
//                 //             _videoPlayerController1.seekTo(Duration(seconds: 3));
//                 //             _videoPlayerController1.play();
//                 //           });
//                 //         });
//                 //
//                 //       });
//                 //     },
//                 //     child: Padding(
//                 //       child: Text("Seek To"),
//                 //       padding: EdgeInsets.symmetric(vertical: 16.0),
//                 //     ),
//                 //   ),
//                 // ),
//                 // Expanded(
//                 //   child: FlatButton(
//                 //     onPressed: () {
//                 //       setState(() {
//                 //         _chewieController.dispose();
//                 //         _videoPlayerController2.pause();
//                 //         _videoPlayerController2.seekTo(Duration(seconds: 0));
//                 //         _chewieController = ChewieController(
//                 //           videoPlayerController: _videoPlayerController1,
//                 //           aspectRatio: 3 / 2,
//                 //           autoPlay: true,
//                 //           looping: true,
//                 //         );
//                 //       });
//                 //     },
//                 //     child: Padding(
//                 //       child: Text("Network"),
//                 //       padding: EdgeInsets.symmetric(vertical: 16.0),
//                 //     ),
//                 //   ),
//                 // ),
//                 Expanded(
//                   child: FlatButton(
//                     onPressed: () async{
//                       PickedFile file = await _picker.getVideo(
//                           source: ImageSource.gallery, maxDuration: const Duration(seconds: 10));
//                       print(file.path.toString());
//                       setState(() {
//                         _videoPlayerController2 = VideoPlayerController.file(File(file.path));
//                       });
//
//                       setState(() {
//                         _chewieController.dispose();
//                         _videoPlayerController1.pause();
//                         _videoPlayerController1.seekTo(Duration(seconds: 0));
//                         _chewieController = ChewieController(
//                           videoPlayerController: _videoPlayerController2,
//                           aspectRatio: 3 / 2,
//                           autoPlay: true,
//                           looping: true,
//                         );
//                       });
//                     },
//                     child: Padding(
//                       padding: EdgeInsets.symmetric(vertical: 16.0),
//                       child: Text("Gallery"),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//             // Row(
//             //   children: <Widget>[
//             //     Expanded(
//             //       child: FlatButton(
//             //         onPressed: () {
//             //           setState(() {
//             //             _platform = TargetPlatform.android;
//             //           });
//             //         },
//             //         child: Padding(
//             //           child: Text("Android controls"),
//             //           padding: EdgeInsets.symmetric(vertical: 16.0),
//             //         ),
//             //       ),
//             //     ),
//             //     Expanded(
//             //       child: FlatButton(
//             //         onPressed: () {
//             //           setState(() {
//             //             _platform = TargetPlatform.iOS;
//             //           });
//             //         },
//             //         child: Padding(
//             //           padding: EdgeInsets.symmetric(vertical: 16.0),
//             //           child: Text("iOS controls"),
//             //         ),
//             //       ),
//             //     )
//             //   ],
//             // )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//
//
// class VideoPlayerScreen extends StatefulWidget {
//   VideoPlayerScreen({Key key}) : super(key: key);
//   @override
//   _VideoPlayerScreenState createState() => _VideoPlayerScreenState();
// }
// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   VideoPlayerController _controller;
//   Future<void> _initializeVideoPlayerFuture;
//   bool isVideo = false;
//   final ImagePicker _picker = ImagePicker();
//   VideoPlayerController _toBeDisposed;
//
//   @override
//   void initState() {
//     _controller = VideoPlayerController.network(
//       'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
//     );
//     _initializeVideoPlayerFuture = _controller.initialize();
//     _controller.setLooping(true);
//     super.initState();
//   }
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Butterfly Video'),
//       ),
//       body: FutureBuilder(
//         future: _initializeVideoPlayerFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.done) {
//             return AspectRatio(
//               aspectRatio: _controller.value.aspectRatio,
//               child: VideoPlayer(_controller),
//             );
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//       floatingActionButton : FloatingActionButton(
//         onPressed: () {
//           setState(() {
//             if (_controller.value.isPlaying) {
//               _controller.pause();
//             } else {
//               _controller.play();
//             }
//           });
//         },
//         heroTag: 'hero2',
//         child: Icon(
//           _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
//         ),
//       ),
//     );
//   }
// }