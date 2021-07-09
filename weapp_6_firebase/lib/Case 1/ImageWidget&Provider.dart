import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

import 'package:weapp_6_firebase/Case%201/GalleryView.dart';


class ImagePickerButtonList extends StatefulWidget {
  @override
  _ImagePickerButtonListState createState() => _ImagePickerButtonListState();
}

class _ImagePickerButtonListState extends State<ImagePickerButtonList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DelegatesDemo(),
                      ));
                },
                child: Text("Gallery View"),
              ),
              RaisedButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DemoImagePicker(),
                      ));
                },
                child: Text("Images Type & Image Picker"),
              ),
              RaisedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageLoaderDemo(),
                      ));
                },
                child: Text("Image Loader"),
              ),
            ],
          ),
        ));
  }
}






class DemoImagePicker extends StatefulWidget {
  @override
  _DemoImagePickerState createState() => _DemoImagePickerState();
}
class _DemoImagePickerState extends State<DemoImagePicker> {
  PickedFile _imageFile;
  dynamic _pickImageError;
  String _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController qualityController = TextEditingController();

  String _base64;

  @override
  void initState() {
    super.initState();
    (() async {
      http.Response response = await http.get(

        'https://thebhakti.com/wp-content/uploads/2019/01/mahakal.jpg',
      );
      if (mounted) {
        setState(() {
          _base64 = Base64Encoder().convert(response.bodyBytes);
        });
      }
    })();
  }

  void _onImageButtonPressed(ImageSource source, {BuildContext context}) async {
    await _displayPickImageDialog(context, (int quality) async {
      try {
        final pickedFile = await _picker.getImage(
          source: source,
          imageQuality: quality,
        );
        setState(() {
          _imageFile = pickedFile;
        });
        print(_imageFile.path.toString());
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    });
  }

  @override
  void dispose() {
    qualityController.dispose();
    super.dispose();
  }

  Widget _previewImage() {
    if (_imageFile != null) {
      return Semantics(
          button: true,
          onTap: () {
            print("OnTap");
          },
          child: Stack(
            children: [
              Image.file(
                File(_imageFile.path),
                fit: BoxFit.cover,
              ),
              Positioned(
                  top: 20,
                  right: 30,
                  child: Text(
                    "Image.file",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ))
            ],
          ),
          label: 'image_picker_example_picked_image');
    } else {
      return Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MXx8aHVtYW58ZW58MHx8MHw%3D&ixlib=rb-1.2.1&w=1000&q=80",
            fit: BoxFit.cover,
          ),
          Positioned(
              top: 20,
              right: 30,
              child: Text(
                "Image.network",
                style: TextStyle(color: Colors.black, fontSize: 20),
              ))
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_base64 == null) return new Container();
    Uint8List bytes = Base64Codec().decode(_base64);
    return Scaffold(
      appBar: AppBar(
        title: Text("appbar"),
      ),
      body: Center(
          child: Stack(
            children: [
              Container(
                child: _previewImage(),
              ),
              Container(
                color: Colors.black54,
              ),
              Align(
                  alignment: AlignmentDirectional.bottomCenter,
                  child: Container(
                      height: 150,
                      child: Stack(
                        children: [
                          Image.asset(
                            "assets/jay.png",
                          ),
                          Text(
                            "Image.Assets",
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ))),
              Align(
                alignment: AlignmentDirectional.bottomStart,
                child: CircleAvatar(
                  radius: 70.0,
                  backgroundImage: NetworkImage(
                      "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MXx8aHVtYW58ZW58MHx8MHw%3D&ixlib=rb-1.2.1&w=1000&q=80"),
                  child: Text("NetworkImage"),
                ),
              ),

            ],
          )),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          SizedBox(height: 100,),
          Semantics(
            label: 'image_picker_example_from_gallery',
            child: FloatingActionButton(
              onPressed: () {
                _onImageButtonPressed(ImageSource.gallery, context: context);
              },
              heroTag: 'image0',
              tooltip: 'Pick Image from gallery',
              child: const Icon(Icons.photo_library),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: FloatingActionButton(
              onPressed: () {
                _onImageButtonPressed(ImageSource.camera, context: context);
              },
              heroTag: 'image1',
              tooltip: 'Take a Photo',
              child: const Icon(Icons.camera_alt),
            ),
          ),
          Spacer(),
          SizedBox()
        ],
      ),
    );
  }

  Future<void> _displayPickImageDialog(
      BuildContext context, OnPickImageCallback onPick) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add optional parameters'),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: qualityController,
                    keyboardType: TextInputType.number,
                    decoration:
                    InputDecoration(hintText: "Enter quality if desired"),
                  ),
                ],
              ),
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
                    int quality = qualityController.text.isNotEmpty
                        ? int.parse(qualityController.text)
                        : null;
                    onPick(quality);
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }
}

typedef void OnPickImageCallback(int quality);


class ImageLoaderDemo extends StatefulWidget {
  @override
  _ImageLoaderDemoState createState() => _ImageLoaderDemoState();
}

class _ImageLoaderDemoState extends State<ImageLoaderDemo> {
  String imgUrl = "https://jaylukhi.000webhostapp.com/images/dsc01418.jpg";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        child: Image.network(imgUrl,fit: BoxFit.cover,
          loadingBuilder: (BuildContext context,
              Widget child,
              ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                    : null,
              ),
            );
          },
        ),
      )
    );
  }
}
