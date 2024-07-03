import 'dart:async';
import 'package:alarm_app_020724/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:audioplayers/audioplayers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Notifications().initializeNotifications();
  tz.initializeTimeZones();
  runApp(AlarmApp());
}

class AlarmApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AlarmScreen(),
    );
  }
}

class Alarm {
  final String name;
  final TimeOfDay time;
  bool isActive;
  final AudioPlayer _audioPlayer; // Add an AudioPlayer instance to each Alarm

  Alarm({required this.name, required this.time, this.isActive = true}) : _audioPlayer = AudioPlayer(); // Initialize the AudioPlayer instance
}

class AlarmScreen extends StatefulWidget {
  @override
  _AlarmScreenState createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  List<Alarm> alarms = [];

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '1',
      'Alarm Notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await Notifications().flutterLocalNotificationsPlugin.show(
          0,
          title,
          body,
          platformChannelSpecifics,
          payload: 'item x',
        );
  }

  void _addAlarm(String name, TimeOfDay time) {
    setState(() {
      alarms.add(Alarm(name: name, time: time));
    });
  }

  void _deleteAlarm(int index) {
    setState(() {
      alarms.removeAt(index);
    });
  }

  void _toggleAlarm(int index) {
    setState(() {
      alarms[index].isActive = !alarms[index].isActive;
    });
  }

  Future<void> _scheduleAlarm(TimeOfDay time, String name) async {
    final now = DateTime.now();
    var scheduledTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await Notifications().flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        name,
        'Alarm set for ${time.format(context)}',
        tz.TZDateTime.from(scheduledTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            '1',
            'Alarm Notifications',
            importance: Importance.max,
            priority: Priority.high,
            channelDescription: 'Noti for Medicine',
            ticker: 'ticker',
            playSound: true,
            sound: RawResourceAndroidNotificationSound('alarm'),
          ),
        ),
        payload: "Your Medicine Time is Goinggggggggggggg",
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);

    // Play a sound when the alarm is triggered using the Alarm's AudioPlayer instance
    for (final alarm in alarms) {
      await alarm._audioPlayer.play(AssetSource('audio/alarm.mp3'));
    }
  }

  void _showAddAlarmDialog() {
    final _formKey = GlobalKey<FormState>();
    String _name = '';
    TimeOfDay _time = TimeOfDay.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Alarm'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Alarm Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an alarm name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _name = value!;
                  },
                ),
                const SizedBox(height: 8.0),
                ElevatedButton(
                  child: const Text('Pick Time'),
                  onPressed: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: _time,
                    );
                    if (picked != null && picked != _time) {
                      setState(() {
                        _time = picked;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Save'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _addAlarm(_name, _time);
                  _scheduleAlarm(_time, _name);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alarm App'),
      ),
      body: ListView.builder(
        itemCount: alarms.length,
        itemBuilder: (context, index) {
          final alarm = alarms[index];
          return ListTile(
            title: Text('${alarm.name} - ${alarm.time.format(context)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Switch(
                  value: alarm.isActive,
                  onChanged: (bool value) {
                    _toggleAlarm(index);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _deleteAlarm(index);
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAlarmDialog,
        tooltip: 'Add Alarm',
        child: const Icon(Icons.add),
      ),
    );
  }
}
