// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_print

// import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myboardapp/boxes.dart';
import 'package:myboardapp/pages/remind/notificationApi.dart';
import 'package:provider/provider.dart';
import '../../../boardState.dart';
import '../../../homepage.dart';
import '../../controller/task_controller.dart';
import '../../data/entity/color_task_type.dart';
import '../../data/entity/time_mode.dart';
import '../../ui/text_theme.dart';
import '../../ui/widget/button.dart';
import '../../ui/widget/input_field.dart';
import 'package:myboardapp/models/myboard.dart' as m;

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key, payload2}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  DateTime? _selectDate = DateTime.now();
  String startTime = DateFormat('hh:mm a').format(DateTime.now()).toString();
  DateTime? selectStartDate;

  int? _alarmId = 0;
  bool? value = false;
  //DateTime _selectEndDate = DateTime.now();

  // static Future<void> callback() async {
  //   // developer.log('Alarm fired!');
  //   // // Get the previous cached count and increment it.
  //   // final prefs = await SharedPreferences.getInstance();
  //   // final currentCount = prefs.getInt(countKey) ?? 0;
  //   // await prefs.setInt(countKey, currentCount + 1);

  //   // // This will be null if we're running in the background.
  //   // uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
  //   // uiSendPort?.send(null);
  //   print('Alarm fired');
  // }

  callback_for_alarm(DateTime? combinedDate, String? title) {
    if (_isAlarmEnabled!) {
      FlutterAlarmClock.createAlarm(combinedDate!.hour, combinedDate.minute,
          title: title!, skipUi: true);
    } else {
      print('ALarm mot enabledd');
    }
    // throw 'todo';
  }

  String endTime = '12:00 AM';
  List<String> reminders = ['5', '10', '15', '30'];
  String _selectReminder = '5';
  List<String> repeats = ['None', 'Daily', 'Weekly', 'Yearly'];
  String _selectRepeats = 'None';
  ColorTaskType _selectColor = ColorTaskType.blue;
  TimeOfDay? _selectstarttime =
      TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: 10)));
  TimeOfDay? _selectendtime;
  String? hintText_startTime = DateFormat('hh:mm a')
      .format(
        DateTime.now().add(
          Duration(minutes: 10),
        ),
      )
      .toString();

  String? hintText_endTime =
      DateFormat('hh:mm a').format(DateTime.now()).toString();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  void getRepeats(int repeatIndex) {
    setState(() {
      _selectRepeats = repeats[repeatIndex];
    });
    // return repeats[repeatIndex];
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  // String getText(TimeOfDay newtime) {
  //   if (_selectstarttime == null) {
  //     return 'Select Time';
  //   } else {
  //     return '${newtime!.hour}:${newtime!.minute}';
  //   }
  // }

  Future pickTime(BuildContext context) async {
    TimeOfDay initialTime = TimeOfDay(
        hour: DateTime.now().hour, minute: DateTime.now().minute + 10);
    final newtime =
        await showTimePicker(context: context, initialTime: _selectstarttime!);
    setState(() {
      _selectstarttime = newtime;
    });
    if (newtime != null && newtime != _selectstarttime) {
      setState(() => _selectstarttime = newtime);
      print(newtime);
      final AMorPM = newtime.hour > 12 ? 'PM' : 'AM';
      final hourIn12 = newtime.hour > 12 ? newtime.hour - 12 : newtime.hour;
      setState(() {
        hintText_startTime = '${pad(hourIn12)}:${pad(newtime.minute)} $AMorPM';
      });
      return hintText_startTime;
    } else {
      print(newtime);
      return initialTime;
    }

    // if (newtime == null) return;
    // setState(() {
    //   hintText_startTime = '${pad(newtime.hour)}:${pad(newtime.minute)}';
    // });
    // return hintText_startTime;
  }

  String pad(int input) {
    String str = input.toString();

    if (input < 10) {
      str = "0" + input.toString();
    }
    return str;
  }

  Future pickEndTime(BuildContext context) async {
    final initialTime = TimeOfDay(hour: 9, minute: 0);
    final newendtime = await showTimePicker(
        context: context, initialTime: _selectendtime ?? initialTime);
    if (newendtime == null) return;
    setState(() {
      hintText_endTime = '${newendtime.hour}:${newendtime.minute}';
    });
    return hintText_endTime;
  }

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    // Provider.of<NotificationService>(context, listen: false).initialize();
  }

  bool? _isAlarmEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: addTaskAppbar(context),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, right: 20, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Task',
                style: CustomTextTheme().heading6Style,
              ),
              // IconButton(
              //   onPressed: () {
              //     // AndroidAlarmManager.oneShotAt(
              //     //     DateTime.now().add(
              //     //       Duration(seconds: 2),
              //     //     ),
              //     //     0,
              //     //     callback,
              //     //     alarmClock: true,
              //     //     wakeup: true);
              //     FlutterAlarmClock.createAlarm(15, 49,
              //         title: 'this is the title', skipUi: true);
              //     var snackbar = SnackBar(
              //       content: Text(
              //         'alarm created',
              //       ),
              //     );
              //     ScaffoldMessenger.of(context).showSnackBar(snackbar);
              //   },
              //   icon: Icon(Icons.alarm),
              // ),
              const SizedBox(
                height: 8,
              ),
              CustomInputField(
                title: 'Title',
                hint: 'Enter Title Here.',
                controller: titleController,
              ),
              GestureDetector(
                //onTap: FocusScope.of(context).requestFocus(FocusNode()),
                child: CustomInputField(
                  title: 'Note',
                  hint: 'Enter Note Here.',
                  controller: noteController,
                ),
              ),

              CustomInputField(
                title: 'Date',
                //controller: dateController,
                // hint: DateFormat.yMd().format(_selectDate!),
                hint: DateFormat.yMMMEd().format(_selectDate!),
                widget: _customIcon(
                  iconData: Icons.calendar_today_outlined,
                  onTap: () async {
                    // _selectDate = _getDateFromUser();
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2025),
                    );

                    // setState(() {
                    //   _selectDate = _selectDate;
                    // });
                    //&& _selectDate != selectedDate

                    // if (pickedDate == null) {
                    // } else {
                    //   setState(() => _selectDate = pickedDate);
                    //   print(_selectDate);
                    // }
                    if (picked != null && picked != _selectDate) {
                      setState(() => _selectDate = picked);
                      print(picked);
                    } else {
                      print(picked);
                    }
                  },
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomInputField(
                      title: 'Time',
                      hint: hintText_startTime!,
                      widget: _customIcon(
                        iconData: Icons.access_time_rounded,
                        onTap: () async {
                          hintText_startTime = await pickTime(context);
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: 12,
              ),
              CustomInputField(
                title: 'Reminder',
                hint: '$_selectReminder minutes early',
                widget: _customDropDown(
                  list: reminders,
                  iconData: Icons.keyboard_arrow_down_outlined,
                  isReminder: true,
                ),
              ),
              CustomInputField(
                title: 'Repeats',
                hint: _selectRepeats,
                widget: _customDropDown(
                  list: repeats,
                  iconData: Icons.keyboard_arrow_down_outlined,
                  isReminder: false,
                ),
              ),

              CheckboxListTile(
                title: Text('Do you want to enable alarm for this task?'),
                value: value,
                onChanged: (bool? value1) {
                  setState(() {
                    this.value = value1;
                    _isAlarmEnabled = value1;
                  });
                },
              ),

              const SizedBox(
                height: 18,
              ),
              CustomButton(
                  label: 'Create Task',
                  onTap: () async {
                    print(_selectDate);
                    DateTime? combinedDate = DateTime(
                      _selectDate!.year,
                      _selectDate!.month,
                      _selectDate!.day,
                      _selectstarttime!.hour,
                      _selectstarttime!.minute - int.parse(_selectReminder),
                      _selectstarttime!.minute,
                    );

                    if (_validateInput(_selectstarttime)) {
                      if (combinedDate.isAfter(DateTime.now())) {
                        //_validateInput();
                        // _validateDateTime(combinedDate);
                        //print(_selectDate);
                        Provider.of<ReminderController>(context, listen: false)
                            .addReminder(
                          m.ReminderTask(
                            title: titleController.text,
                            note: noteController.text,
                            date: _selectDate,
                            //color: colorController.text,
                            isCompleted: 0,
                            startTime: hintText_startTime,
                            endTime: hintText_endTime,
                            reminder: int.parse(_selectReminder),
                            //int.tryParse(reminderController.text) ?? 100,
                            repeat: _selectRepeats,
                            alarm: _isAlarmEnabled,
                          ),
                        );

                        final box = BoxOfReminders.getReminders();
                        final latestreminder = box.getAt(box.length - 1);
                        var index = box.length - 1;
                        //print(pinnedWidgets!.length);
                        //int pinnedWidgetIndex = pinnedWidgets!.length;

                        // pinnedWidgets!.add(
                        //   StaggeredGridTile.count(
                        //     crossAxisCellCount: 2,
                        //     mainAxisCellCount: 1,
                        //     child: PinnedReminder(
                        //         latestreminder!, index, pinnedWidgetIndex),
                        //   ),
                        // );
                        // print(
                        //   ('month: : : ${int.parse(
                        //     latestreminder!.startTime.toString().split(':')[0],
                        //   )}'),
                        // );
                        switch (_selectRepeats) {
                          case "None":
                            {
                              //Notification 1
                              NotificationApi.showScheduledNotification(
                                latestreminder: latestreminder,
                                title: latestreminder!.title,
                                body: latestreminder!.note,
                                remindBefore: int.parse(_selectReminder),
                              );
                            }
                            break;
                          case "Daily":
                            {
                              //Notification 2
                              NotificationApi.showScheduledNotification_daily(
                                remindertask: latestreminder,
                                remindBefore: int.parse(_selectReminder),

                                //payload: payload,
                              );
                            }
                            break;
                          case "Weekly":
                            {
                              //Notification 2

                              NotificationApi.showScheduledNotification_weekly(
                                remindertask: latestreminder,
                                remindBefore: int.parse(_selectReminder),
                              );
                            }
                            break;
                          case "Yearly":
                            {
                              //Notification 2

                              NotificationApi.showScheduledNotification_yearly(
                                latestreminder: latestreminder,
                                remindBefore: int.parse(_selectReminder),
                              );
                            }
                            break;
                        }
                        //print('date: $_selectDate');

                        Provider.of<BoardStateController>(context,
                                listen: false)
                            .addBoardData(
                          m.BoardData(
                            position: BoxOfBoardData.getBoardData().length,

                            // title: titleController.text,
                            // note: noteController.text,
                            // date: _selectDate,
                            // //color: colorController.text,
                            // isCompleted: 0,  ---------------------------not added in board data----------------------------
                            // startTime: hintText_startTime,
                            // endTime: hintText_endTime,
                            // reminder: int.parse(_selectReminder),
                            // //int.tryParse(reminderController.text) ?? 100,
                            // repeat: _selectRepeats,

                            data:
                                ('${titleController.text}*${noteController.text}*${_selectDate!.year}-${_selectDate!.month}-${_selectDate!.day}*${hintText_startTime}*${_selectReminder}*${_selectRepeats}*$_isAlarmEnabled*${latestreminder!.key}'),
                            isDone: false,
                            type: 'reminder',
                          ),
                        );
                        print('hinttext_starttinme: $hintText_startTime');
                        if (_isAlarmEnabled!) {
                          Future.delayed(
                              Duration(
                                days: daysBetween(
                                    DateTime.now().add(Duration(minutes: 10)),
                                    combinedDate),
                              ), () {
                            callback_for_alarm(
                                combinedDate, latestreminder!.title);
                          });
                        } else {
                          print('Alarm no unabled');
                        }

                        // await AndroidAlarmManager.oneShotAt(
                        //     // combinedDate.subtract(
                        //     //   Duration(minutes: 5),
                        //     combinedDate,
                        //     // ),
                        //     _alarmId!,
                        //     callback_for_alarm(
                        //         combinedDate, latestreminder.title));
                        // setState(() {
                        //   _alarmId = _alarmId! + 1;
                        // });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => HomePage()),
                          ),
                        );
                      } else {
                        Get.snackbar('Oops',
                            'Cannot choose a time that has already passed',
                            icon: const Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.white,
                            ),
                            shouldIconPulse: true,
                            colorText: Colors.white,
                            backgroundColor: Colors.grey,
                            snackPosition: SnackPosition.TOP);
                      }
                      // } else {}
                    } else {
                      Get.snackbar('Required', 'All Fields are required !',
                          icon: const Icon(
                            Icons.warning_amber_rounded,
                            color: Colors.white,
                          ),
                          colorText: Colors.white,
                          backgroundColor: Colors.grey,
                          snackPosition: SnackPosition.TOP);
                    }
                  }),
              SizedBox(
                height: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  PinnedReminder(m.ReminderTask? task, int index, int pinnedWidgetIndex) =>
      InkWell(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            //alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            //direction: Axis.horizontal,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 0, 2),
                child: Text(
                  task!.title!,
                  style: GoogleFonts.openSans(fontSize: 13.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 4),
                child: Text(
                  task.note!,
                  style: TextStyle(fontSize: 7.0),
                ),
              ),
            ],
          ),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/reminder_backgroud.png')),
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
          ),
        ),
        onDoubleTap: () {
          boxofreminders.delete(index);
          //pinnedWidgets!.removeAt(pinnedWidgetIndex);
        },
      );

  DropdownButton<String> _customDropDown(
      {required List<String> list,
      required IconData iconData,
      required bool isReminder}) {
    return DropdownButton(
      underline: const SizedBox(
        height: 0,
      ),
      icon: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          iconData,
          color: Colors.black,
        ),
      ),
      iconSize: 28.0,
      onChanged: (String? value) {
        setState(() {
          isReminder
              ? _selectReminder = value ?? _selectReminder
              : _selectRepeats = value ?? _selectRepeats;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          child: Text(
            value,
            style: CustomTextTheme().body2Style,
          ),
          value: value,
        );
      }).toList(),
    );
  }

  InkWell _customIcon({required IconData iconData, required Function() onTap}) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: onTap,
      child: Icon(
        iconData,
      ),
    );
  }

  AppBar addTaskAppbar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      // onBackgroundColor: Colors.white,
      leading: InkWell(
          onTap: () {
            Get.back();
          },
          customBorder: const CircleBorder(),
          child: const Icon(
            CupertinoIcons.back,
            size: 24,
          )),
      // actions: [
      //   InkWell(
      //     onTap: () {},
      //     customBorder: const CircleBorder(),
      //     child: Padding(
      //       padding: const EdgeInsets.all(10.0),
      //       child: Icon(Icons.person),
      //       // SvgPicture.asset(
      //       //   'assets/img/person.svg',
      //       //   width: 36,
      //       //   color: Get.isDarkMode ? Colors.white : Colors.black,
      //       // ),
      //     ),
      //   ),
      // ],
    );
  }

  _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2023),
    );
    setState(() {
      _selectDate = pickerDate ?? _selectDate;
    });
  }

  Future<TimeOfDay?> _showTimePicker(
      {required int hour, required int minute}) async {
    return await showTimePicker(
      context: context,
      initialEntryMode: TimePickerEntryMode.input,
      initialTime: TimeOfDay(
        hour: DateTime.now().hour,
        minute: DateTime.now().minute,
      ),
    );
  }

  _getTimeFromUser(
      {required int hour, required int minute, required TimeMode timeMode}) {
    return _showTimePicker(hour: hour, minute: minute).then((value) => {
          if (value != null)
            {
              if (timeMode == TimeMode.startTime)
                {
                  setState(() {
                    startTime = value.format(context);
                  })
                }
              else
                {
                  setState(() {
                    endTime = value.format(context);
                  })
                }
            }
        });
  }

  _colorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: CustomTextTheme().body1Style,
        ),
        const SizedBox(
          height: 8,
        ),
        Wrap(
            children: List<Widget>.generate(3, (index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectColor = ColorTaskType.values[index];
                });
              },
              child: CircleAvatar(
                radius: 14,
                backgroundColor: index == 0
                    ? Colors.blueGrey
                    : index == 1
                        ? Colors.pink
                        : Colors.yellow,
                child: index == _selectColor.index
                    ? const Icon(
                        Icons.done,
                        color: Colors.white,
                        size: 16,
                      )
                    : const SizedBox.shrink(),
              ),
            ),
          );
        }))
      ],
    );
  }

  bool _validateInput(_selectstarttime) {
    if (titleController.text.isNotEmpty &&
        noteController.text.isNotEmpty &&
        (_selectstarttime != null)) {
      _addTaskToDb();
      //Get.back();
      return true;
    } else {
      Get.snackbar('Required', 'All Fields are required !',
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.white,
          ),
          colorText: Colors.white,
          backgroundColor: Colors.grey,
          snackPosition: SnackPosition.TOP);
      return false;
    }
  }

  _validateDateTime(DateTime? combinedDate) {
    if (combinedDate!.isAfter(DateTime.now())) {
      //_addTaskToDb();
      Get.back();
    } else {
      Get.snackbar('Oops', 'You CANNOT',
          icon: const Icon(
            Icons.warning_amber_rounded,
            color: Colors.white,
          ),
          colorText: Colors.white,
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.TOP);
    }
  }

  void _addTaskToDb() async {
    // int finalTask = await taskController.addTask(
    //   task: reminderTask(
    //     title: titleController.text,
    //     note: noteController.text,
    //     startTime: startTime,
    //     endTime: endTime,
    //     isCompleted: 0,
    //     color: _selectColor.name,
    //     reminder: int.parse(_selectReminder),
    //     repeat: _selectRepeats,
    //     date: DateFormat.yMd().format(_selectDate),
    //   ),
    // );
    // if (kDebugMode) {
    //   print('task ${finalTask.toString()} created!!');
    // }
  }
//   getAlarmNotification(m.ReminderTask latestreminder) {
//     AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: 1,
//         channelKey: 'key1',
//         title: latestreminder.title,
//         body: latestreminder.note,
//         notificationLayout: NotificationLayout.BigText,
//         category: NotificationCategory.Alarm,
//         wakeUpScreen: true,
//       ),
//       actionButtons: [
//         NotificationActionButton(
//           key: 'MARK_DONE',
//           label: 'Mark Done',
//         )
//       ],
//     );

//     AwesomeNotifications().actionStream.listen((receivedNotifiction) {
//       Navigator.of(context).pushNamed(
//         '/reminder',
//       );
//     });
//   }

//   getNotification(m.ReminderTask latestreminder) {
//     AwesomeNotifications().createNotification(
//       content: NotificationContent(
//         id: 1,
//         channelKey: 'key1',
//         title: latestreminder.title,
//         body: latestreminder.note,
//         notificationLayout: NotificationLayout.Default,
//         category: NotificationCategory.Alarm,
//         wakeUpScreen: true,
//       ),
//       actionButtons: [
//         NotificationActionButton(
//           key: 'MARK_DONE',
//           label: 'Mark Done',
//         )
//       ],
//       schedule: NotificationCalendar(
//         repeats: latestreminder.repeat == 'None' ? false : true,
//         year: latestreminder.date!.year,
//         month: latestreminder.date!.month,
//         day: latestreminder.date!.day,
//         hour: int.parse(
//           latestreminder.startTime.toString().split(':')[0],
//         ),
//         minute: int.parse(
//           latestreminder.startTime.toString().split(':')[1],
//         ),
//         second: 0,
//       ),
//     );
//     AwesomeNotifications().createdStream.listen(
//       (Notifiction) {
//         print('from created stream(1): $Notifiction');
//       },
//     );

//     AwesomeNotifications().actionStream.listen(
//       (Notifiction) {
//         print('from action stream(2): $Notifiction');
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => const Reminder(),
//           ),
//         );
//       },
//     );
//   }

}
