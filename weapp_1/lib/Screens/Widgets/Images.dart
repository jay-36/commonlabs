import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

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
              CircleAvatar(
                backgroundImage:
                //path get from devices
                _imageFile != null ? FileImage(File('/storage/emulated/0/Android/data/com.example.weapp_1/files/Pictures/scaled_image_picker1111825891.jpg')) : null,
                // _imageFile != null ? FileImage(File(_imageFile.path)) : null,
                radius: 70,
                child: Text("FileImage",style: TextStyle(color: Colors.white,fontSize: 18),),
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
              Align(
                alignment: AlignmentDirectional.bottomEnd,
                child: CircleAvatar(
                  radius: 70.0,
                  backgroundImage: AssetImage("assets/jay.png"),
                  child: Text(
                    "AssetImage",
                  ),
                ),
              ),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Container(
                    height: 180.0,
                    child: Column(
                      children: [
                        Container(height: 150, child: Image.memory(bytes)),
                        Text(
                          "Image.Memory",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    )),
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: CircleAvatar(
                  radius: 60.0,
                  backgroundImage: MemoryImage(bytes),
                  child: Text(
                    "MemoryImage",
                  ),
                ),
              ),
              Center(
                heightFactor: 5,
                widthFactor: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: 100,
                      width: 180,
                      // foregroundDecoration: BoxDecoration(
                      //   color: Colors.blue
                      // ),
                      // child: Text(
                      //   "Container",
                      //   textAlign: TextAlign.end,
                      //   overflow: TextOverflow.visible,
                      //   semanticsLabel: "aaa",
                      //   softWrap: true,
                      //   strutStyle: StrutStyle.fromTextStyle(TextStyle(
                      //     fontSize: 15,
                      //     height: 1.7,
                      //   )),
                      //   style: TextStyle(
                      //       fontSize: 25,
                      //       fontFamily: 'Exo2',
                      //       // decoration: TextDecoration.underline,
                      //       // backgroundColor: Colors.red[200],
                      //       // decorationStyle: TextDecorationStyle.dashed,
                      //       // fontWeight: FontWeight.w500,
                      //       fontStyle: FontStyle.italic,
                      //       // inherit: false,
                      //       decorationThickness: 5.0,
                      //       height: 2.0,
                      //       shadows: <Shadow>[
                      //         Shadow(
                      //           offset: Offset(10.0, 10.0),
                      //           blurRadius: 3.0,
                      //           color: Color.fromARGB(255, 0, 0, 0),
                      //         ),
                      //       ]),
                      // ),
                      decoration: BoxDecoration(color: Colors.redAccent),
                      // alignment: Alignment.center,
                      child: Text.rich(
                        TextSpan(
                          text: '       he candle flickered\n',
                          style: TextStyle(fontSize: 14, fontFamily: 'Exo2'),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'T',
                              style: TextStyle(fontSize: 37, fontFamily: 'Exo2'),
                            ),
                            TextSpan(
                              text: 'in the moonlight as\n',
                              style: TextStyle(fontSize: 14, fontFamily: 'Exo2'),
                            ),
                            TextSpan(
                              text: 'Dash the bird fluttered\n',
                              style: TextStyle(fontSize: 14, fontFamily: 'Exo2'),
                            ),
                            TextSpan(
                              text: 'off into the distance.',
                              style: TextStyle(fontSize: 14, fontFamily: 'Exo2'),
                            ),
                          ],
                        ),
                      ),
                      transform: Matrix4.rotationZ(0.1),
                      constraints: BoxConstraints.loose(Size.infinite),
                      clipBehavior: Clip.hardEdge,
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 200,
                left: 150,
                right: 150,
                child: RaisedButton(
                  color: Colors.green,
                  highlightColor: Colors.red,
                  // focusColor: Colors.red,
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DemoImagePicker(),
                        ));
                  },
                  child: Text("Button"),
                  autofocus: true,
                  disabledColor: Colors.red,
                  disabledElevation: 2.0,
                  elevation: 10.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
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
            content: Column(
              children: <Widget>[
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
