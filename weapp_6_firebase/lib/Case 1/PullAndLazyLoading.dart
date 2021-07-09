import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class LazyAndPullDemo extends StatefulWidget {
  @override
  _LazyAndPullDemoState createState() => _LazyAndPullDemoState();
}

class _LazyAndPullDemoState extends State<LazyAndPullDemo> {
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
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LazyLoadingDemo(),
                      ));
                },
                child: Text("Lazy"),
              ),
              RaisedButton(
                onPressed: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PullDemo(),
                      ));
                },
                child: Text("Pull"),
              ),
            ],
          ),
        )
    );
  }
}



class LazyLoadingDemo extends StatefulWidget {
  @override
  _LazyLoadingDemoState createState() => _LazyLoadingDemoState();
}

class _LazyLoadingDemoState extends State<LazyLoadingDemo> {

  var wallpaperArray = List<WallpaperModel>();
  int _page = 1;
  var _gridController = ScrollController();


  getTrendingWallpaper(int page) async {
    var response = await http.get("https://api.pexels.com/v1/search?query=cars&per_page=15&page=$page", headers: {"Authorization": "563492ad6f91700001000001715d27a35191420bb2fd25eab0fe0853"});
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
      WallpaperModel wallpaperModel = WallpaperModel();
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpaperArray.add(wallpaperModel);
    });
    wallpaperArray.length;
    setState(() {});
  }

  @override
  void initState() {
    getTrendingWallpaper(_page);
    _gridController.addListener(_scrollListener);
    super.initState();
  }

  _loadSearchImages() async {
    setState(() {
      _page = _page + 1;
    });
    var model = await getTrendingWallpaper(_page);
  }

  _scrollListener() {
    if (_gridController.offset >= _gridController.position.maxScrollExtent &&
        !_gridController.position.outOfRange) {
      _loadSearchImages();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: (wallpaperArray.length > 0)
            ? Container(
          child:
          GridView.builder(
              controller: _gridController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.55,
              ),
              itemCount: wallpaperArray.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                  child: GestureDetector(
                      onTap: () async{},
                      child:  ClipRRect(
                        child: FadeInImage(
                          placeholder: AssetImage("assets/images/travelimage0.jpg"),
                          fit: BoxFit.cover,
                          fadeInCurve: Curves.easeIn,
                          image: NetworkImage(wallpaperArray[index].src.portrait,),
                        ),
                      )
                  ),
                );
              }),
        )
            : Center(child: CircularProgressIndicator())
    );
  }
}


class PullDemo extends StatefulWidget {
  @override
  _PullDemoState createState() => _PullDemoState();
}

class _PullDemoState extends State<PullDemo> {
  var list = [];
  var random;
  int min = 1;
  int max = 10;

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    random = Random();
    refreshList();
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      list = List.generate(min + random.nextInt(max - min), (i) => "Item $i");
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pull to refresh"),
      ),
      body: list.length != 0 ? RefreshIndicator(
        key: refreshKey,
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i) => ListTile(
            title: Text(list[i]),
          ),
        ),
        onRefresh: refreshList,
      ) : Center(child: CircularProgressIndicator()),
    );
  }
}



class WallpaperModel{
  String photographer;
  String photographerUrl;
  int photographerId;
  SrcModel src;
  int imageId;

  WallpaperModel({this.photographer,this.photographerId,this.photographerUrl,this.src,this.imageId});

  factory WallpaperModel.fromMap(Map<String,dynamic> jsonData){
    return WallpaperModel(
        src: SrcModel.fromMap(jsonData["src"]),
        photographerUrl: jsonData["photographer_url"],
        photographerId: jsonData["photographer_id"],
        photographer: jsonData["photographer"],
        imageId: jsonData["imageId"]
    );
  }
}

class SrcModel{
  String original;
  String large2x;
  String portrait;
  String medium;
  String small;

  SrcModel({this.original,this.large2x,this.portrait,this.medium,this.small});

  factory SrcModel.fromMap(Map<String,dynamic> jsonData){
    return SrcModel(
        original: jsonData["original"],
        large2x: jsonData["large2x"],
        portrait: jsonData["portrait"],
        medium: jsonData["medium"],
        small: jsonData["small"]
    );
  }
}