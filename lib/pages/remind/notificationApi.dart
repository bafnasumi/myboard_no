// ignore_for_file: unused_field, unused_element, prefer_const_constructors, non_constant_identifier_names

import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
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

  static Future showScheduledNotification_onTime({
    int id = 5,
    String? title,
    String? body,
    String? payload,
    required m.ReminderTask? latestreminder,
    required int? remindBefore,
  }) async {
    List<String> starttime_in_int_in_24() {
      if (latestreminder!.startTime!.substring(6) == 'AM') {
        print(latestreminder!.startTime!.substring(0, 5).split(':'));
        return latestreminder!.startTime!.substring(0, 5).split(':');
      } else {
        //var var_substring = latestreminder!.startTime!.substring(0)
        var hour = int.parse(latestreminder!.startTime!.split(':')[0]);
        var minute =
            int.parse(latestreminder!.startTime!.split(':')[1].substring(0, 2));
        hour = hour + 12;
        print('hour from notification API');
        print(hour.toString());
        print('minute from notification API');

        print(minute.toString());
        return [hour.toString(), minute.toString()];
      }
    }

    var var_starttime_in_int_in_24 = starttime_in_int_in_24();

    var starttimein24 = latestreminder!.startTime!.substring(0, 5);
    print(starttimein24);
    DateTime scheduledDate = DateTime(
      latestreminder!.date!.year,
      latestreminder.date!.month,
      latestreminder.date!.day,
      int.parse(var_starttime_in_int_in_24[0]),
      int.parse(var_starttime_in_int_in_24[1]),
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

  static Future showScheduledNotification_beforetime({
    int id = 5,
    String? title,
    String? body,
    String? payload,
    required m.ReminderTask? latestreminder,
    required int? remindBefore,
  }) async {
    List<String> starttime_in_int_in_24() {
      if (latestreminder!.startTime!.substring(6) == 'AM') {
        print(latestreminder!.startTime!.substring(0, 5).split(':'));
        return latestreminder!.startTime!.substring(0, 5).split(':');
      } else {
        //var var_substring = latestreminder!.startTime!.substring(0)
        var hour = int.parse(latestreminder!.startTime!.split(':')[0]);
        var minute =
            int.parse(latestreminder!.startTime!.split(':')[1].substring(0, 2));
        hour = hour + 12;
        print('hour from notification API');
        print(hour.toString());
        print('minute from notification API');

        print(minute.toString());
        return [hour.toString(), minute.toString()];
      }
    }

    var var_starttime_in_int_in_24 = starttime_in_int_in_24();

    var starttimein24 = latestreminder!.startTime!.substring(0, 5);
    print(starttimein24);
    DateTime scheduledDate = DateTime(
      latestreminder!.date!.year,
      latestreminder.date!.month,
      latestreminder.date!.day,
      int.parse(var_starttime_in_int_in_24[0]),
      int.parse(var_starttime_in_int_in_24[1]) - remindBefore!,
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
    List<String> starttime_in_int_in_24() {
      if (remindertask!.startTime!.substring(6) == 'AM') {
        print(remindertask!.startTime!.substring(0, 5).split(':'));
        return remindertask!.startTime!.substring(0, 5).split(':');
      } else {
        var hour = int.parse(remindertask!.startTime!.split(':')[0]);
        var minute = int.parse(remindertask!.startTime!.split(':')[1]);
        hour = hour + 12;
        return [hour.toString(), minute.toString()];
      }
    }

    var var_starttime_in_int_in_24 = starttime_in_int_in_24();
    _notifications.zonedSchedule(
      id,
      'Reminder Scheduled: ${remindertask!.title}',
      remindertask.note,
      _scheduleDaily(
        Time(
          int.parse(var_starttime_in_int_in_24[0]),
          int.parse(var_starttime_in_int_in_24[1]),
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
    List<String> starttime_in_int_in_24() {
      if (remindertask!.startTime!.substring(6) == 'AM') {
        print(remindertask!.startTime!.substring(0, 5).split(':'));
        return remindertask!.startTime!.substring(0, 5).split(':');
      } else {
        var hour = int.parse(remindertask!.startTime!.split(':')[0]);
        var minute = int.parse(remindertask!.startTime!.split(':')[1]);
        hour = hour + 12;
        return [hour.toString(), minute.toString()];
      }
    }

    var var_starttime_in_int_in_24 = starttime_in_int_in_24();
    final scheduledDates = _scheduleWeekly(
        Time(
          int.parse(var_starttime_in_int_in_24[0]),
          int.parse(var_starttime_in_int_in_24[1]),
        ),
        days: [
          remindertask!.date!.weekday,
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
    List<String> starttime_in_int_in_24() {
      if (latestreminder!.startTime!.substring(6) == 'AM') {
        print(latestreminder!.startTime!.substring(0, 5).split(':'));
        return latestreminder!.startTime!.substring(0, 5).split(':');
      } else {
        var hour = int.parse(latestreminder!.startTime!.split(':')[0]);
        var minute = int.parse(latestreminder!.startTime!.split(':')[1]);
        hour = hour + 12;
        return [hour.toString(), minute.toString()];
      }
    }

    var var_starttime_in_int_in_24 = starttime_in_int_in_24();
    for (int i = 0; i < 15; i++) {
      DateTime scheduledDate = DateTime(
        latestreminder!.date!.year + i,
        latestreminder.date!.month,
        latestreminder.date!.day,
        int.parse(var_starttime_in_int_in_24[0]),
        int.parse(var_starttime_in_int_in_24[1]),
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
