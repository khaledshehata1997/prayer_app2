
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveNotification(NotificationResponse notificationResponse) async {
    print("Notification receive");
  }

  static Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings("@mipmap/launcher_icon");
    const DarwinInitializationSettings iOSInitializationSettings = DarwinInitializationSettings();

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotification,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification,
    );

     flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
    ?.requestNotificationsPermission();
  }

  static Future<void> showInstantNotification(String title, String body) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: AndroidNotificationDetails(
          'instant_notification_channel_id',
          'Instant Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails());

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'instant_notification',
    );
  }

  static Future<void> scheduleNotification(int id, String title, String body, DateTime scheduledTime) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        iOS: DarwinNotificationDetails(),
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminder Channel',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }
}



// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import '../main.dart';
// // import '../view/home/nav_bar_screens/prayer_view.dart';
// // import 'package:timezone/timezone.dart' as tz;
// // import 'package:timezone/data/latest_all.dart' as tz;
// //
// // void scheduleNotification(DateTime time, String prayerName) async {
// //   debugPrint('scheduleNotification ::: $prayerName ,, $time');
// //   var androidDetails = const AndroidNotificationDetails(
// //       'channelId', 'channelName',
// //       importance: Importance.max, priority: Priority.high);
// //   var generalNotificationDetails = NotificationDetails(android: androidDetails);
// //
// //   // التأكد من تهيئة الـ Timezone
// //   tz.initializeTimeZones();
// //
// //   // تحويل وقت الصلاة إلى وقت زمني مناسب
// //   final tz.TZDateTime scheduledDate = tz.TZDateTime.from(time, tz.local);
// //
// //   // await flutterLocalNotificationsPlugin.zonedSchedule(
// //   //   0,
// //   //   'وقت $prayerName',
// //   //   'حان الآن وقت $prayerName',
// //   //   scheduledDate,
// //   //   generalNotificationDetails,
// //   //   androidAllowWhileIdle: true,
// //   //   uiLocalNotificationDateInterpretation:
// //   //   UILocalNotificationDateInterpretation.wallClockTime,
// //   //   matchDateTimeComponents: DateTimeComponents.time, // لضمان التوقيت الصحيح
// //   // );
// // }
// //
// // void schedulePrayerNotifications(PrayerTimes prayerTimes) {
// //   scheduleNotification(prayerTimes.fajr, "الفجر");
// //   scheduleNotification(prayerTimes.dhuhr, "الظهر");
// //   scheduleNotification(prayerTimes.asr, "العصر");
// //   scheduleNotification(prayerTimes.maghrib, "المغرب");
// //   scheduleNotification(prayerTimes.isha, "العشاء");
// // }
//
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:prayer_app/view/home/home_view.dart';
//
// import '../main.dart';
//
// class NoificationRepository {
//
//   static AndroidNotificationChannel channel = const AndroidNotificationChannel(
//     'Channel_id',
//     'Channel_title',
//     description: 'This channel is used for important notifications.',
//     importance: Importance.high,
//     playSound: true,
//   );
// // Creating notification channel
//   static Future<void> notificationPlugin()async {
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(ch`for allowing notification);
// // requesting permission for sending notification
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//     AndroidFlutterLocalNotificationsPlugin>()
//         ?.requestNotificationsPermission();
// // Android Initialization
//     AndroidInitializationSettings initializationSettingsAndroid =
//     const AndroidInitializationSettings('@mipmap/ic_launcher');
// // iOS initialization
//     DarwinInitializationSettings iosInitializationSettings =
//     DarwinInitializationSettings(
//       onDidReceiveLocalNotification: (id, title, body, payload) async {
//         return await showDialog(
//           context: Messaging.openContext,
//           builder: (BuildContext context) => CupertinoAlertDialog(
//             title: Text(title ?? ""),
//             content: Text(body ?? ""),
//             actions: [
//               CupertinoDialogAction(
//                 isDefaultAction: true,
//                 child: const Text('Ok'),
//                 onPressed: () async {
//                   Navigator.of(context, rootNavigator: true).pop();
//                   await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const HomeView(),
//                     ),
//                   );
//                 },
//               )
//             ],
//           ),
//         );
//       },
//     );
// // Initializing android and iOS settings
//     InitializationSettings initializationSettings = InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: iosInitializationSettings,
//     );
// // Initializing flutter local notification
//     flutterLocalNotificationsPlugin.initialize(initializationSettings,
//         onDidReceiveNotificationResponse: (details) async {
//           await Navigator.push(
//             Messaging.openContext,
//             MaterialPageRoute<void>(
//                 builder: (context) => const HomeView()),
//           );
//         }
//     );
//   }
// }