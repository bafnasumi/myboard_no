// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myboardapp/pages/homepage.dart';
import 'package:provider/provider.dart';
import 'package:myboardapp/models/myboard.dart' as m;
import 'package:myboardapp/boxes.dart';
import 'package:hive/hive.dart';

import 'boardState.dart';

class ToDo extends StatefulWidget {
  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 10, 75, 107),
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: AddTaskScreen(),
              ),
            ),
          );
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Todo',
                  style: GoogleFonts.italiana(
                    color: Colors.black,
                    fontSize: 50.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Consumer<TaskController>(builder: (context, taskData, child) {
                  return IconButton(
                      onPressed: () {
                        // taskData.emptyToDo;
                        if (boxoftodos.isNotEmpty) {
                          boxoftodos.clear();
                        } else {
                          var snackBar = SnackBar(
                              content: Text('To-Do list already empty'));
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
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: TasksList(),
            ),
          ),
        ],
      ),
    );
  }
}

// TASK LIST

class TasksList extends StatefulWidget {
  @override
  State<TasksList> createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {
  @override
  Widget build(BuildContext context) {
    return boxoftodos.length == 0
        ? Center(
            child: Text(
            'Add your first todo',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey,
            ),
          ))
        : Consumer<TaskController>(
            builder: (context, taskData, child) {
              return ListView.builder(
                reverse: true,
                itemCount: boxoftodos.length,
                itemBuilder: (context, index) {
                  final task = boxoftodos.getAt(index);
                  return TaskTile(
                    taskTitle: task!.todo,
                    isChecked: task.isDone,
                    checkboxCallback: (checkboxState) {
                      taskData.removeToDo(task.key);
                      setState(() {});
                      const snackBar = SnackBar(
                        content: Text('Todo deleted'),
                      );

                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    // longPressCallback: () {
                    //   taskData.removeToDo(task);
                    //   setState(() {});
                    // },//TODO: on longpress: delete the todo
                  );
                },
                // itemCount: taskData.taskCount,
              );
            },
          );
  }
}

// SINGLE TASK TILE

class TaskTile extends StatelessWidget {
  final bool? isChecked;
  final String? taskTitle;
  final void Function(bool?)? checkboxCallback;
  final void Function()? longPressCallback;

  TaskTile(
      {this.isChecked,
      this.taskTitle,
      this.checkboxCallback,
      this.longPressCallback});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: longPressCallback,
      title: Text(
        taskTitle!,
        style: TextStyle(
            decoration: isChecked! ? TextDecoration.lineThrough : null),
      ),
      trailing: Checkbox(
        activeColor: Color.fromARGB(255, 10, 75, 107),
        value: isChecked,
        onChanged: checkboxCallback,
      ),
    );
  }
}

// ADD TASKS

class AddTaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String? newTaskTitle;

    return Container(
      color: Color(0xff757575),
      child: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Add Task',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                color: Color.fromARGB(255, 10, 75, 107),
              ),
            ),
            TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (newText) {
                newTaskTitle = newText;
              },
            ),
            SizedBox(
              height: 15,
            ),
            // ignore: deprecated_member_use
            ElevatedButton(
              child: Text(
                'Add',
                style: TextStyle(
                    // color: Colors.white,
                    // backgroundcolor: Color.fromARGB(255, 10, 75, 107),
                    ),
              ),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 10, 75, 107),
              ),
              onPressed: () {
                Provider.of<TaskController>(context, listen: false)
                    .addToDo(m.ToDo(todo: newTaskTitle, isDone: false));
                final box = BoxOfToDos.getToDos();
                final latesttodo = box.getAt(box.length - 1);
                var index = box.length - 1;
                //print(pinnedWidgets!.length);
                //int pinnedWidgetIndex = pinnedWidgets!.length;

                // StaggeredGridTile.count(
                //   crossAxisCellCount: 2,
                //   mainAxisCellCount: 1,
                //   child: PinnedToDo(latesttodo!.todo, latesttodo.isDone, index,
                //       pinnedWidgetIndex),
                // );

                Provider.of<BoardStateController>(context, listen: false)
                    .addBoardData(
                  m.BoardData(
                    position: BoxOfBoardData.getBoardData().length,
                    data: latesttodo!.todo,
                    isDone: false,
                    type: 'todo',
                  ),
                );

                Navigator.pushNamed(context, '/homepage');
              },
            ),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  PinnedToDo(
          String? todotext, bool? isDone, int index, int pinnedWidgetIndex) =>
      InkWell(
        child: Container(
          child: Wrap(
            alignment: WrapAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(todotext!),
              ),
            ],
          ),
          decoration: BoxDecoration(
            color: Colors.white70,
            image: DecorationImage(
              image: AssetImage('assets/images/todo_background.png'),
              fit: BoxFit.contain,
            ),
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(
              color: Colors.black,
              width: 2.0,
            ),
          ),
        ),
        onDoubleTap: () {
          isDone = true;
          boxoftodos.delete(index);
          pinnedWidgets!.removeAt(pinnedWidgetIndex);
        },
      );
}

var boxoftodos = BoxOfToDos.getToDos();

// TASK DATA
class TaskController with ChangeNotifier {
  late m.ToDo _todo;

  TaskController() {
    _todo = m.ToDo(todo: 'Hi', isDone: false);
  }

//getters
  m.ToDo get todo => _todo;

//setters
  void setToDo(m.ToDo todo) {
    _todo = todo;
    notifyListeners();
  }

  void addToDo(m.ToDo todo) {
    // boxodtodos = BoxOfToDos.getToDos();
    boxoftodos.add(todo);
    notifyListeners();
  }

  void removeToDo(int todoKey) {
    boxoftodos = BoxOfToDos.getToDos();
    boxoftodos.delete(todoKey);
    notifyListeners();
  }

  void emptyToDo() async {
    boxoftodos = BoxOfToDos.getToDos();
    await boxoftodos.clear();
    notifyListeners();
  }
}
