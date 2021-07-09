import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:ui' as ui;
import 'package:esys_flutter_share/esys_flutter_share.dart' as easyShare;
// import 'package:social_share/social_share.dart' as socialShare;
import 'package:share/share.dart' as share;

class ShareDemo extends StatefulWidget {
  @override
  _ShareDemoState createState() => _ShareDemoState();
}

class _ShareDemoState extends State<ShareDemo> {
  static GlobalKey previewContainer = new GlobalKey();

  takeScreenShot() async {
    RenderRepaintBoundary boundary =
        previewContainer.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    print(pngBytes);
    File imgFile =
        new File('/storage/emulated/0/WeApplinse Technology/screenshot.png');
    imgFile.writeAsBytes(pngBytes);
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: previewContainer,
      child: Scaffold(
          body: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                      onPressed: () {
                        takeScreenShot();
                        final RenderBox box = context.findRenderObject();
                        share.Share.shareFiles([
                          "/storage/emulated/0/WeApplinse Technology/screenshot.png"
                        ],
                            text: "jay",
                            subject: "Share Screenshot",
                            sharePositionOrigin:
                                box.localToGlobal(Offset.zero) & box.size);
                      },
                      child: Text("share")),
                  RaisedButton(
                      onPressed: () async {
                        takeScreenShot();
                        final RenderBox box = context.findRenderObject();
                        String url =
                            "https://i.pinimg.com/564x/1a/30/24/1a30244cba1d7631cbb99ab5ae2724e2.jpg";
                        var response = await get(url);
                        final documentDirectory =
                            (await getExternalStorageDirectory()).path;
                        File imgFile =
                            new File('$documentDirectory/flutter.png');
                        imgFile.writeAsBytesSync(response.bodyBytes);
                        share.Share.shareFiles(['$documentDirectory/flutter.png'],
                            subject: 'URL conversion + Share',
                            text: 'Hey! Checkout the Share Files repo',
                            sharePositionOrigin:
                                box.localToGlobal(Offset.zero) & box.size);
                      },
                      child: Text("share Network Image")),
                ],
              ))),
    );
  }
}

class ShareMeDemo extends StatefulWidget {
  @override
  _ShareMeDemoState createState() => _ShareMeDemoState();
}

class _ShareMeDemoState extends State<ShareMeDemo> {
  String msg = 'hello';



  static GlobalKey previewContainer = new GlobalKey();
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  ScreenshotController screenshotController = ScreenshotController();
  String imagePath = "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MXx8aHVtYW58ZW58MHx8MHw%3D&ixlib=rb-1.2.1&w=1000&q=80";


  takeScreenShot() async{
    RenderRepaintBoundary boundary = previewContainer.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    print(pngBytes);
    File imgFile = new File('/storage/emulated/0/WeApplinse Technology/screenshot.png');
    imgFile.writeAsBytes(pngBytes);
  }

  String documentDirectory = "";

  getImage()async{
    String url = "https://i.pinimg.com/564x/1a/30/24/1a30244cba1d7631cbb99ab5ae2724e2.jpg";
    var response = await get(url);
    setState(() {
      documentDirectory =  "/storage/emulated/0/00000";

    });
    File imgFile = new File('$documentDirectory/flutter.jpg');
    imgFile.writeAsBytesSync(response.bodyBytes);
    return imgFile;
  }

  String imagepath;


  // image() {
  //   ImagePicker.platform.pickImage(source: ImageSource.gallery).then((PickedFile value) async{
  //     setState(() {
  //       imagePath=value.path.toString();
  //
  //       print(imagePath);
  //
  //     });
  //     await socialShare.SocialShare.shareFacebookStory(imagePath,
  //         "#ffffff", "#000000", "https://deep-link-url",
  //         appId: "4607988489242863").catchError((onError){
  //       print('gjygjy'+ onError.toString());
  //     });
  //   });
  // }

  Future<String> networkImageToBase64(String imageUrl) async {
    http.Response response = await http.get(
      'https://i.pinimg.com/564x/b0/da/ac/b0daac950c00bf2fefe8e923b7b64c40.jpg',
    );
    var _base64 = base64Encode(response.bodyBytes);
    setState(() {
      url = _base64;
    });

    base64Decode(_base64);
    return _base64;
  }

  String url = "";

  String base64Image =
      '/9j/4AAQSkZJRgABAQEASABIAAD/2wBDAAYEBQYFBAYGBQYHBwYIChAKCgkJChQODwwQFxQYGBcUFhYaHSUfGhsjHBYWICwgIyYnKSopGR8tMC0oMCUoKSj/2wBDAQcHBwoIChMKChMoGhYaKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCgoKCj/wgARCAQ6AjQDASIAAhEBAxEB/8QAGwAAAgMBAQEAAAAAAAAAAAAABAUCAwYBAAf/xAAaAQADAQEBAQAAAAAAAAAAAAABAgMEAAUG/9oADAMBAAIQAxAAAAEWA5/m/Q8spKM8wqcrNuQe+jrRtGNCmGNQXjzx1mG9AEs0+QPTe5xiOEALFMbt3itTTPp8Fp42l827tMpCtFVkVeMvcBlePeDTw8AiJYpoMnCvQCmXIruKjlLyiPbXBfTeb54BKppx7zy8xXs1iu7r9UlSIdEpMacJ8hGmBsjrgtttpK9dfMNavbBA3qCQXlCyuukIc75W947xGvLvC873yDVfZudltnj9GRXG6nVlMp9xOFlXe0yIxnzs823XClRQs3jJ2im+diWGdoxkV8E4l8z+hObHdsjl9LlfeDud97jLnO93DQ2a0kcHJLykO/WWZvEvstm2zLFuxcOxE/dkZxF77hGqSWRjXy40CqT7FmpfKGCsVoMq4VpPHqB4wpE40i2QeEqO8K+vpO7u+s8H+lq3iLzvYuktMS9624hp5INoq3YelhzCV9jBpS5WUQ1FIoTWol6FM1/R7mlpVe5x2rz0jhfydSmy0/RgQLHiTJ6PvSjO3ux73e9ZX3cZrG6VnTfRPUSwrpXOoPsGuj+lxndEM3FkPMneCOhrU3jl2hydN46mnvB3dPndJPRCDC31vESiaXOyp0YqvJv8vnQB3kqmT0WIfdKc6D3PGeR/pns7psHqIfG0Jr4YruAATbHK6cgEOk6cYo7VV07DQiQ7y5uIa4eBA3TMZpHDT3JWdv3fOTzOusZ';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.memory(
                base64.decode(url),
                height: 312,
                width: 175.3,
                fit: BoxFit.fill,
                gaplessPlayback: true,
              ),
              SizedBox(height: 30),
              RaisedButton(
                child: Text('Show Image'),
                onPressed: () async {
                  final imgBase64Str = await networkImageToBase64(
                      "https://i.pinimg.com/564x/b0/da/ac/b0daac950c00bf2fefe8e923b7b64c40.jpg");
                },
              ),
              RaisedButton(
                child: Text('share to WhatsApp'),
                onPressed: () async {
                  final imgBase64Str = await networkImageToBase64(
                      "https://i.pinimg.com/564x/b0/da/ac/b0daac950c00bf2fefe8e923b7b64c40.jpg");
                  print('object>>>>>' +'data:image/jpeg;base64,' +  imgBase64Str);
                  FlutterShareMe()
                      .shareToWhatsApp(base64Image: 'data:image/jpeg;base64,' + imgBase64Str, msg: msg);
                },
              ),
              RaisedButton(
                child: Text('share to shareFacebook'),
                onPressed: () {
                  FlutterShareMe().shareToFacebook(
                      url: 'https://i.pinimg.com/564x/b0/da/ac/b0daac950c00bf2fefe8e923b7b64c40.jpg', msg: msg);
                },
              ),
              RaisedButton(
                child: Text('share to System'),
                onPressed: () async {
                  var response = await FlutterShareMe().shareToSystem(msg: msg);
                  if (response == 'success') {
                    print('navigate success');
                  }
                },
              ),


              RaisedButton(
                onPressed: (){takeScreenShot();},
                child: Text("ScreenShot"),
              ),


              // RaisedButton(
              //   onPressed: () async {
              //     image();
              //   },
              //   child: Text("Share On Facebook Story"),
              // ),

              RaisedButton(
                onPressed: () async {
                  var request = await HttpClient().getUrl(Uri.parse(imagePath));
                  var response = await request.close();
                  Uint8List bytes =
                  await consolidateHttpClientResponseBytes(response);
                  await easyShare.Share.file('ESYS AMLOG', 'amlog.jpg', bytes, 'image/jpg');
                },
                child: Text("Share Image(Tack Some Time)"),
              ),

              // RaisedButton(
              //   onPressed: () async {
              //     socialShare.SocialShare.shareSms("This is Social Share Sms example",
              //         url: "\nhttps://google.com/",
              //         trailingText: "\nhello")
              //         .then((data) {
              //       print(data);
              //     });
              //   },
              //   child: Text("Share on Sms(Only Text & Url)"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
