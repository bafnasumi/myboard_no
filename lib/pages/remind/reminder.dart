// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'controller/task_controller.dart';
import 'data/entity/task.dart';
import 'service/notify_service.dart';
import 'service/theme_service.dart';
import 'ui/add_task/add_task_screen.dart';
import 'ui/colors.dart';
import 'ui/text_theme.dart';
import 'ui/widget/button.dart';
import 'ui/widget/task_item.dart';
import 'package:myboardapp/models/myboard.dart' as m;

class Reminder extends StatefulWidget {
  const Reminder({Key? key}) : super(key: key);

  @override
  State<Reminder> createState() => _ReminderState();
}

class _ReminderState extends State<Reminder> {
  // late final NotifyService notifyService;
  DateTime currentDate = DateTime.now();
  double screenHeight() {
    return MediaQuery.of(context).size.height;
  }

  // final TaskController _taskController = Get.put(TaskController());

  @override
  void initState() {
    super.initState();
    // notifyService = NotifyService();
    // notifyService.initializeNotification();
    // notifyService.requestIOSPermissions();
    // // _taskController.getAllTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
                top: 70.0, left: 30.0, right: 30.0, bottom: 30.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_outlined),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  iconSize: 40.0,
                ),

                Text(
                  'Reminder',
                  style: GoogleFonts.italiana(
                    color: Colors.black,
                    fontSize: 45.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Consumer<ReminderController>(
                    builder: (context, taskData, child) {
                  return IconButton(
                      onPressed: () {
                        // taskData.emptyToDo;
                        if (boxofreminders.isNotEmpty) {
                          boxofreminders.clear();
                        } else {
                          var snackBar = SnackBar(
                            content: Text('Reminder list already empty'),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                        setState(() {});
                      },
                      icon: Icon(Icons.delete));
                }),
                // Text(
                //   '${Provider.of<TaskController>(context).taskCount} Tasks',
                //   style: TextStyle(
                //     color: Colors.black,
                //     fontSize: 18,
                //   ),
                // ),
              ],
            ),
          ),
          _addTaskBar(),
          //_addDataBar(),
          const SizedBox(
            height: 12,
          ),
          Expanded(child: _allTask())
        ],
      ),
    );
  }

  Widget _addTaskBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMMd().format(DateTime.now()),
                style: CustomTextTheme().subHeading1Style,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                'Today',
                style: CustomTextTheme().heading4Style,
              )
            ],
          ),
          CustomButton(
            label: '+ Add Task',
            onTap: () async {
              await Get.to(() => AddTaskScreen());
              // _taskController.getAllTask();
            },
          )
        ],
      ),
    );
  }

  Widget _allTask() {
    return boxofreminders.length == 0
        ? Center(
            child: Text(
            'Add your first reminder',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ))
        : Consumer<ReminderController>(builder: (context, reminderData, child) {
            return ListView.builder(
              reverse: true,
              shrinkWrap: true,
              padding: EdgeInsets.all(8),
              itemCount: boxofreminders.length,
              itemBuilder: (BuildContext context, int index) {
                print(
                    'Boxofreminder length::::::::::  ${boxofreminders.length}');
                var task = boxofreminders.getAt(index);
                // if (task.repeat!.toLowerCase() == 'daily' ||
                //     task.date == DateFormat.yMd().format(currentDate))
                {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      child: FadeInAnimation(
                        child: TaskItem(
                          task: task!,
                          onTap: () {
                            _showBottomSheet(context, task);
                          },
                        ),
                      ),
                    ),
                  );
                }
              },
            );
          });
  }

  void _showBottomSheet(BuildContext context, m.ReminderTask task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 4),
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.24
            : MediaQuery.of(context).size.height * 0.32,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(16),
            topLeft: Radius.circular(16),
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
            ),
            const Spacer(),
            if (task.isCompleted == 0) _completedButtonBottomSheet(task),
            _deleteButtonBottomSheet(task),
            const SizedBox(
              height: 20,
            ),
            _closeButtonBottomSheet(),
          ],
        ),
      ),
    );
  }

  _completedButtonBottomSheet(m.ReminderTask task) {
    return _buttonBottomSheet(
        //color: ColorPalette.primaryClr,
        color: Colors.red[100]!,
        label: 'Task Completed',
        onTap: () async {
          // await _taskController.completedTask(id: task.id!);
          Get.back();
        });
  }

  _deleteButtonBottomSheet(m.ReminderTask task) {
    return _buttonBottomSheet(
        color: Colors.red[100]!,
        label: 'Delete Task',
        onTap: () async {
          // await _taskController.deleteTask(task: task);
          Navigator.of(context).pop();
        });
  }

  _closeButtonBottomSheet() {
    return _buttonBottomSheet(
        color: Colors.white70,
        label: 'Close',
        isClosed: true,
        borderColor: Colors.white,
        onTap: () {
          Get.back();
        });
  }

  _buttonBottomSheet(
      {required Color color,
      required String label,
      Function()? onTap,
      Color? borderColor,
      bool isClosed = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width * 0.9,
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(width: 2, color: borderColor ?? color),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: CustomTextTheme().body2Style.copyWith(
                // color: !isClosed
                //     ? Colors.white
                //     : Get.isDarkMode
                //         ? Colors.white
                //         : Colors.black,
                color: Colors.black,
                fontSize: 16),
          ),
        ),
      ),
    );
  }
}
