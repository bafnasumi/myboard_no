import 'package:get/get.dart';
import '../data/db/db_helper.dart';
import '../data/entity/task.dart';

class TaskController extends GetxController {
  List<reminderTask> taskList = <reminderTask>[].obs;

  Future<int> addTask({required reminderTask task}) async {
    return await DbHelper.insertDb(task: task);
  }

  Future<void> getAllTask() async {
    final tasks = await DbHelper.getAllTask();
    taskList
        .assignAll(tasks.map((task) => reminderTask.fromJson(task)).toList());
  }

  Future<int> deleteTask({required reminderTask task}) async {
    final index = await DbHelper.deleteTask(task);
    getAllTask();
    return index;
  }

  Future<int> completedTask({required int id}) async {
    final index = await DbHelper.submitCompletedTask(id);
    getAllTask();
    return index;
  }
}
