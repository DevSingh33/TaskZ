import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  static const boxName = 'task box';

  List<Task> _taskList = [];

  String stringOfDedTime = '';
  DateTime objectOfDedTime = DateTime.now();

  String stringOfSelectedDate = '';
  DateTime objectOfSelectedDate = DateTime.now();
  List<Task> _sortedTasksByDate = [];

  void getAllTask() async {
    var box = await Hive.openBox<Task>(boxName);
    _taskList = box.values.toList();
    notifyListeners();
  }

  List<Task> get getOtherTaskList {
    return [
      ..._sortedTasksByDate.where((task) => task.isImportant == false).toList()
    ];
  }

  List<Task> get getPriortyList {
    List<Task> newPriorityList =
        _sortedTasksByDate.where((item) => item.isImportant == true).toList();
    return [...newPriorityList];
  }

  List<Task> get getCompletedTasksList {
    List<Task> completedTasks =
        _taskList.where((task) => task.isFinished == true).toList();
    return [...completedTasks];
  }

  void sortTaskByDate(DateTime date) async {
    objectOfSelectedDate = date;
    stringOfSelectedDate = DateFormat('dd-MM-yyyy').format(date);
    var box = await Hive.openBox<Task>(boxName);
    _sortedTasksByDate = box.values
        .where((task) => task.deadLineDate == stringOfSelectedDate)
        .toList();
    _taskList = box.values.toList();

    notifyListeners();
  }

  int currentTotalTaskCount(List<Task> tskList) {
    return tskList.length;
  }

  int currentFinishedTaskCount(List<Task> tskList) {
    List<Task> newList =
        tskList.where((task) => task.isFinished == true).toList();
    return newList.length;
  }

  int get getTotalTaskCount {
    return _taskList.length;
  }

  int get getTotalDoneTaskCount {
    return getCompletedTasksList.length;
  }

  void addNewTask(
      {required String crtTime,
      required String dedTime,
      required DateTime crtDate,
      required String dedDate,
      required String tskName,
      required bool isImprtnt}) async {
    var box = await Hive.openBox<Task>(boxName);
    await box.add(
      Task(
          createdTime: crtTime,
          deadLineDate: dedDate,
          deadLineTime: dedTime,
          taskName: tskName,
          createdDate: crtDate,
          isImportant: isImprtnt,
          taskId: DateTime.now(),
          completedOn: DateTime.now()),
    );
    _taskList = box.values.toList();
    _sortedTasksByDate = box.values
        .where((task) => task.deadLineDate == stringOfSelectedDate)
        .toList();
    _taskList = box.values.toList();

    notifyListeners();
  }

  void editTask({required DateTime taskId, required Task edititedTask}) async {
    var box = await Hive.openBox<Task>(boxName);
    _taskList = box.values.toList();
    Task toEditTask = _taskList.firstWhere((task) => task.taskId == taskId);
    int editItemIndex = _taskList.indexOf(toEditTask);

    await box.putAt(editItemIndex, edititedTask);
    _taskList = box.values.toList();
    _sortedTasksByDate = box.values
        .where((task) => task.deadLineDate == stringOfSelectedDate)
        .toList();
    _taskList = box.values.toList();
    notifyListeners();
  }

  void toggleTask(
      {required DateTime id,
      required String taskTitle,
      required DateTime completeOnDate,
      required bool newVal}) async {
    var box = await Hive.openBox<Task>(boxName);
    _taskList = box.values.toList();
    Task toModifyTask = _taskList.firstWhere(
      (item) => item.taskId == id && item.taskName == taskTitle,
    );
    toModifyTask.isFinished = newVal;
    toModifyTask.completedOn = completeOnDate;

    int toModifyTaskIndex = _taskList.indexOf(toModifyTask);
    await box.putAt(toModifyTaskIndex, toModifyTask);
    _taskList = box.values.toList();

    notifyListeners();
  }

  void removeSingleTask(
      {required DateTime id, required String taskTitle}) async {
    var box = await Hive.openBox<Task>(boxName);
    _taskList = box.values.toList();
    Task toDeleteTask = _taskList
        .firstWhere((task) => task.taskId == id && task.taskName == taskTitle);
    int toDeleteItemIndex = _taskList.indexOf(toDeleteTask);
    await box.deleteAt(toDeleteItemIndex);

    _sortedTasksByDate = box.values
        .where((task) => task.deadLineDate == stringOfSelectedDate)
        .toList();
    _taskList = box.values.toList();
    notifyListeners();
  }

  void deleteAllCompletedTasks() async {
    var box = await Hive.openBox<Task>(boxName);
    _taskList = box.values.toList();
    List<Task> toDeleteTasks =
        box.values.where((task) => task.isFinished == true).toList();

    for (Task task in toDeleteTasks) {
      if (toDeleteTasks.isNotEmpty) {
        await box.deleteAt(_taskList.indexOf(task));
        _taskList =
            box.values.toList(); //updating list after every deletioin performed
      } else {
        return;
      }
    }
    _sortedTasksByDate = box.values
        .where((task) => task.deadLineDate == stringOfSelectedDate)
        .toList();
    _taskList = box.values.toList();
    notifyListeners();
  }

  // void deleteOldTasks() async {
  //   var box = await Hive.openBox<Task>(boxName);
  //   _taskList = box.values.toList();
  //   List<Task> toDeleteOlderTasks = box.values
  //       .where((task) =>
  //           task.createdDate.day ==
  //           DateTime.now().subtract(const Duration(days: 4)).day)
  //       .toList();
  //   for (Task task in toDeleteOlderTasks) {
  //     if (toDeleteOlderTasks.isNotEmpty) {
  //       await box.deleteAt(_taskList.indexOf(task));
  //       _taskList =
  //           box.values.toList(); //updating list after every deletioin performed
  //     } else {
  //       return;
  //     }
  //   }
  //   _sortedTasksByDate = box.values
  //       .where((task) => task.deadLineDate == stringOfSelectedDate)
  //       .toList();
  //   _taskList = box.values.toList();
  //   notifyListeners();
  // }

}
