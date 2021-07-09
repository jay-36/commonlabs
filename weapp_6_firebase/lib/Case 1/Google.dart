// firebase_core: ^0.5.0
// firebase_auth: ^0.18.0+1
// google_sign_in: ^4.5.3

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:weapp_6_firebase/Case%201/Facebook%20Login.dart';
import 'package:weapp_6_firebase/Case%201/Share.dart';
import 'package:weapp_6_firebase/Case%201/instagram.dart';
import 'package:weapp_6_firebase/Case%201/Loading.dart';
import 'package:http/http.dart' as http;

class SocialLoginButtonList extends StatefulWidget {
  @override
  _SocialLoginButtonListState createState() => _SocialLoginButtonListState();
}

class _SocialLoginButtonListState extends State<SocialLoginButtonList> {
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
                    builder: (context) => LoginPageWidget(),
                  ));
            },
            child: Text("Google"),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FaceBookLoginDemo(),
                  ));
            },
            child: Text("FaceBook"),
          ),
          RaisedButton(
            onPressed: () async {
              // var res = await http.get('https://instagram.com/chhotte_raja36/?__a=1');
              // print(res.body);
              // Dio().get('https://instagram.com/chhotte_raja36/?__a=1').then((val){print(val.data['graphql']['user']);});
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(),
                  ));
            },
            child: Text("Instagram"),
          ),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShareMeDemo(),
                  ));
            },
            child: Text("Share"),
          ),
        ],
      ),
    ));
  }
}

class LoginPageWidget extends StatefulWidget {
  @override
  LoginPageWidgetState createState() => LoginPageWidgetState();
}

class LoginPageWidgetState extends State<LoginPageWidget> {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  FirebaseAuth _auth;

  bool isUserSignedIn = false;

  @override
  void initState() {
    super.initState();
    initApp();
    // _googleSignIn.signOut();
  }

  void initApp() async {
    FirebaseApp defaultApp = await Firebase.initializeApp();
    _auth = FirebaseAuth.instanceFor(app: defaultApp);
    checkIfUserIsSignedIn();
  }

  void checkIfUserIsSignedIn() async {
    var userSignedIn = await _googleSignIn.isSignedIn();

    setState(() {
      isUserSignedIn = userSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(50),
        child: Align(
          alignment: Alignment.center,
          child: FlatButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onPressed: () {
              isUserSignedIn ? onGoogleSignIn(context) : login();
            },
            color: isUserSignedIn ? Colors.green : Colors.blueAccent,
            child: Padding(
              padding: EdgeInsets.all(1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.account_circle, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                      isUserSignedIn
                          ? 'You\'re logged in with Google'
                          : 'Login with Google',
                      style: TextStyle(color: Colors.white))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void login() {
    handleSubmit(context);
    onGoogleSignIn(context);
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

  Future<User> _handleSignIn() async {
    User user;
    bool userSignedIn = await _googleSignIn.isSignedIn();

    setState(() {
      isUserSignedIn = userSignedIn;
    });

    if (isUserSignedIn) {
      user = _auth.currentUser;
    } else {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      user = (await _auth.signInWithCredential(credential)).user;
      userSignedIn = await _googleSignIn.isSignedIn().whenComplete(() {
        Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
      });
      setState(() {
        isUserSignedIn = userSignedIn;
      });
    }
    return user;
  }

  void onGoogleSignIn(BuildContext context) async {
    await _handleSignIn().then((User value) async {
    var userSignIn = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => WelcomeUserWidget(
                image: value.photoURL,
                email: value.email,
                name: value.displayName,
                googleSignIn: _googleSignIn)),
      );
      if(mounted){
        setState(() {
          isUserSignedIn = userSignIn == null ? true : false;
        });
      }
      return;
    }).catchError((onError) {
      print("ss");
      Navigator.of(globalKey.currentContext, rootNavigator: true).pop();
    });
  }
}

//   void onGoogleSignIn(BuildContext context) async {
//     User user = await _handleSignIn().catchError((onError){
//       print("ss");
//     }).then((User value) {
//       print(value.email);
//       return;
//     });
//     var userSignedIn = await Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: (context) => WelcomeUserWidget(user, _googleSignIn)),
//     );
//     setState(() {
//       isUserSignedIn = userSignedIn == null ? true : false;
//     });
//   }
// }

class WelcomeUserWidget extends StatelessWidget {
  GoogleSignIn googleSignIn;
  String name;
  String image;
  String email;

  WelcomeUserWidget({this.email, this.image, this.name, this.googleSignIn});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google"),
      ),
      body: Container(
        padding: EdgeInsets.all(50),
        child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipOval(
                  child: Image.network(image,
                      width: 100, height: 100, fit: BoxFit.cover)),
              SizedBox(height: 20),
              Text('Welcome,', textAlign: TextAlign.center),
              Text(name,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
              SizedBox(height: 20),
              Text(
                email,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              SizedBox(height: 20),
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onPressed: () {
                  googleSignIn.signOut().then((value) {
                    Navigator.pop(context, false);
                  }).catchError((onError) {
                    print("Error 1");
                  });
                },
                color: Colors.redAccent,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.exit_to_app, color: Colors.white),
                      SizedBox(width: 10),
                      Text('Log out of Google',
                          style: TextStyle(color: Colors.white))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
