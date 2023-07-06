import 'package:flutter/material.dart';
import 'package:hecolin_surveillance/Service/NotificationService.dart';
import 'package:sqflite/sqflite.dart';

import '../Service/NotificationService.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    scheduleNotifications();
  }

  Future<void> scheduleNotifications() async {
    // Define your list of appointment times
    List<DateTime> appointmentTimes = [
      DateTime.now().add(Duration(seconds: 10)),
      DateTime.now().add(Duration(seconds: 20)),
      DateTime.now().add(Duration(seconds: 30)),
    ];

    // Schedule notifications for each appointment time
    for (int i = 0; i < appointmentTimes.length; i++) {
      DateTime appointmentTime = appointmentTimes[i];
      String formattedTime =
          '${appointmentTime.hour}:${appointmentTime.minute}';

      String title = 'Appointment Reminder';
      String body = 'You have an appointment today at $formattedTime';

      await NotificationService().showNotification(
        id: i,
        title: title,
        body: body,
      );

      await Future.delayed(Duration(seconds: 10));


    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text('Show notifications'),
          onPressed: () {
            scheduleNotifications();
          },
        ),
      ),
    );
  }
}
