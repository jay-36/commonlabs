import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_auth/simple_auth.dart' as simpleAuth;
import 'package:simple_auth_flutter/simple_auth_flutter.dart';
import 'package:http/http.dart' as http;

String post = "";
String name = "";
String errorMsg;
Map _userData;
Map<String, dynamic> userData;
bool isLoading = false;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final simpleAuth.InstagramApi _igApi = simpleAuth.InstagramApi(
    "instagram",
    Constants.igClientId,
    Constants.igClientSecret,
    Constants.igRedirectURI,
    scopes: [
      'user_profile', // For getting username, account type, etc.
      'user_media', // For accessing media count & data like posts, videos etc.
    ],
  );

  @override
  void initState() {
    super.initState();
    SimpleAuthFlutter.init(context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Instagram'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Visibility(
              visible: _userData != null,
              child: userData != null
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
                              Text(userData["full_name"].toString(),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500))
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(userData['profile_pic_url_hd']),
                              radius: 40,
                            ),
                            Column(
                              children: [
                                Text(
                                  post,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Posts", style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                    userData['edge_followed_by']['count']
                                        .toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Followers",
                                    style: TextStyle(fontSize: 16)),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                    userData['edge_follow']['count'].toString(),
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text("Following",
                                    style: TextStyle(fontSize: 16)),
                              ],
                            ),
                          ],
                        ),
                        Divider(
                          height: 10,
                          thickness: 2.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Flexible(
                                  child: Text(
                                    userData['biography'],
                                style: TextStyle(fontSize: 14),
                                maxLines: 2,
                                softWrap: false,
                                overflow: TextOverflow.fade,
                              ))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                  "Facebook Id : " +
                                      userData['fbid'].toString(),
                                  style: TextStyle(fontSize: 16))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text("Business Account : ",
                                  style: TextStyle(fontSize: 16)),
                              userData['is_business_account'] == true
                                  ? Icon(Icons.done)
                                  : Icon(Icons.close),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text("Private : ",
                                  style: TextStyle(fontSize: 16)),
                              userData['is_private'] == true
                                  ? Image.asset(
                                      "assets/hide.png",
                                      height: 30,
                                    )
                                  : Image.asset(
                                      "assets/view.png",
                                      height: 30,
                                    ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text("Verified : ",
                                  style: TextStyle(fontSize: 16)),
                              userData['is_verified'] == true
                                  ? Image.asset(
                                      "assets/verified.png",
                                      height: 30,
                                    )
                                  : Image.asset(
                                      "assets/notverified.png",
                                      height: 30,
                                    ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                "id : " + userData['id'].toString(),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  : isLoading ? Center(child: CircularProgressIndicator()) : Container(
                child: Center(child: Text("Click the button below to get Instagram Login.")),
              ),
              replacement:
                  Center(child: Text("Click the button below to get Instagram Login.")),
            ),
            Row(
              children: [
                userData == null
                    ? FlatButton.icon(
                        icon: Icon(Icons.login),
                        label: Text(
                          "Login",
                        ),
                        onPressed: _loginAndGetData,
                        color: Colors.pink.shade400,
                      )
                    : Container(),
                userData != null
                    ? FlatButton.icon(
                        onPressed: () {
                          logout(_igApi);
                        },
                        icon: Icon(Icons.logout),
                        label: Text(
                          "Logout",
                        ),
                      )
                    : Container(),
              ],
            ),
            if (errorMsg != null) Text("Error occured: $errorMsg"),

          ],
        ),
      ),
    );
  }

  Future<void> _loginAndGetData() async {
    setState(() {
      isLoading = true;
    });
    await _igApi.authenticate().then(
      (simpleAuth.Account _user) async {
        simpleAuth.OAuthAccount user = _user;
        var igUserResponse =
            await Dio(BaseOptions(baseUrl: 'https://graph.instagram.com')).get(
          '/me',
          queryParameters: {
            "fields": "username,id,account_type,media_count",
            "access_token": user.token,
          },
        );
        setState(() {
          _userData = igUserResponse.data;
          post = igUserResponse.data['media_count'].toString();
          name = igUserResponse.data['username'];
          errorMsg = null;
        });
        _getMoreData(igUserResponse.data['username']);
      }).catchError(
      (Object e) {
        setState((){
          isLoading = false;
          errorMsg = e.toString();
        });
      },
    );
  }

  Future<bool> _getMoreData(String username) async {
    return Dio().get('https://instagram.com/$username/?__a=1').then(
      (Response response) {
        setState(() {
          userData = response.data['graphql']['user'];
          isLoading = false;
        });
        return true;
      },
    ).catchError((onError){
      print("Error 1");
      setState(() {
        isLoading = false;
        errorMsg = onError.toString();
      });
    });
  }


  void logout(simpleAuth.AuthenticatedApi api) async {
    await api.logOut().then((value) {
      setState(() {
        userData = null;
      });
    }).catchError((onError) {
      setState(() {
        errorMsg = onError.message;
      });
      print("Error");
    });
  }
}

class Constants {
  static const igClientId = "232476958648728";
  static const igClientSecret = "5e49c377c9684ca78c88a3ef53294c4f";
  static const igRedirectURI =
      "https://socialsizzle.herokuapp.com/auth/?code=AQBx-hBsH3...";
// static const igClientId = "2480747992220233";
// static const igClientSecret = "b0b46681f193913350090d780953621a";
// static const igRedirectURI = "https://socialsizzle.herokuapp.com/auth/?code=AQBx-hBsH3...";
}

// class LoginPage extends StatelessWidget {
//   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//         key: _scaffoldKey,
//         appBar: new AppBar(
//           title: new Text("Flutter Auth"),
//         ),
//         body: new LoginScreen(_scaffoldKey)
//     );
//   }
//
// }
//
//
// ///
// ///   Contact List
// ///
// class LoginScreen extends StatefulWidget{
//   GlobalKey<ScaffoldState> skey;
//
//   LoginScreen(GlobalKey<ScaffoldState> this.skey, { Key key }) : super(key: key);
//
//   @override
//   _LoginScreenState createState() => new _LoginScreenState(skey);
// }
//
//
// class _LoginScreenState extends State<LoginScreen> implements LoginViewContract {
//   LoginPresenter _presenter;
//   bool _IsLoading;
//   Token token;
//
//   GlobalKey<ScaffoldState> _scaffoldKey;
//
//
//   void showInSnackBar(String value) {
//     _scaffoldKey.currentState.showSnackBar(new SnackBar(
//         content: new Text(value)
//     ));
//   }
//
//   _LoginScreenState(GlobalKey<ScaffoldState> skey) {
//     _presenter = new LoginPresenter(this);
//     _scaffoldKey = skey;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _IsLoading = false;
//   }
//
//
//   @override
//   void onLoginError(String msg) {
//     setState(() {
//       _IsLoading = false;
//     });
//     showInSnackBar(msg);
//   }
//
//   @override
//   void onLoginScuccess(Token t) {
//     setState(() {
//       _IsLoading = false;
//       token = t;
//     });
//     showInSnackBar('Login successful');
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     var widget;
//     if(_IsLoading) {
//       widget = new Center(
//           child: new Padding(
//               padding: const EdgeInsets.only(left: 16.0, right: 16.0),
//               child: new CircularProgressIndicator()
//           )
//       );
//     } else if(token != null){
//       widget = new Padding(
//           padding: new EdgeInsets.all(32.0),
//           child: new Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 new Text(
//                   token.full_name,
//                   style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),),
//                 new Text(token.username),
//                 new Center(
//                   child: new CircleAvatar(
//                     backgroundImage: new NetworkImage(token.profile_picture),
//                     radius: 50.0,
//                   ),
//                 ),
//               ]
//           )
//       );
//     }
//     else {
//       widget = new Padding(
//           padding: new EdgeInsets.all(32.0),
//           child: new Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 new Text(
//                   'Welcome to FlutterAuth,',
//                   style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 1.5),),
//                 new Text('Login to continue'),
//                 new Center(
//                   child: new Padding(
//                       padding: new EdgeInsets.symmetric(vertical: 160.0),
//                       child:
//                       new InkWell(child:
//                       new Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         mainAxisSize: MainAxisSize.max,
//                         children: <Widget>[
//                           new Image.asset(
//                             'assets/instagram.png',
//                             height: 50.0,
//                             fit: BoxFit.cover,
//                           ),
//                           new Text('Continue with Instagram')
//                         ],
//                       ),onTap: _login,)
//                   ),
//                 ),
//               ]
//           )
//       );
//     }
//     return widget;
//   }
//
//   void _login(){
//     setState(() {
//       _IsLoading = true;
//     });
//     _presenter.perform_login();
//   }
// }
//
//
// Future<Token> getToken(String appId, String appSecret) async {
//   Stream<String> onCode = await _server();
//   // String url =
//   //     "https://api.instagram.com/oauth/authorize?client_id=$appId&redirect_uri=https://socialsizzle.herokuapp.com/auth/?code=AQBx-hBsH3...&response_type=code&scope:[user_profile,user_media]";
//   // final flutterWebviewPlugin = new FlutterWebviewPlugin();
//   // flutterWebviewPlugin.launch(url);
//   final String code = await onCode.first;
//   final http.Response response = await http.post(
//       "https://api.instagram.com/oauth/access_token",
//       body: {"client_id": appId, "redirect_uri": "https://socialsizzle.herokuapp.com/auth/?code=AQBx-hBsH3...", "client_secret": appSecret,
//         "code": code, "grant_type": "authorization_code",});
//   // flutterWebviewPlugin.close();
//   return new Token.fromMap(json.decode(response.body));
// }
//
// Future<Stream<String>> _server() async {
//   final StreamController<String> onCode = new StreamController();
//   HttpServer server =
//   await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8585);
//   server.listen((HttpRequest request) async {
//     final String code = request.uri.queryParameters["code"];
//     request.response
//       ..statusCode = 200
//       ..headers.set("Content-Type", ContentType.HTML.mimeType)
//       ..write("<html><h1>You can now close this window</h1></html>");
//     await request.response.close();
//     await server.close(force: true);
//     onCode.add(code);
//     await onCode.close();
//   });
//   return onCode.stream;
// }
//
// class Token {
//   String access;
//   String id;
//   String username;
//   String full_name;
//   String profile_picture;
//
//   Token.fromMap(Map json){
//     access = json['access_token'];
//     id = json['user']['id'];
//     username = json['user']['username'];
//     full_name = json['user']['full_name'];
//     profile_picture = json['user']['profile_picture'];
//   }
// }
//
//
// abstract class LoginViewContract {
//   void onLoginScuccess(Token token);
//   void onLoginError(String message);
// }
//
// class LoginPresenter {
//   LoginViewContract _view;
//   LoginPresenter(this._view);
//
//   void perform_login() {
//     assert(_view != null);
//     getToken(Constants.igClientId,
//         Constants.igClientSecret).then((token)
//     {
//       if (token != null) {
//         _view.onLoginScuccess(token);
//       }
//       else {
//         _view.onLoginError('Error');
//       }
//     });
//   }
// }
