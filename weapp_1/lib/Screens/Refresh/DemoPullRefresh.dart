import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart' as provider;
import 'package:weapp_1/Screens/Api/GET/UserDetail.dart';
import 'package:weapp_1/Screens/Provider/Provider.dart';

class LazyLoadingDemo extends StatefulWidget {
  @override
  _LazyLoadingDemoState createState() => _LazyLoadingDemoState();
}

class _LazyLoadingDemoState extends State<LazyLoadingDemo> {
  var wallpaperArray = List<WallpaperModel>();
  int _page = 1;
  var _gridController = ScrollController();

  getTrendingWallpaper(int page) async {
    var response = await http.get(
        "https://api.pexels.com/v1/search?query=cars&per_page=15&page=$page",
        headers: {
          "Authorization":
              "563492ad6f91700001000001715d27a35191420bb2fd25eab0fe0853"
        });
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
                child: GridView.builder(
                    addAutomaticKeepAlives: true,
                    controller: _gridController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.55,
                    ),
                    itemCount: wallpaperArray.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 1, vertical: 1),
                        child: GestureDetector(
                          onTap: () async {},
                          // child: ClipRRect(
                          //     child: ExtendedImage.network(
                          //
                          //   wallpaperArray[index].src.portrait,
                          //
                          //   fit: BoxFit.cover,clearMemoryCacheWhenDispose: true,
                          //   cache: true,gaplessPlayback: true,
                          //   enableMemoryCache: true,
                          //       cacheHeight: 550,
                          //       cacheWidth: 300,
                          //
                          // )
                          child: CachedNetworkImage(
                            repeat: ImageRepeat.noRepeat,

                            imageUrl: wallpaperArray[index].src.portrait,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Center(child: CircularProgressIndicator()),

                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),

                        // child: FadeInImage(
                        //   placeholder: AssetImage("assets/jay.png"),
                        //   fit: BoxFit.cover,
                        //   fadeInCurve: Curves.easeIn,
                        //   image: NetworkImage(wallpaperArray[index].src.portrait,),
                        // ),
                      );
                    }),
              )
            : Center(child: CircularProgressIndicator()));
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
      body: list.length != 0
          ? RefreshIndicator(
              key: refreshKey,
              child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) => ListTile(
                  title: Text(list[i]),
                ),
              ),
              onRefresh: refreshList,
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class ListData {
  final int albumId;
  final int id;

  final String title;
  final String url;
  final String thumbnailUrl;

  ListData({this.albumId, this.id, this.title, this.url, this.thumbnailUrl});

  factory ListData.fromJson(Map<String, dynamic> jsonData) {
    return ListData(
      albumId: jsonData['albumId'],
      id: jsonData['id'],
      title: jsonData['title'],
      url: jsonData['url'],
      thumbnailUrl: jsonData['thumbnailUrl'],
    );
  }
}
