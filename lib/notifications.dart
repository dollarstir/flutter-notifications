import 'package:awesome_notifications/awesome_notifications.dart';
import './utility.dart';


Future<void> creatNotification() async {
  await AwesomeNotifications().createNotification(
      content: NotificationContent(
    id: generateuid(),
    channelKey: 'basic_channel',
    title :'Yolk Notifcation',
    body: 'This test notifications ',
    bigPicture: 'https://www.tict-edu.org/images/tucee/5.png',
    notificationLayout: NotificationLayout.BigPicture,
  ));
}
