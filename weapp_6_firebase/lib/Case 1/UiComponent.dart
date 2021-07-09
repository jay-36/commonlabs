import 'package:flutter/material.dart';
import 'package:weapp_6_firebase/Case%201/ActionSheetBar.dart';
import 'package:weapp_6_firebase/Case%201/PopOver.dart';
import 'package:weapp_6_firebase/Case 1/FlutterSliver.dart';

class UiComponentButtonList extends StatefulWidget {
  @override
  _UiComponentButtonListState createState() => _UiComponentButtonListState();
}

class _UiComponentButtonListState extends State<UiComponentButtonList> {
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
                    builder: (context) => ControlsDemo(),
                  ));
            },
            child: Text("Controls"),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FlutterSliverDemo(),
                  ));
            },
            child: Text("Flutter Sliver"),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TabBarDemo(),
                  ));
            },
            child: Text("Sliver Tab Bar"),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavigationDemo(),
                  ));
            },
            child: Text("Bottom Navigation Bar & Drawer"),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PopOverItemDemo(),
                  ));
            },
            child: Text("Pop Over"),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActionSheetDemo(),
                  ));
            },
            child: Text("Action Sheet"),
          ),
        ],
      ),
    ));
  }
}

class TabBarDemo extends StatefulWidget {
  @override
  _TabBarDemoState createState() => _TabBarDemoState();
}

class _TabBarDemoState extends State<TabBarDemo> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              new SliverAppBar(
                title: Text('Sliver Tabs Demo'),
                pinned: true,
                centerTitle: true,
                floating: true,
                bottom: TabBar(
                  isScrollable: true,
                  tabs: [
                    Tab(child: Text('Flight')),
                    Tab(child: Text('Train')),
                    Tab(child: Text('Car')),
                    Tab(child: Text('Cycle')),
                    Tab(child: Text('Boat')),
                  ],
                ),
              ),
            ];
          },
          body: TabBarView(
            children: <Widget>[
              Icon(Icons.flight, size: 350),
              Icon(Icons.directions_transit, size: 350),
              Icon(Icons.directions_car, size: 350),
              Icon(Icons.directions_bike, size: 350),
              Icon(Icons.directions_boat, size: 350),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomNavigationDemo extends StatefulWidget {
  @override
  _BottomNavigationDemoState createState() => _BottomNavigationDemoState();
}

class _BottomNavigationDemoState extends State<BottomNavigationDemo> {
  int _selectedIndex = 0;

  bool change = false;

  Text pageTwo() => Text('Search Page',
      style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold));

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      change == false
          ? Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                    onPressed: () {
                      setState(() {
                        change = true;
                      });
                    },
                    child: Text("1"),
                  ),
                ],
              ))
          : Container(
              child: Column(
              children: [
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      change = false;
                    });
                  },
                  child: Text("back"),
                ),
              ],
            )),
      Container(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RaisedButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => PageTwo()));
            },
            child: Text("Second Screen"),
          ),
        ],
      )),
      Text('Profile Page',
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold)),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bottom Navigation Bar'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/travelimage0.jpg'))),
                child: Stack(children: <Widget>[
                  Positioned(
                      bottom: 12.0,
                      left: 16.0,
                      child: Text("Welcome to Flutter",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500))),
                ])),
            createDrawerBodyItem(icon: Icons.home, text: 'Home'),
            createDrawerBodyItem(icon: Icons.account_circle, text: 'Profile'),
            createDrawerBodyItem(icon: Icons.event_note, text: 'Events'),
            Divider(),
            createDrawerBodyItem(
                icon: Icons.notifications_active, text: 'Notifications'),
            createDrawerBodyItem(
                icon: Icons.contact_phone, text: 'Contact Info'),
            ListTile(
              title: Text('App version 1.0.0'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.orange,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text('Search'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.white,
          iconSize: 25,
          onTap: _onItemTapped,
          elevation: 5),
    );
  }
}

Widget createDrawerBodyItem({IconData icon, String text, GestureTapCallback onTap}) {
  return ListTile(
    title: Row(
      children: <Widget>[
        Icon(icon),
        Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Text(text),
        )
      ],
    ),
    onTap: onTap,
  );
}

class PageTwo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
      ),
      body: Container(
        child: Center(
          child: RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Back")),
        ),
      ),
    );
  }
}

class ControlsDemo extends StatefulWidget {
  @override
  _ControlsDemoState createState() => _ControlsDemoState();
}

class _ControlsDemoState extends State<ControlsDemo> {
  Color color = Colors.red;
  final _formKey = GlobalKey<FormState>();
  TextEditingController one = TextEditingController()..text = "12";
  TextEditingController two = TextEditingController();
  String radioItem = 'Male';
  bool switchButton = true;
  int selectedRadio = 1;
  TimeOfDay selectedTime = TimeOfDay.now();
  String dateTime;
  bool checkOne = false;
  bool checkTwo = false;
  bool checkOneCustom = false;
  bool checkTwoCustom = false;
  FocusNode oneNode;
  FocusNode twoNode;
  FocusNode button;
  bool radioOne = true;
  bool radioTwo = false;



  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  FocusNode _textFieldFocus = FocusNode();
  FocusNode _textFieldFocusTwo = FocusNode();
  Color _color = Colors.red.withOpacity(0.0);
  Color _colorTwo = Colors.red.withOpacity(0.0);

  @override
  void initState() {
    _textFieldFocus.addListener((){
      if(_textFieldFocus.hasFocus){
        setState(() {
          _color = Colors.blue;
        });
      }else{
        setState(() {
          _color = Colors.blue.withOpacity(0.5);
        });
      }
    });
    _textFieldFocusTwo.addListener((){
      if(_textFieldFocusTwo.hasFocus){
        setState(() {
          _colorTwo = Colors.green;
        });
      }else{
        setState(() {
          _colorTwo = Colors.green.withOpacity(0.5);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Controls"),
      ),
      body: Container(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    color: color,
                  ),
                  Switch(
                    value: switchButton,
                    onChanged: (val) {
                      switchButton = val;
                      switchButton
                          ? color = Colors.black
                          : color = Colors.green;
                      setState(() {});
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: one,
                  focusNode: _textFieldFocus,
                  maxLength: 5,
                  validator: validator,
                  cursorColor: Colors.orange,
                  onTap: () {
                    setState(() {
                      color = Colors.green;
                    });
                  },
                  onChanged: (val) {
                    setState(() {
                      color = Colors.black;
                    });
                  },
                  onFieldSubmitted: (value) {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      oneNode.unfocus();
                      setState(() {
                        color = Colors.blue;
                      });
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    fillColor: _color,
                    filled: true,
                    hintText: "Enter Something",
                    counter: Offstage(),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  maxLines: 2,
                  controller: two,
                  focusNode: _textFieldFocusTwo,
                  cursorColor: Colors.orange,
                  validator: validator,
                  onTap: () {
                    // oneNode.unfocus();
                    setState(() {
                      color = Colors.purple;
                    });
                  },
                  onFieldSubmitted: (value) {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      twoNode.unfocus();
                      setState(() {
                        color = Colors.blue;
                      });
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Enter Something",
                    fillColor: _colorTwo,
                    filled: true,
                  ),
                ),
              ),
              Row(
                children: [
                  Radio(
                    value: 1,
                    groupValue: selectedRadio,
                    activeColor: Colors.green,
                    onChanged: (val) {
                      print("Radio $val");
                      setSelectedRadio(val);
                      setState(() {
                        radioItem = "Male";
                      });
                    },
                  ),
                  Text("Male"),
                  Radio(
                    value: 2,
                    groupValue: selectedRadio,
                    activeColor: Colors.blue,
                    onChanged: (val) {
                      print("Radio $val");
                      setSelectedRadio(val);
                      setState(() {
                        radioItem = "Female";
                      });
                    },
                  ),
                  Text("Female"),
                  Spacer(),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        radioTwo = false;
                        radioOne = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 2,color: radioOne ? Colors.amber : Colors.grey)
                      ),
                      child: Container(
                        padding: EdgeInsets.all(4.0),
                        margin: EdgeInsets.all(3.0),
                        color: radioOne ? Colors.amber : Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Text("Male"),
                  SizedBox(width: 10),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        radioTwo = true;
                        radioOne = false;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(width: 2,color: radioTwo ? Colors.amber : Colors.grey)
                      ),
                      child: Container(
                        padding: EdgeInsets.all(4.0),
                        margin: EdgeInsets.all(3.0),
                        color: radioTwo ? Colors.amber : Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(width: 5),
                  Text("Female"),
                  SizedBox(width: 5),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: checkOne,
                    onChanged: (bool value) {
                      setState(() {
                        checkOne = value;
                      });
                    },
                  ),
                  Text("One"),
                  Checkbox(
                    value: checkTwo,
                    activeColor: Colors.red,
                    checkColor: Colors.black,
                    onChanged: (bool value) {
                      checkTwo
                          ? color = Colors.cyanAccent
                          : color = Colors.amber;

                      checkTwo = value;
                      setState(() {});
                    },
                  ),
                  Text("Two"),
                  Spacer(),
                  GestureDetector(
                    onTap: (){
                      if(checkOneCustom == true){
                        setState(() {
                          print("1");
                          checkOneCustom = false;
                        });
                      }else{
                        setState(() {
                          print("2");
                          checkOneCustom = true;
                        });
                      }
                    },
                    child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            border: Border.all(width: 2,color: checkOneCustom ? Colors.green : Colors.grey),
                            color: checkOneCustom ? Colors.green : Colors.black.withOpacity(0.0)
                        ),
                        child: Center(child: Icon(checkOneCustom ? Icons.done : Icons.close,size: 15,color: checkOneCustom ? Colors.black : Colors.white,))
                    ),
                  ),
                  SizedBox(width: 5),
                  Text("One"),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: (){
                      if(checkTwoCustom == true){
                        setState(() {
                          print("1");
                          checkTwoCustom = false;
                        });
                      }else{
                        setState(() {
                          print("2");
                          checkTwoCustom = true;
                        });
                      }
                    },
                    child: Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100.0),
                            border: Border.all(width: 2,color: checkTwoCustom ? Colors.green : Colors.grey),
                            color: checkTwoCustom ? Colors.green : Colors.black.withOpacity(0.0)
                        ),
                        child: Center(child: Icon(checkTwoCustom ? Icons.done : Icons.close,size: 15,color: checkTwoCustom ? Colors.black : Colors.white,))
                    ),
                  ),
                  SizedBox(width: 5),
                  Text("two"),
                  SizedBox(width: 5),
                ],
              ),
              Row(
                children: [
                  Text("${selectedDate.toLocal()}".split(' ')[0]),
                  RaisedButton(focusNode: button,
                    onPressed: () => _selectDate(context),
                    child: Text('Date'),
                  ),
                  Spacer(),
                  RaisedButton(
                    onPressed: () => _selectTime(context),
                    child: Text('Time'),
                  ),
                  Text(selectedTime.format(context)),
                ],
              ),
              RaisedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNaviDemo(),));
              },child: Text("Bottom"),)
            ],
          ),
        ),
      ),
    );
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked_s = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child,
          );
        });
    if (picked_s != null && picked_s != selectedTime)
      setState(() {
        selectedTime = picked_s;
      });
  }
}

String validator(val) {
  if (val.isEmpty) {
    return "Enter Something";
  } else {
    return null;
  }
}


class BottomNaviDemo extends StatefulWidget {
  @override
  _BottomNaviDemoState createState() => _BottomNaviDemoState();
}

class _BottomNaviDemoState extends State<BottomNaviDemo> with SingleTickerProviderStateMixin{


  TabController _pageController;
  bool result = true;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = TabController(length: 5,vsync: this);
  }

@override
void dispose() {
  _pageController.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TabBar"),),
      body: TabBarView(controller:_pageController ,
        children: <Widget>[
          Icon(Icons.flight, size: 350),
          Icon(Icons.directions_transit, size: 350),
          Icon(Icons.directions_car, size: 350),
          Icon(Icons.directions_bike, size: 350),
          Icon(Icons.directions_boat, size: 350),
        ],
      ),
      bottomNavigationBar: TabBar(controller: _pageController,

        isScrollable: false,physics: NeverScrollableScrollPhysics(),
        tabs: [
          Tab(child: Text('Flight')),
          Tab(child: Text('Train')),
          Tab(child: Text('Car')),
          Tab(child: Text('Cycle')),
          Tab(child: Text('Boat')),
        ],
      ),
    );
  }
}
