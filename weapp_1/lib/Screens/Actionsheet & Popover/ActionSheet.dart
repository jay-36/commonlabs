// import 'dart:ui';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:platform_action_sheet/platform_action_sheet.dart';
// import 'package:popover/popover.dart';
//
// class ActionSheetDemo extends StatefulWidget {
//   @override
//   _ActionSheetDemoState createState() => _ActionSheetDemoState();
// }
//
// class _ActionSheetDemoState extends State<ActionSheetDemo> {
//   String def = "";
//   String car =
//       "https://images.unsplash.com/photo-1525609004556-c46c7d6cf023?ixid=MXwxMjA3fDB8MHxzZWFyY2h8M3x8Y2Fyc3xlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&w=1000&q=80";
//   String forest =
//       "https://i.pinimg.com/564x/71/5c/e4/715ce4fa16601425b31674dcc308ac8a.jpg";
//   String animal =
//       "https://i.pinimg.com/564x/7b/b8/7a/7bb87a6cc995f84f16c6668ed971439e.jpg";
//   String gif =
//       "https://i.pinimg.com/originals/a0/11/c5/a011c5c408f24126c07f599e190ad78d.gif";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Container(
//             child: Stack(
//       fit: StackFit.expand,
//       children: [
//         Container(
//           width: double.infinity,
//           height: double.infinity,
//           child: Image.network(
//             def,
//             fit: BoxFit.cover,
//           ),
//         ),
//         Container(
//           child: BackdropFilter(
//             filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
//             child: Container(
//               color: Colors.black.withOpacity(0.1),
//             ),
//           ),
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             RaisedButton(
//                 onPressed: () {
//                   PlatformActionSheet().displaySheet(
//
//                       context: context,
//
//                       actions: [
//                         ActionSheetAction(
//                             text: "None",
//                             onPressed: () {
//                               setState(() {
//                                 def = def;
//                               });
//                               Navigator.pop(context);
//                             }),
//                         ActionSheetAction(
//                             text: "One",
//                             onPressed: () {
//                               setState(() {
//                                 def = car;
//                               });
//                               Navigator.pop(context);
//                             }),
//                         ActionSheetAction(
//                             text: "Two",
//                             onPressed: () {
//                               setState(() {
//                                 def = forest;
//                               });
//                               Navigator.pop(context);
//                             }),
//                         ActionSheetAction(
//                             text: "Three",
//                             onPressed: () {
//                               setState(() {
//                                 def = animal;
//                               });
//                               Navigator.pop(context);
//                             }),
//                         ActionSheetAction(
//                             text: "Gif",
//                             onPressed: () {
//                               setState(() {
//                                 def = gif;
//                               });
//                               Navigator.pop(context);
//                             }),
//                         ActionSheetAction(
//                             text: "Cancel",
//                             onPressed: () {
//                               Navigator.pop(context);
//                             }),
//                       ],
//                       title: Text("I Am ActionSheet Bar"),
//                       message: Text("Please Select One Of theme"));
//                 },
//                 child: Text("Press It")),
//             RaisedButton(
//                 onPressed: () {
//                   showCupertinoModalPopup(
//                     context: context,
//                     builder: (BuildContext context) => CupertinoActionSheet(
//                         title: const Text('Choose Options'),
//                         message: const Text('Your options are '),
//                         actions: <Widget>[
//                           CupertinoActionSheetAction(
//                             child: const Text('None'),
//                             onPressed: () {
//                               setState(() {
//                                 def = def;
//                               });
//                               Navigator.pop(context);
//                             },
//                           ),
//                           CupertinoActionSheetAction(
//                             child: const Text('Car'),
//                             onPressed: () {
//                               setState(() {
//                                 def = car;
//                               });
//                               Navigator.pop(context);
//                             },
//                           ),
//                           CupertinoActionSheetAction(
//                             child: const Text('Forest'),
//                             onPressed: () {
//                               setState(() {
//                                 def = forest;
//                               });
//                               Navigator.pop(context);
//                             },
//                           ),
//                           CupertinoActionSheetAction(
//                             child: const Text('Animal'),
//                             onPressed: () {
//                               setState(() {
//                                 def = animal;
//                               });
//                               Navigator.pop(context);
//                             },
//                           ),
//                           CupertinoActionSheetAction(
//                             child: const Text('Gif'),
//                             onPressed: () {
//                               setState(() {
//                                 def = gif;
//                               });
//                               Navigator.pop(context);
//                             },
//                           )
//                         ],
//                         cancelButton: CupertinoActionSheetAction(
//                           child: const Text('Cancel'),
//                           isDefaultAction: true,
//                           onPressed: () {
//                             Navigator.pop(context);
//                           },
//                         )),
//                   );
//                 },
//                 child: Text("Ios")),
//           ],
//         )
//       ],
//     )));
//   }
// }
