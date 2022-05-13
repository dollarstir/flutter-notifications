import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import './home.dart';
import 'package:workmanager/workmanager.dart';
import "package:http/http.dart" as http;

import 'notifications.dart';

Future backgroundNotifications() async {
  print("Done");
  String blurl = "https://icounselgh.net/ads";
  AwesomeNotifications _notification = AwesomeNotifications();

  bool _hasPermission = await _notification.isNotificationAllowed();

  if(!_hasPermission) {
    bool _hasAllowed = await _notification.requestPermissionToSendNotifications();

    if(!_hasAllowed) {
      return;

    }
  }

  try {
    http.Response response = await http.post(
      Uri.parse(blurl),
      body: {
        "userid": '1',
      },
    );

    List results = json.decode(response.body);
    creatNotification1();

  } catch (e) {
    print(e);
  }

  _notification.dispose();
}

void dispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    switch (taskName) {
      case "notifications":
        await backgroundNotifications();
        break;
      default:
    }

    return Future.value(true);
  });
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager backgroundTaskManager = Workmanager();
  backgroundTaskManager.initialize(
    dispatcher,
    isInDebugMode: true,
  );

  backgroundTaskManager.registerPeriodicTask(
    "notifications",
    "notifications",
    frequency: const Duration(minutes: 1),
    initialDelay: const Duration(seconds: 20),
    constraints: Constraints(
      networkType: NetworkType.connected,
    ),
  );

  AwesomeNotifications().initialize('resource://drawable/logo', [
    NotificationChannel(
        channelKey: "basic_channel",
        channelName: "Basic Notifications",
        channelDescription: "Tucee App",
        defaultColor: Colors.teal,
        importance: NotificationImportance.High,
        channelShowBadge: true)
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yolk Flutter Notification',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Homepage(),
    );
  }
}
