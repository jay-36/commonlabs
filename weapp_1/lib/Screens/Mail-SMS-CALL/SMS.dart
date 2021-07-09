// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'package:flutter_sms/flutter_sms.dart';
//
// class SmsDemo extends StatefulWidget {
//   @override
//   _SmsDemoState createState() => _SmsDemoState();
// }
//
// class _SmsDemoState extends State<SmsDemo> {
//   TextEditingController _controllerPeople, _controllerMessage;
//   String _message, body;
//   List<String> people = [];
//
//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//   }
//
//   Future<void> initPlatformState() async {
//     _controllerPeople = TextEditingController();
//     _controllerMessage = TextEditingController();
//   }
//
//   Widget _phoneTile(String name) {
//     return Padding(
//       padding: const EdgeInsets.all(3.0),
//       child: Container(
//           decoration: BoxDecoration(
//               border: Border(
//                 bottom: BorderSide(color: Colors.grey[300]),
//                 top: BorderSide(color: Colors.grey[300]),
//                 left: BorderSide(color: Colors.grey[300]),
//                 right: BorderSide(color: Colors.grey[300]),
//               )),
//           child: Padding(
//             padding: EdgeInsets.all(4.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 IconButton(
//                   icon: Icon(Icons.close),
//                   onPressed: () => setState(() => people.remove(name)),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(0.0),
//                   child: Text(
//                     name,
//                     textScaleFactor: 1.0,
//                     style: TextStyle(fontSize: 12.0),
//                   ),
//                 )
//               ],
//             ),
//           )),
//     );
//   }
//
//   void _send() async{
//     if (people == null || people.isEmpty) {
//       setState(() => _message = "At Least 1 Person or Message Required");
//     } else {
//       try {
//         String _result = await sendSMS(
//             message: _controllerMessage.text, recipients: people);
//         setState(() => _message = _result);
//       } catch (error) {
//         setState(() => _message = error.toString());
//       }
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('SMS'),centerTitle: true,
//       ),
//       body: ListView(
//         children: <Widget>[
//           people == null || people.isEmpty
//               ? Container(
//             height: 0.0,
//           )
//               : Container(
//             height: 90.0,
//             child: Padding(
//               padding: const EdgeInsets.all(3.0),
//               child: ListView(
//                 scrollDirection: Axis.horizontal,
//                 children:
//                 List<Widget>.generate(people.length, (int index) {
//                   return _phoneTile(people[index]);
//                 }),
//               ),
//             ),
//           ),
//           ListTile(
//             leading: Icon(Icons.people),
//             title: TextFormField(
//               maxLength: 10,
//               validator: phoneValidator,
//               controller: _controllerPeople,
//               decoration: InputDecoration(labelText: "Add Phone Number",counter: Offstage(),
//               ),
//               keyboardType: TextInputType.number,
//               onChanged: (String value) => setState(() {}),
//             ),
//             trailing: IconButton(
//               icon: Icon(Icons.add),
//               onPressed: _controllerPeople.text.isEmpty
//                   ? null
//                   : () => setState(() {
//                 people.add(_controllerPeople.text.toString());
//                 _controllerPeople.clear();
//               }),
//             ),
//           ),
//           Divider(),
//           ListTile(
//             leading: Icon(Icons.message),
//             title: TextFormField(
//               validator: messageValidator,
//               decoration: InputDecoration(labelText: " Add Message"),
//               controller: _controllerMessage,
//               onChanged: (String value) => setState(() {}),
//             ),
//           ),
//           Divider(),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: RaisedButton(
//               color: Theme.of(context).accentColor,
//               padding: EdgeInsets.symmetric(vertical: 16),
//               child: Text("SEND",
//                   style: Theme.of(context).accentTextTheme.button),
//               onPressed: () {
//                 _send();
//               },
//             ),
//           ),
//           Visibility(
//             visible: _message != null,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.all(12.0),
//                     child: Text(
//                       _message ?? "No Data",
//                       maxLines: null,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
// String phoneValidator(val){
//   RegExp phoneValid = RegExp(r"^[0-9]");
//   if(!phoneValid.hasMatch(val)){
//     return "Example : 0123456789";
//   }else if(val.length < 10){
//     return "Enter Atleast 10 Digits";
//   } else{
//     return null;
//   }
// }
// String messageValidator(val){
//   if(val.length < 1 ){
//     return "\u24E7 at Least 8 char";
//   }else{
//     return null;
//   }
// }
