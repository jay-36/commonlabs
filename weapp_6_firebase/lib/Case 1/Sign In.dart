import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weapp_6_firebase/Case%201/FirebaseButtonList.dart';
import 'package:weapp_6_firebase/Case%201/Loading.dart';

// final FirebaseAuth _auth = FirebaseAuth.instance;

class SignIn extends StatefulWidget {
  final  FirebaseAuth auth;
  SignIn({this.auth});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _passwordController = TextEditingController();
  String error = '';
  Map<String,String> mappingData = Map();
  String user = "";


  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   if(_auth.currentUser == null){
  //     print(">>>> null user");
  //     setState(() {
  //       user = "null";
  //     });
  //   }else{
  //     print(">>>>"+_auth.currentUser.email.toString());
  //     Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage(auth: _auth)));
  //   }
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Builder(builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            withEmailPassword(),
          ],
        );
      }),
    );
  }

  Widget withEmailPassword() {
    return Form(
        key: _formKey,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(user),
                Text(error,style: TextStyle(color: Colors.red),),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: emailValidator,
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value.isEmpty) return 'Please enter some text';
                    return null;
                  },
                  obscureText: true,
                ),
                SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(top: 16.0),
                  alignment: Alignment.center,
                  child: OutlineButton(
                    child: Text("Sign In"),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        handleSubmit(context);
                        widget.auth
                            .signInWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text)
                            .then ((value) {
                          // SharedPreferences prefs = await SharedPreferences.getInstance();
                          // prefs.setString('signUpUser', _emailController.text);
                          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
                          setState(() {
                            error = "";
                          });
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage(auth: widget.auth),));
                        }).catchError((onError){
                          Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
                          print("Error 1");
                          setState(() {
                            error = onError.message;
                          });
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
  GlobalKey<State> globalKey = new GlobalKey<State>();

  Future<void> handleSubmit(BuildContext context) async {
    try {
      Dialogs.showLoadingDialog(context, globalKey);
      Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
    } catch (error) {
      print(error);
    }
  }
}

class MainPage extends StatefulWidget {
  final FirebaseAuth auth;

  const MainPage({Key key, this.auth}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        return showDialog(
          context: context,
          child: new AlertDialog(
            title: const Text("Sign Out"),
            actions: [
              RaisedButton(
                  child: Text("Signout"),
                  onPressed: () {
                    Navigator.pop(context);
                    _signOut();
                  })
            ],
          ),
        );
      },
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.auth.currentUser.photoURL,),
              ),
              Container(
                child: Text(
                  widget.auth.currentUser.email,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Container(
                child: Text(
                  widget.auth.currentUser.uid,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              ),
              Container(
                child: OutlineButton(
                  child: Text("Sign Out"),
                  onPressed: () {
                    _signOut();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future _signOut() async {
    await widget.auth.signOut().then((value){
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SignIn(auth: widget.auth,)));
    }).catchError((onError){
      print(onError.message);
      print("Error 1");
    });
  }
}


Function(String) emailValidator = (String val){
  RegExp emailValid = RegExp(
      r"^[a-z0-9.a-z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  if(val.isEmpty){
    return "Email Should Not Empty";
  }else if (!emailValid.hasMatch(val)) {
    return "Example : example@gmail.com";
  } else {
    return null;
  }
};
