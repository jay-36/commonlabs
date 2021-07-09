import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:social_share/social_share.dart';


class SocialShareDemo extends StatefulWidget {
  @override
  _SocialShareDemoState createState() => _SocialShareDemoState();
}

class _SocialShareDemoState extends State<SocialShareDemo> {

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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              RaisedButton(
                onPressed: () async {
                  File file = await ImagePicker.pickImage(
                      source: ImageSource.gallery);
                  SocialShare.shareInstagramStory(file.path, "#ffffff",
                      "#000000", "https://deep-link-url")
                      .then((data) {
                    print(data);
                  });
                },
                child: Text("Share On Instagram Story"),
              ),

              RaisedButton(
                onPressed: () async {
                 getImage();
                  SocialShare.shareInstagramStorywithBackground('$documentDirectory/flutter.jpg',
                      "#ffffff", "#000000", "https://deep-link-url",
                      backgroundImagePath: '$documentDirectory/flutter.jpg');
                },
                child: Text("Share On Instagram Story with background"),
              ),


            ],
          ),
        ),
      ),
    );
  }

}



