import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transparent_image/transparent_image.dart';

class FirebaseStorageDemo extends StatefulWidget {
  FirebaseStorageDemo({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FirebaseStorageDemoState createState() => _FirebaseStorageDemoState();
}

class _FirebaseStorageDemoState extends State<FirebaseStorageDemo> {
  var storageReference = FirebaseStorage.instance.ref();
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("imageURLs");





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddImage()));
        },
      ),
      body: StreamBuilder(
        stream:  FirebaseFirestore.instance.collection('imageURLs').snapshots().handleError((onError){ print("????????? ");}),
        builder: (context, snapshot) {
          return snapshot.connectionState != ConnectionState.active ? Center(child: Text("Check Connection")) : snapshot.hasError ? Center(child: Text(snapshot.error)): !snapshot.hasData
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  padding: EdgeInsets.all(4),
                  child: StaggeredGridView.countBuilder(
                    crossAxisCount: 2,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Stack(
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewImage(
                                        querySnapshot: snapshot.data,
                                        index: index),
                                  ));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 100,
                              height: MediaQuery.of(context).size.height * 100,
                              margin: EdgeInsets.all(3),
                              child: CachedNetworkImage(
                                imageUrl: snapshot.data.documents[index].get('url'),
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Center(
                                    child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )
                            ),
                          ),
                          Positioned(
                            bottom: 5,
                            right: 5,
                            child: CircleAvatar(
                              backgroundColor: Colors.black54,
                              child: IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    child: new AlertDialog(
                                      title: const Text("Delete"),
                                      content: Text("Are you sure...?"),
                                      actions: [
                                        RaisedButton(
                                            child: Text("Cancel"),
                                            onPressed: ()  {
                                            Navigator.pop(context);
                                            }),
                                        RaisedButton(
                                            child: Text("Done"),
                                            onPressed: () async {
                                              QuerySnapshot qs = await collectionReference.get();
                                              qs.docs[index].reference.delete().then((value) {
                                                Navigator.pop(context);
                                              }).catchError((onError){
                                                print("Error 1");
                                              });
                                            })
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    staggeredTileBuilder: (int index) =>
                        new StaggeredTile.count(1, 1),
                  ),
                );
        },
      ),
    );
  }
}

class AddImage extends StatefulWidget {
  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  bool uploading = false;
  double val = 0;
  CollectionReference imgRef;
  firebase_storage.Reference ref;
  List<File> _image = [];
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Image'),
          actions: [
            FlatButton(
                onPressed: () {
                  setState(() {
                    uploading = true;
                  });
                  uploadFile().whenComplete(() => Navigator.of(context).pop());
                },
                child: Text(
                  'upload',
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(4),
              child: GridView.builder(
                  itemCount: _image.length + 1,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return index == 0
                        ? Center(
                            child: IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () =>
                                    !uploading ? chooseImage() : null),
                          )
                        : Container(
                            margin: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(_image[index - 1]),
                                    fit: BoxFit.cover)),
                          );
                  }),
            ),
            uploading
                ? Center(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: Text(
                          'uploading...',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircularProgressIndicator(
                        value: val,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      )
                    ],
                  ),
            )
                : Container(),
          ],
        ),
    );
  }

  chooseImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery,imageQuality: 50);
    setState(() {
      _image.add(File(pickedFile?.path));
    });
    if (pickedFile.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file.path));
      });
    } else {
      print(response.file);
    }
  }

  Future uploadFile() async {
    int i = 1;

    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/${Path.basename(img.path)}');
      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          imgRef.add({'url': value});
          i++;
          print('Url is => ' + value);
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    imgRef = FirebaseFirestore.instance.collection('imageURLs');
  }
}

class ViewImage extends StatefulWidget {
  final QuerySnapshot querySnapshot;
  int index;
  ViewImage({@required this.querySnapshot, this.index});

  @override
  _ViewImageState createState() => _ViewImageState();
}

class _ViewImageState extends State<ViewImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Stack(
        children: [
          Container(
            //color: Colors.red,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    widget.querySnapshot.docs[widget.index].get('url')),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ),
          Center(
            child: CarouselSlider.builder(
              itemCount: widget.querySnapshot.docs.length,
              options: CarouselOptions(
                  height: MediaQuery.of(context).size.height / 1.2 - 30,
                  enlargeCenterPage: true,
                  initialPage: widget.index,
                  autoPlayInterval: Duration(seconds: 2),
                  autoPlayAnimationDuration: Duration(milliseconds: 2000),
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    setState(() {
                      widget.index = index;
                    });
                  }),
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: FadeInImage.memoryNetwork(
                      fit: BoxFit.cover,
                      placeholder: kTransparentImage,
                      image:
                          widget.querySnapshot.docs[widget.index].get('url')),
                );
              },
            ),
          )
        ],
      )),
    );
  }
}
