import 'package:flutter/material.dart';

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {

  final GlobalKey<NavigatorState> _navigator = new GlobalKey<NavigatorState>();

  int currentIndex = 0;

  _funOnTap(int index){
    switch(index){
      case 0:
        _navigator.currentState.pushReplacementNamed("0");
        break;
      case 1:
        _navigator.currentState.pushReplacementNamed("1");
        break;
      case 2:
        _navigator.currentState.pushReplacementNamed("2");
        break;
    }
    setState(() {
      currentIndex = index;
    });
  }

  Route<dynamic> NavigateRoute(RouteSettings settings){
    switch(settings.name){
      case "0":
        return MaterialPageRoute(builder: (context) => Container(color: Colors.blue,child: Center(child: Text("0"))));
      case "1":
        return MaterialPageRoute(builder: (context) => Container(color: Colors.redAccent,child: Center(child: Text("1"))));
      default:
          return MaterialPageRoute(builder: (context) => Container(color: Colors.greenAccent,child: Center(child: Text("2"))));

    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Bottom NavigationBar")),
      body: Navigator(key: _navigator,onGenerateRoute: NavigateRoute,),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _funOnTap,
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.event),title: Text("0"),),
          BottomNavigationBarItem(icon: Icon(Icons.close),title: Text("1")),
          BottomNavigationBarItem(icon: Icon(Icons.event),title: Text("2")),
        ],
      ),
    );
  }
}
