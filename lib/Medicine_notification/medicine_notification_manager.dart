// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

class NotificationManager {
  initialise(BuildContext context) async {
    selectNotfication(NotificationResponse notificationResponse) async {
      final String? payload = notificationResponse.payload;
      if (notificationResponse.payload != null) {
        debugPrint('notification payload: $payload');
      }
      // await Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const SplashScreen()),
      // );
    }

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: selectNotfication,
    );
  }

  setNotification({required DateTime time, required int id, required String name, required String tekingTime}) async {
    tz.initializeTimeZones();
    Duration duration = time.difference(DateTime.now());
    print('Durtation -----------------------');

    if (!duration.isNegative) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          name,
          tekingTime,
          tz.TZDateTime.now(tz.local).add(duration),
          NotificationDetails(
            android: AndroidNotificationDetails(
                id.toString(), // make sure to change this channel id during build apk
                'Muslim Vision',
                channelDescription: 'Notification for Medicine',
                fullScreenIntent: false,
                autoCancel: true,
                audioAttributesUsage: AudioAttributesUsage.alarm,
                importance: Importance.max,
                priority: Priority.max,
                playSound: true,
                color: const Color(0xff00a486),
                sound: const RawResourceAndroidNotificationSound("alarm"),
                styleInformation: BigTextStyleInformation(tekingTime)),
          ),
          payload: 'Adhan is going on',
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
    }
  }

  Future cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
