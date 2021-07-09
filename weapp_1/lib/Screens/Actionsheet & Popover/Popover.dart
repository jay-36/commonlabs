// import 'package:flutter/material.dart';
// import 'package:popover/popover.dart';
//
// class PopoverExample extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Popover'),centerTitle: true,),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 mainAxisSize: MainAxisSize.max,
//                 children: [
//                   const PopoverItems(),
//                   const PopoverItems(),
//                   const PopoverItems(isArtificialTap: true),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class PopoverItems extends StatefulWidget {
//   final bool isArtificialTap;
//   final Duration tapDelay;
//
//   const PopoverItems({
//     this.isArtificialTap = false,
//     this.tapDelay = const Duration(milliseconds: 1000),
//     Key key,
//   }) : super(key: key);
//
//   @override
//   _PopoverItemsState createState() => _PopoverItemsState();
// }
//
// class _PopoverItemsState extends State<PopoverItems> {
//
//   Color color;
//   Color red = Colors.red;
//   Color green = Colors.green;
//   Color purple = Colors.purple;
//   Color amber = Colors.amber;
//
//   @override
//   Widget build(BuildContext context) {
//     final popover = Popover(
//       direction: PopoverDirection.top,
//       width: 200,
//       height: 280,
//       arrowHeight: 15,
//       arrowWidth: 30,
//       child: RaisedButton(
//         color: color,
//         child: Text("press"),
//         onPressed: (){},
//       ),
//       onPop: () => print('Popover was popped!'),
//       bodyBuilder: (context){
//         return Scrollbar(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 8),
//             child: ListView(
//               padding: const EdgeInsets.all(8),
//               children: [
//                 InkWell(
//                   onTap: () {
//                     setState(() {
//                       color = red;
//                     });
//                     Navigator.of(context).pop();
//                   },
//                   child: Container(
//                     height: 50,
//                     color: Colors.red[300],
//                     child: const Center(child: Text('Red')),
//                   ),
//                 ),
//                 const Divider(),
//                 InkWell(
//                   onTap: () {
//                     setState(() {
//                       color = green;
//                     });
//                     Navigator.of(context).pop();
//                   },
//                   child: Container(
//                     height: 50,
//                     color: Colors.green[300],
//                     child: const Center(child: Text('Green')),
//                   ),
//                 ),
//                 const Divider(),
//                 InkWell(
//                   onTap: () {
//                     setState(() {
//                       color = purple;
//                     });
//                     Navigator.of(context).pop();
//                   },
//                   child: Container(
//                     height: 50,
//                     color: Colors.purple[300],
//                     child: const Center(child: Text('Purple')),
//                   ),
//                 ),
//                 const Divider(),
//                 InkWell(
//                   onTap: () {
//                     setState(() {
//                       color = amber;
//                     });
//                     Navigator.of(context).pop();
//                   },
//                   child: Container(
//                     height: 50,
//                     color: Colors.amber[400],
//                     child: const Center(child: Text('Amber')),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//
//     if (widget.isArtificialTap) {
//       Future.delayed(widget.tapDelay, () => popover.showPopover(context));
//     }
//
//     return popover;
//   }
// }
//
