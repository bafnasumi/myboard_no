import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:myboardapp/boxes.dart';
import 'package:myboardapp/models/myboard.dart' as m;
import '../data/db/db_helper.dart';
import '../data/entity/task.dart';

var boxofreminders = BoxOfReminders.getReminders();

class ReminderController extends ChangeNotifier {
  late m.ReminderTask _reminderTask;

 
  void setReminder(m.ReminderTask reminderTask) {
    _reminderTask = reminderTask;
    notifyListeners();
  }

  void addReminder(m.ReminderTask reminderTask) {
    boxofreminders.add(reminderTask);
    notifyListeners();
  }

  void removeReminder(id) {
    boxofreminders.delete(id);
    notifyListeners();
  }

  void emptyReminder() async {
    await boxofreminders.clear();
    notifyListeners();
  }
















  //List<reminderTask> taskList = <reminderTask>[].obs;

  // Future<int> addTask({required reminderTask task}) async {
  //   return await DbHelper.insertDb(task: task);
  // }

  // Future<void> getAllTask() async {
  //   final tasks = await DbHelper.getAllTask();
  //   taskList
  //       .assignAll(tasks.map((task) => reminderTask.fromJson(task)).toList());
  // }

  // Future<int> deleteTask({required reminderTask task}) async {
  //   final index = await DbHelper.deleteTask(task);
  //   getAllTask();
  //   return index;
  // }

  // Future<int> completedTask({required int id}) async {
  //   final index = await DbHelper.submitCompletedTask(id);
  //   getAllTask();
  //   return index;
  // }
}
