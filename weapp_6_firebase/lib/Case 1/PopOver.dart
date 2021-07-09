import 'package:flutter/material.dart';
import 'package:popup_menu/popup_menu.dart';

class PopOverItemDemo extends StatefulWidget {
  @override
  _PopOverItemDemoState createState() => _PopOverItemDemoState();
}

class _PopOverItemDemoState extends State<PopOverItemDemo> {
  PopupMenu menu;
  GlobalKey btnKey = GlobalKey();
  GlobalKey btnKey2 = GlobalKey();
  Color color = Colors.red;

  @override
  void initState() {
    super.initState();

    menu = PopupMenu(items: [
      MenuItem(
          title: 'Mail',
          image: Icon(
            Icons.mail,
            color: Colors.white,
          )),
      MenuItem(
          title: 'Power',
          image: Icon(
            Icons.power,
            color: Colors.white,
          )),
      MenuItem(
          title: 'Setting',
          image: Icon(
            Icons.settings,
            color: Colors.white,
          )),
      MenuItem(
          title: 'PopupMenu',
          image: Icon(
            Icons.menu,
            color: Colors.white,
          ))
    ], onClickMenu: onClickMenu, onDismiss: onDismiss, maxColumn: 1);
  }

  void stateChanged(bool isShow) {
    print('menu is ${isShow ? 'showing' : 'closed'}');
  }

  void onClickMenu(MenuItemProvider item) {
    print('Click menu -> ${item.menuTitle}');
    if(item.menuTitle == "Power"){
      setState(() {
        color = Colors.teal;
      });
      print("p");
    }else if(item.menuTitle == "Setting"){
      print("s");
      setState(() {
        color = Colors.amber;
      });
    }else if(item.menuTitle == "Home"){
      print("s");
      setState(() {
        color = Colors.pinkAccent;
      });
    }else if(item.menuTitle == "Mail"){
      print("s");
      setState(() {
        color = Colors.indigo;
      });
    }else if(item.menuTitle == "PopupMenu"){
      print("s");
      setState(() {
        color = Colors.greenAccent;
      });
    }
  }

  void onDismiss() {
    print('Menu is dismiss');
  }

  @override
  Widget build(BuildContext context) {
    PopupMenu.context = context;

    return Scaffold(
      appBar: AppBar(
        title: Text("Pop Over"),
        actions: <Widget>[
          IconButton(
            key: btnKey2,
            icon: Icon(Icons.menu),
            onPressed: () {
              customBackground();
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            child: RaisedButton(
              key: btnKey,
              onPressed: (){
                maxColumn();
              },
              child: Text('Show Menu'),
            ),
          ),
          SizedBox(height: 10,),
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: color
            ),
          )

        ],
      ),
    );
  }


  void checkState(BuildContext context) {
    final snackBar = new SnackBar(content: new Text('SnackBar!'));

    Scaffold.of(context).showSnackBar(snackBar);
  }

  void maxColumn() {
    PopupMenu menu = PopupMenu(
      backgroundColor: Colors.teal,
      lineColor: Colors.tealAccent,
        maxColumn: 3,
        items: [
          MenuItem(
              title: 'Power',
              image: Icon(
                Icons.power,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Setting',
              image: Icon(
                Icons.settings,
                color: Colors.white,
              )),
          MenuItem(
              title: 'PopupMenu',
              image: Icon(
                Icons.menu,
                color: Colors.white,
              ))
        ],
        onClickMenu: onClickMenu,
        stateChanged: stateChanged,
        onDismiss: onDismiss);
    menu.show(widgetKey: btnKey);
  }

  //
  void customBackground() {
    PopupMenu menu = PopupMenu(
      // backgroundColor: Colors.teal,
      // lineColor: Colors.tealAccent,
      maxColumn: 1,
        items: [
          MenuItem(
              title: 'Home',
              // textStyle: TextStyle(fontSize: 10.0, color: Colors.tealAccent),
              image: Icon(
                Icons.home,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Mail',
              image: Icon(
                Icons.mail,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Power',
              image: Icon(
                Icons.power,
                color: Colors.white,
              )),
          MenuItem(
              title: 'Setting',
              image: Icon(
                Icons.settings,
                color: Colors.white,
              )),
          MenuItem(
              title: 'PopupMenu',
              image: Icon(
                Icons.menu,
                color: Colors.white,
              ))
        ],
        onClickMenu: onClickMenu,
        stateChanged: stateChanged,
        onDismiss: onDismiss);
    menu.show(widgetKey: btnKey2);
  }
}


