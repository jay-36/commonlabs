//
//
//  firebase_core: ^0.4.5
//  firebase_auth: ^0.15.5+3
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(title: 'Flutter Demo', home: LoginScreen());
//   }
// }
//
// class HomeScreen extends StatefulWidget {
//   final FirebaseUser user;
//
//   HomeScreen({this.user});
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//
//   Future<void> _signOut() async {
//     await FirebaseAuth.instance.signOut();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         padding: EdgeInsets.all(32),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(
//               "You are Logged in succesfully",
//               style: TextStyle(color: Colors.lightBlue, fontSize: 32),
//             ),
//             SizedBox(
//               height: 16,
//             ),
//             Text(
//               widget.user.phoneNumber.toString(),
//               style: TextStyle(
//                 color: Colors.grey,
//               ),
//             ),
//             Text(
//               widget.user.uid,
//               style: TextStyle(
//                 color: Colors.grey,
//               ),
//             ),
//             RaisedButton(
//                 onPressed: () {
//                   _signOut();
//                   Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => LoginScreen(),
//                       ));
//                 },
//                 child: Text("Sign Out"))
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final _phoneController = TextEditingController();
//   final _countryCodeController = TextEditingController();
//   final _codeController = TextEditingController();
//
//   Future<bool> loginUser(string phone, BuildContext context) async {
//     FirebaseAuth _auth = FirebaseAuth.instance;
//
//
//     _auth.verifyPhoneNumber(
//         phoneNumber: phone,
//         timeout: Duration(seconds: 60),
//         verificationCompleted: (AuthCredential credential) async {
//           Navigator.of(context).pop();
//           AuthResult result = await _auth.signInWithCredential(credential);
//           FirebaseUser user = result.user;
//
//           if (user != null) {
//
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) => HomeScreen(
//                         user: user)));
//           } else {
//
//             print("Error");
//           }
//
//           //This callback would gets called when verification is done auto maticlly
//         },
//         verificationFailed: (AuthException exception) {
//           print(exception);
//         },
//
//         codeSent: (string verificationId  , [int forceResendingToken]) {
//           showDialog(
//               context: context,
//               barrierDismissible: false,
//               builder: (context) {
//                 return AlertDialog(
//                   title: Text("Give the code?"),
//                   content: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: <Widget>[
//                       TextField(
//                         controller: _codeController,
//                       ),
//                     ],
//                   ),
//                   actions: <Widget>[
//                     FlatButton(
//                       child: Text("Confirm"),
//                       textColor: Colors.white,
//                       color: Colors.blue,
//                       onPressed: () async {
//                         final code = _codeController.text.trim();
//                         AuthCredential credential =
//                         PhoneAuthProvider.getCredential(
//                             verificationId: verificationId, smsCode: code);
//
//                         AuthResult result =
//                         await _auth.signInWithCredential(credential);
//
//                         FirebaseUser user = result.user;
//
//                         if (user != null) {
//                           Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                   builder: (context) => HomeScreen(
//                                       user: user)));
//                         } else {
//
//                           print("Error");
//                         }
//                       },
//                     )
//                   ],
//                 );
//               });
//         },
//         codeAutoRetrievalTimeout: null);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           child: Form(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 Text(
//                   "Login",
//                   style: TextStyle(
//                       color: Colors.lightBlue,
//                       fontSize: 36,
//                       fontWeight: FontWeight.w500),
//                 ),
//                 SizedBox(
//                   height: 16,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                       width: 50,
//                       child: TextFormField(
//                         decoration: InputDecoration(
//                           enabledBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(8)),
//                               borderSide:
//                               BorderSide(color: Colors.grey[200])),
//                           focusedBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(8)),
//                               borderSide:
//                               BorderSide(color: Colors.grey[300])),
//                           filled: true,
//                           fillColor: Colors.grey[100],
//                         ),
//                         controller: _countryCodeController,
//                       ),
//                     ),
//                     Container(
//                       width: 250,
//                       child: TextFormField(
//                         decoration: InputDecoration(
//                           enabledBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(8)),
//                               borderSide:
//                               BorderSide(color: Colors.grey[200])),
//                           focusedBorder: OutlineInputBorder(
//                               borderRadius:
//                               BorderRadius.all(Radius.circular(8)),
//                               borderSide:
//                               BorderSide(color: Colors.grey[300])),
//                           filled: true,
//                           fillColor: Colors.grey[100],
//                         ),
//                         controller: _phoneController,
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 10,),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Container(
//                         width: 100,
//                         child: Text("Country Code")
//                     ),
//                     Container(
//                         width: 200,
//                         child: Text("Mobile Number")
//                     ),
//                   ],
//                 ),
//
//                 SizedBox(
//                   height: 16,
//                 ),
//                 Container(
//                   width: double.infinity,
//                   child: FlatButton(
//                     child: Text("LOGIN"),
//                     textColor: Colors.white,
//                     padding: EdgeInsets.all(16),
//                     onPressed: () {
//                       final phone = '+' +
//                           _countryCodeController.text +
//                           _phoneController.text.trim();
//
//                       loginUser(phone, context);
//                     },
//                     color: Colors.blue,
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

//
