import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;

class FaceBookLoginDemo extends StatefulWidget {
  @override
  _FaceBookLoginDemoState createState() => _FaceBookLoginDemoState();
}

class _FaceBookLoginDemoState extends State<FaceBookLoginDemo> {
  static final FacebookLogin facebookSignIn = new FacebookLogin();
  String message = 'Getting Session...';
  String name = '';
  String image = '';
  String buttonText = "Login";
  bool login = false;
  bool alreadyLogin = false;
  bool gettingSession = true;

  @override
  void initState() {
    super.initState();
    autoLoginCheck();
  }

  Future<void> autoLoginCheck() async {
    final bool loginCheck = await facebookSignIn.isLoggedIn;
    setState(() {
      alreadyLogin = loginCheck;
    });



    alreadyLogin ? getDataIfAlreadyLogin() : faslse();

  }
  void faslse(){
    setState(() {
      gettingSession = false;
    });
  }

  Future<void> getDataIfAlreadyLogin() async {
    var alreadyLoginToken = await facebookSignIn.currentAccessToken;
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=first_name,picture&access_token=${alreadyLoginToken.token}');
    final profile = jsonDecode(graphResponse.body);
    print(profile['picture']['data']['url']);
    print(profile['first_name']);
    print(graphResponse.body);
    setState(() {
      login = true;
      gettingSession = false;
      name = profile['first_name'];
      image = profile['picture']['data']['url'];
      buttonText = "Logout";
    });
    _showMessage('''
         Logged in!
         Token: ${alreadyLoginToken.token}
         User id: ${alreadyLoginToken.userId}
         Expires: ${alreadyLoginToken.expires}
         Permissions: ${alreadyLoginToken.permissions}
         Declined permissions: ${alreadyLoginToken.declinedPermissions}
         ''');
  }

  Future<Null> _login() async {
    final FacebookLoginResult result = await facebookSignIn.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final FacebookAccessToken accessToken = result.accessToken;
        final graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=first_name,picture&access_token=${accessToken.token}');
        final profile = jsonDecode(graphResponse.body);
        print(profile['picture']['data']['url']);
        print(graphResponse.body);
        setState(() {
          login = true;
          name = profile['first_name'];
          image = profile['picture']['data']['url'];
          buttonText = "Logout";
        });
        _showMessage('''
         Logged in!
         Token: ${accessToken.token}
         User id: ${accessToken.userId}
         Expires: ${accessToken.expires}
         Permissions: ${accessToken.permissions}
         Declined permissions: ${accessToken.declinedPermissions}
         ''');
        print(accessToken.token);
        break;
      case FacebookLoginStatus.cancelledByUser:
        _showMessage('Login cancelled by the user.');
        break;
      case FacebookLoginStatus.error:
        setState(() {
          message = result.errorMessage;
        });
        _showMessage('Something went wrong with the login process.\n'
            'Here\'s the error Facebook gave us: ${result.errorMessage}');
        break;
    }
  }

  Future<Null> _logOut() async {
    await facebookSignIn.logOut().then((value) {
      setState(() {
        login = false;
        name = '';
        image = '';
        buttonText = "Login";
      });
    }).catchError((onError) {
      print("Error 1");
    });
    _showMessage('Logged out.');
  }

  void _showMessage(String msg) {
    setState(() {
      message = msg;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Facebook'),
      ),
      body: new Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            gettingSession
                ? CircularProgressIndicator()
                : login
                    ? Container(
                        child: Column(
                          children: [
                            image != ""
                                ? CircleAvatar(
                                    backgroundImage: NetworkImage(image),
                                    radius: 50,
                                    backgroundColor: Color(0x00000000),
                                  )
                                : Container(),
                            Text(name),
                            Text(message),
                            RaisedButton(
                              onPressed: _logOut,
                              color: Colors.red,
                              child: new Text(buttonText),
                            )
                          ],
                        ),
                      )
                    : RaisedButton(
                        onPressed: _login,
                        child: new Text(buttonText),
                      ),
          ],
        ),
      ),
    );
  }
}

