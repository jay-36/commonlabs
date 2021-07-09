import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart' as provider;
import 'package:provider/single_child_widget.dart';
import 'package:weapp_1/Button.dart';
import 'package:weapp_1/Screens/Api/ApiList.dart';
import 'package:weapp_1/Screens/Api/GET/ViewApi.dart';
import 'package:weapp_1/Screens/Provider/Example.dart';
import 'package:weapp_1/Theme.dart';
import 'Screens/Provider/Provider.dart';
import 'dart:math' as math;

//facebook interstitial
//
// void main() {
//   runApp(
//       MyApp()
//   );
// }
void main() {
  runApp(
    provider.MultiProvider(
      providers: providers,
      child: MyApp(),
    ),
  );
}

List<SingleChildWidget> providers = [
  provider.ChangeNotifierProvider<ItemProvider>(create: (_) => ItemProvider()),
  provider.ChangeNotifierProvider<ProviderClass>(
      create: (_) => ProviderClass()),
  provider.ChangeNotifierProvider<GetProvider>(create: (_) => GetProvider()),
];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.black));

    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: theme(),
        home: FirstPageButtonExamples());
  }
}

