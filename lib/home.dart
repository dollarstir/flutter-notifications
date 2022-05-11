import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import './notifications.dart';  
import './second.dart';

class Homepage extends StatefulWidget {
  Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((isallowed) {
      if (!isallowed) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Allow Notifications'),
                  content: Text('Yolk will like to send you notifications'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Don\'t Allow',
                          style: TextStyle(color: Colors.grey, fontSize: 18),
                        )),
                    TextButton(
                        onPressed: () {
                          AwesomeNotifications()
                              .requestPermissionToSendNotifications()
                              .then((_) {
                            Navigator.pop(context);
                          });
                        },
                        child: Text(
                          'Allow',
                          style: TextStyle(
                              color: Colors.teal,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ));
      }
    });

    AwesomeNotifications().actionStream.listen((notifications){
      if(notifications.channelKey == "baisc_channel" && Platform.isIOS){
        AwesomeNotifications().getGlobalBadgeCounter().then((value) => AwesomeNotifications().setGlobalBadgeCounter(value - 1));
      }
      Navigator.pushAndRemoveUntil(context,MaterialPageRoute(builder :(_) => second(),),(route)=> route.isFirst);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    AwesomeNotifications().actionSink.close();
    AwesomeNotifications().createdSink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Yolk Flutter Notification'),
        ),
        body: SafeArea(
            child: SingleChildScrollView(
          child: Center(
              child: ElevatedButton(
            child: Text('Send'),
            onPressed: creatNotification,
          )),
        )));
  }
}
