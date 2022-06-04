// ignore_for_file: unused_field, unused_element, prefer_const_constructors, non_constant_identifier_names

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:rxdart/rxdart.dart';

import '../../models/myboard.dart' as m;

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future init({bool initScheduled = false}) async {
    final android = AndroidInitializationSettings('ic_launcher');
    final iOS = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);

    await _notifications.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifications.add(payload);
      },
    );

    // if (initScheduled) {
    //   tz.initializeTimeZones();
    //   final locationName = await FlutterNativeTimezone.getLocalTimezone();
    //   tz.setLocalLocation(tz.getLocation(locationName));
    // }
  }

  static Future showNotification({
    int id = 5,
    String? title,
    String? body,
    String? payload,
  }) async =>
      _notifications.show(
        id,
        title,
        body,
        await _notificationDetails(),
        payload: payload,
      );

  static Future showScheduledNotification({
    int id = 5,
    String? title,
    String? body,
    String? payload,
    required m.ReminderTask? latestreminder,
    required int? remindBefore,
  }) async {
    DateTime scheduledDate = DateTime(
      latestreminder!.date!.year,
      latestreminder.date!.month,
      latestreminder.date!.day,
      int.parse(
        latestreminder.startTime.toString().split(':')[0],
      ),
      int.parse(
        latestreminder.startTime.toString().split(':')[1],
      ),
    );

    print(
        'from schedule notification funtion call ${scheduledDate.toString()}');
    return _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      await _notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        //'channel description',
        importance: Importance.max,
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  // Daily Notification at 8 am
  static void showScheduledNotification_daily({
    int id = 1,
    // String? title,
    // String? body,
    String? payload,
    m.ReminderTask? remindertask,
    required int? remindBefore,
  }) async {
    _notifications.zonedSchedule(
      id,
      'Reminder Scheduled: ${remindertask!.title}',
      remindertask.note,
      _scheduleDaily(
        Time(
          int.parse(remindertask.startTime.toString().split(':')[0]),
          int.parse(remindertask.startTime.toString().split(':')[1]),
        ),
      ),
      await _notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  /// Weekly Notification
  static void showScheduledNotification_weekly({
    int id = 2,
    // String? title,
    // String? body,
    String? payload,
    m.ReminderTask? remindertask,
    required int? remindBefore,
  }) async {
    final scheduledDates = _scheduleWeekly(
        Time(
          int.parse(remindertask!.startTime.toString().split(':')[0]),
          int.parse(remindertask.startTime.toString().split(':')[1]),
        ),
        days: [
          remindertask.date!.weekday,
        ]);

    for (int i = 0; i < scheduledDates.length; i++) {
      final scheduledDate = scheduledDates[i];

      _notifications.zonedSchedule(
        id + i,
        remindertask.title,
        remindertask.note,
        scheduledDate,
        await _notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

  static tz.TZDateTime _scheduleDaily(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        time.hour, time.minute, time.second);

    return scheduledDate.isBefore(now)
        ? scheduledDate.add(Duration(days: 1))
        : scheduledDate;
  }

  static List<tz.TZDateTime> _scheduleWeekly(Time time,
      {required List<int> days}) {
    return days.map((day) {
      tz.TZDateTime scheduledDate = _scheduleDaily(time);

      while (day != scheduledDate.weekday) {
        scheduledDate = scheduledDate.add(Duration(days: 1));
      }
      return scheduledDate;
    }).toList();
  }

  static void showScheduledNotification_yearly({
    int id = 3,
    // String? title,
    // String? body,
    String? payload,
    m.ReminderTask? latestreminder,
    required int? remindBefore,
  }) async {
    for (int i = 0; i < 15; i++) {
      DateTime scheduledDate = DateTime(
        latestreminder!.date!.year + i,
        latestreminder.date!.month,
        latestreminder.date!.day,
        int.parse(
          latestreminder.startTime.toString().split(':')[0],
        ),
        int.parse(
          latestreminder.startTime.toString().split(':')[1],
        ),
      );
      print(scheduledDate.year);

      _notifications.zonedSchedule(
        id + i,
        latestreminder!.title,
        latestreminder.note,
        tz.TZDateTime.from(
            scheduledDate.subtract(
              Duration(minutes: remindBefore!),
            ),
            tz.local),
        await _notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }
}
