import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isLoading = true;
  Map<String, dynamic> data = Map<String, dynamic>();
  List<Widget> columnRowList = [];
  List<Widget> folderElements = [];
  double height = 0;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  loadInitialData() async {
    try {
      await parseJsonFromAssets('assets/tree_array.json').then((dmap) {
        data = json.decode(dmap);
      });
      isLoading = false;
      loadFirstLevelFolders();
      setState(() {});
    } on Exception catch (e) {
      print(e);
      isLoading = false;
    }
  }

  openFolder(List<dynamic> folders, int folderLevel) {
    List<Widget> widgetList = [];

    if (columnRowList.length != folderLevel)
    {
      print(">>"+columnRowList.length.toString());
      print(">>"+folderLevel.toString());
      print(columnRowList[0]);
      if(folderLevel < columnRowList.length){
        print("less");
        columnRowList.removeRange(folderLevel, columnRowList.length);
        setState(() {});
        if (folders.length != 0) {
          folders.forEach((element) {
            widgetList.add(Folder(
              id: element['id'],
              name: element['name'],
              folders: element['folder'],
              folderLevel: columnRowList.length + 1,
              openFolder: openFolder,
            ));
          });
          columnRowList.add(SingleChildScrollView(
            child: Column(
              children: widgetList,
            ),
          ));
          setState(() {});
        }
      }
      return ;
    }


    if (folders.length != 0) {
      folders.forEach((element) {
        widgetList.add(Folder(
          id: element['id'],
          name: element['name'],
          folders: element['folder'],
          folderLevel: columnRowList.length + 1,
          openFolder: openFolder,
        ));
      });
      columnRowList.add(SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: widgetList,
        ),
      ));
      setState(() {});
    }
  }

  loadFirstLevelFolders() {
    List<Widget> widgetList = [];
    (data["data"] as List).forEach((element) {
      widgetList.add(Folder(
        id: element['id'],
        name: element['name'],
        folders: element['folder'],
        folderLevel: columnRowList.length + 1,
        openFolder: openFolder,
      ));
    });
    columnRowList.add(SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgetList,
      ),
    ));
  }

  goBack() {
    if (columnRowList.length == 1) return;
    columnRowList.removeLast();
    setState(() {});
  }

  Future<String> parseJsonFromAssets(String assetsPath) async {
    return rootBundle.loadString(assetsPath);
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    height = mediaQuery.size.height -
        AppBar().preferredSize.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Finder"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (var i = 0; i < columnRowList.length; i++)
              Container(
                height: height,
                child: columnRowList[i],
              )
          ],
        ),
      ),
      floatingActionButton: columnRowList.length > 1
          ? FloatingActionButton(
        child: const Icon(Icons.arrow_back),
        onPressed: goBack,
      )
          : const Text(""),
    );
  }
}


class Folder extends StatefulWidget {
  int id;
  String name;
  int folderLevel;
  List<dynamic> folders;
  Function openFolder;

  Folder({this.id, this.name, this.folders, this.folderLevel, this.openFolder});

  @override
  _FolderState createState() => _FolderState();
}

class _FolderState extends State<Folder> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(widget.id);
        widget.openFolder(widget.folders, widget.folderLevel);
      },
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.name ?? ''),
            widget.folders.length != 0 ? Icon(Icons.arrow_forward_ios,size: 15,) : Container()
          ],
        ),
      ),
    );
  }
}
