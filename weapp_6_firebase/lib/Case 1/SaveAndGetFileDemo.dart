import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:permission_handler/permission_handler.dart';


class SaveImageDemo extends StatefulWidget {
  @override
  _SaveImageDemoState createState() => _SaveImageDemoState();
}
class _SaveImageDemoState extends State<SaveImageDemo> {

  String imgUrl = "https://i.pinimg.com/564x/1a/30/24/1a30244cba1d7631cbb99ab5ae2724e2.jpg";
  String mp3Url = "https://jaylukhi.000webhostapp.com/music/mixkit-getting-ready-46.mp3";
  String mp4Url = "https://jaylukhi.000webhostapp.com/Video/GNMC3868.MP4";
  final pathForMp3File= "storage/emulated/0/WeApplinse Technology/Songs/sample.mp3";
  final pathForJpgFile= "storage/emulated/0/WeApplinse Technology/Images/sample.jpg";
  final pathForMp4File= "storage/emulated/0/WeApplinse Technology/Videos/sample.mp4";
  String downloadMessage = "Initializing....";
  String downloadMessage2 = "";
  bool isDownloading = false;
  double progressIndicator = 0;
  String fileExt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Download File"),centerTitle: true,),
      body: Container(
        child:Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [
                 RaisedButton(
                     child: Text("Image"),
                     onPressed: ()async{

                       setState(() {
                         isDownloading = !isDownloading;
                       });
                       Dio dio = Dio();
                       var status = await Permission.storage.status;
                       if (!status.isGranted) {
                         await Permission.storage.request();
                       }
                       final extension = p.extension(pathForJpgFile);
                       if(extension == ".jpg" || extension == ".png" || extension == '.jpeg'){
                         dio.download(imgUrl, pathForJpgFile ,onReceiveProgress: (actualbytes,totalbytes){
                           var progress = (actualbytes / totalbytes)*100;
                           if(progress < 100){
                             progressIndicator = progress / 100;
                             setState(() {
                               downloadMessage = 'Downloading...${progress.floor()} %';
                               downloadMessage2 = '${progress.floor()} %';
                             });
                           }else{
                             setState(() {
                               downloadMessage = 'Download Successfully ! ';
                             });
                           }
                         });
                       }
                     }),
                 RaisedButton(
                   onPressed: ()async{
                     setState(() {
                       isDownloading = !isDownloading;
                     });
                     Dio dio = Dio();
                     var status = await Permission.storage.status;
                     if (!status.isGranted) {
                       await Permission.storage.request();
                     }
                     final extension = p.extension(pathForMp3File);
                     if( extension == ".mp3" ){
                       dio.download(mp3Url, pathForMp3File ,onReceiveProgress: (actualbytes,totalbytes){
                         var progress = (actualbytes / totalbytes)*100;
                         if(progress < 100){
                           setState(() {
                             progressIndicator = progress / 100;
                             downloadMessage = 'Downloading...${progress.floor()} %';
                             downloadMessage2 = '${progress.floor()} %';
                           });
                         }else{
                           setState(() {
                             downloadMessage = 'Download Successfully ! ';
                           });
                         }
                       });
                     }
                   },
                   child: Text("Songs"),
                 ),
                 RaisedButton(
                   onPressed: ()async{
                     setState(() {
                       isDownloading = !isDownloading;
                     });
                     Dio dio = Dio();
                     var status = await Permission.storage.status;
                     if (!status.isGranted) {
                       await Permission.storage.request();
                     }
                     final extension = p.extension(pathForMp4File);
                     if( extension == ".mp4" || extension == ".MP4" || extension == ".mkv"){
                       dio.download(mp4Url, pathForMp4File ,onReceiveProgress: (actualbytes,totalbytes){
                         var progress = (actualbytes / totalbytes)*100;
                         if(progress < 100){
                           setState(() {
                             progressIndicator = progress / 100;
                             downloadMessage = 'Downloading...${progress.floor()} %';
                             downloadMessage2 = '${progress.floor()} %';
                           });
                         }else{
                           setState(() {
                             downloadMessage = 'Download Successfully ! ';
                           });
                         }
                       });
                     }
                   },
                   child: Text("Videos"),
                 ),
               ],
             ),
              Text(downloadMessage ?? ''),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: LinearProgressIndicator(value: progressIndicator,minHeight: 10,)),
            ],
          ),
        )
      ),
    );
  }
}


class ReadWriteDemo extends StatefulWidget {

  final TextStorage storage;
  ReadWriteDemo({this.storage});

  @override
  _ReadWriteDemoState createState() => _ReadWriteDemoState();
}
class _ReadWriteDemoState extends State<ReadWriteDemo> {

  TextEditingController _textField = new TextEditingController();
  String _content = '';

  @override
  void initState() {
    super.initState();
    widget.storage.readFile().then((text) {
      setState(() {
        _content = text;
      });
    });
  }

  Future _writeStringToTextFile(String text) async {
    setState(() {
      _content += text + '\r\n';
    });

    return widget.storage.writeFile(text);
  }

  Future _clearContentsInTextFile() async {
    setState(() {
      _content = '';
    });

    return widget.storage.cleanFile();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Read & Write"),centerTitle: true,),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _textField,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: RaisedButton(
                child: Text('Write to File'),
                onPressed: () {
                  if (_textField.text.isNotEmpty) {
                    _writeStringToTextFile(_textField.text);
                    _textField.clear();
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: RaisedButton(
                child: Text(
                  'Clear Contents',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.redAccent,
                onPressed: () {
                  _clearContentsInTextFile();
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: new SingleChildScrollView(
                child: Text(
                  '$_content',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 22.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class TextStorage {


  Future get _localFile async {
    return File('storage/emulated/0/WeApplinse Technology/text.txt');
  }

  Future readFile() async {
    try {
      final file = await _localFile;
      String content = await file.readAsString();
      return content;
    } catch (e) {
      return '';
    }
  }

  Future writeFile(String text) async {
    final file = await _localFile;
    return file.writeAsString('$text\r\n', mode: FileMode.append);
  }

  Future cleanFile() async {
    final file = await _localFile;
    return file.writeAsString('');
  }
}