import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class Fcm {
  static Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) {
    if (message.containsKey('data')) {
// Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
// Handle notification message
      final dynamic notification = message['notification'];
    }
  }
}

class NotificationDemo extends StatefulWidget {
  @override
  _NotificationDemoState createState() => _NotificationDemoState();
}

class _NotificationDemoState extends State<NotificationDemo> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List<Message> messages = [];
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  void initState() {
    flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = new IOSInitializationSettings();
    var initSettings = new InitializationSettings(android, iOS);
    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);
    super.initState();
    _firebaseMessaging.getToken().then((token) {
      print(token);
    }).catchError((onError) {
      print(onError.message);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage >>>>>>>>>>>>  : $message");
        final notification = message['data'];
        // showSimpleNotification(
        //     '${notification['title']}', '${notification['body']}');
        newNot('${notification['title']}', '${notification['body']}','${notification['Image']}');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch >>>>>>>>>>>> : $message");
        developer.log('>>>>>>>>>>>>', name: 'my.app.category');
        // final notification = message['data'];
        // showSimpleNotification(
        //     '${notification['title']}', '${notification['body']}');
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume >>>>>>>>>>>> : $message");
        final notification = message['data'];
        showSimpleNotification(
            '${notification['title']}', '${notification['body']}');
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
  }

  Future onSelectNotification(String payload) async{
    debugPrint("payload : $payload");
    showDialog(
      context: context,
      builder: (_) => new AlertDialog(
        title: new Text('Notification'),
        content: new Text('$payload'),
      ),
    );
  }

  showSimpleNotification(String title, String body) async {
    var android = new AndroidNotificationDetails(
        'id', 'channel ', 'description',
        styleInformation: BigTextStyleInformation(''),
        priority: Priority.High,
        importance: Importance.Max);
    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails(android, iOS);
    await flutterLocalNotificationsPlugin.show(0, title, body, platform,
        payload: 'Welcome to the Local Notification demo');
  }


  Future<void> newNot(String title, String body,String image) async {
    BigPictureStyleInformation bigPictureStyleInformation;
    await urlToFile(image)
        .then((value) {
      bigPictureStyleInformation = BigPictureStyleInformation(
          FilePathAndroidBitmap(value.path),
          largeIcon: FilePathAndroidBitmap(value.path),
          contentTitle: title,
          summaryText: body,);
    });
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'big text channel id',
      'big text channel name',
      'big text channel description',
      styleInformation: bigPictureStyleInformation,
      importance: Importance.Max,
      priority: Priority.High,
    );
    const IOSNotificationDetails iOSPlatformChannelSpecifics =
    IOSNotificationDetails(sound: 'slow_spring_board.aiff');

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'big text title', 'silent body', platformChannelSpecifics);
  }


  Future urlToFile(String imageUrl) async {
    var rng = new Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.png');
    http.Response response = await http.get(imageUrl);
    await file.writeAsBytes(response.bodyBytes);
    print('uiqewb' + file.path.toString());
    return file;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notification"),
      ),
      body: Container(
        child: ListView(
          children: messages.map(buildMessage).toList(),
        ),
      ),
    );
  }

  Widget buildMessage(Message message) => ListTile(
        title: Text(message.title),
        subtitle: Text(message.body),
      );
}

@immutable
class Message {
  final String title;
  final String body;

  const Message({
    @required this.title,
    @required this.body,
  });
}

