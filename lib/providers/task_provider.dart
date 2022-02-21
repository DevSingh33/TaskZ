import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  static const boxName = 'task box';

  List<Task> _taskList = [
    Task(
      createdTime: DateFormat.Hm().format(DateTime.now()),
      deadLineDate: DateFormat('dd-MMM-yyyy').format(DateTime.now()),
      deadLineTime: DateFormat.Hm().format(DateTime.now()),
      taskName: 'Buy Time',
      taskId: DateTime.now(),
      completedOn: DateTime.now(),
      createdDate: DateTime.now(),
    ),
    Task(
      createdTime: DateFormat.Hm().format(DateTime.now()),
      deadLineDate: DateFormat('EEEE').format(DateTime.now()),
      // deadLineDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      deadLineTime: DateFormat.Hm().format(DateTime.now()),
      taskName: '2 kg  task',
      completedOn: DateTime.now(),
      taskId: DateTime.now(),
      createdDate: DateTime.now(),
      isImportant: true,
    ),
    //   Task(
    //     createdTime: DateFormat.Hm().format(DateTime.now()),
    //     deadLineDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
    //     deadLineTime: DateFormat.Hm().format(DateTime.now()),
    //     completedOn: DateTime.now(),
    //     taskId: DateTime.now(),
    //     taskName: '90 Movies play',
    //     createdDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
    //   ),
    //   Task(
    //     createdTime: DateFormat.Hm().format(DateTime.now()),
    //     deadLineDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
    //     deadLineTime: DateFormat.Hm().format(DateTime.now()),
    //     completedOn: DateTime.now(),
    //     taskId: DateTime.now(),
    //     taskName: 'Important task 2',
    //     createdDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
    //     isImportant: true,
    //   ),
    //   Task(
    //     createdTime: DateFormat.Hm().format(DateTime.now()),
    //     deadLineDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
    //     deadLineTime: DateFormat.Hm().format(DateTime.now()),
    //     completedOn: DateTime.now(),
    //     taskId: DateTime.now(),
    //     taskName: ' 250 mg panner',
    //     createdDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
    //   ),
    //   Task(
    //     createdTime: DateFormat.Hm().format(DateTime.now()),
    //     deadLineDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
    //     deadLineTime: DateFormat.Hm().format(DateTime.now()),
    //     completedOn: DateTime.now(),
    //     taskId: DateTime.now(),
    //     taskName: 'Important task 3',
    //     createdDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
    //     isImportant: true,
    //   ),
    //   // Task(
    //   //   createdTime: TimeOfDay.now().toString(),
    //   //   deadLineDate: DateTime.now().toString(),
    //   //   deadLineTime: TimeOfDay.now().toString(),
    //   //   taskName: 'Finish This',
    //   //   createdDate: DateTime.now().toString(),
    //   // ),
    //   // Task(
    //   //   createdTime: TimeOfDay.now().toString(),
    //   //   deadLineDate: DateTime.now().toString(),
    //   //   deadLineTime: TimeOfDay.now().toString(),
    //   //   taskName: 'Jaldi Karo ',
    //   //   createdDate: DateTime.now().toString(),
    //   // ),
    // ];
  ];

  void getAllTask() async {
    var box = await Hive.openBox<Task>(boxName);
    _taskList = box.values.toList();
    print('item in hive box : $_taskList');
    print('box.keys : ${box.keys}');
    notifyListeners();
  }

  // List<Task> get getAllTaskList {
  //   return [..._taskList];
  // }

  // List<Task> get getTaskList {
  //   if (_taskList != null && _taskList.isNotEmpty) {
  //     _taskList.sort((a, b) => (a.deadLineDate.compareTo(b.deadLineDate)));
  //     print(_taskList.first.taskName);
  //     return [
  //       ..._taskList.where((element) => element.isImportant == false).toList()
  //     ];
  //   } else {
  //     print('empty list');
  //     return [];
  //   }
  // }

  // List<Task> get getPriortyList {
  //   if (_taskList != null && _taskList.isNotEmpty) {
  //     _taskList.sort((a, b) => (a.deadLineDate.compareTo(b.deadLineDate)));
  //     List<Task> newPriorityList =
  //         _taskList.where((item) => item.isImportant == true).toList();
  //     return [...newPriorityList];
  //   } else {
  //     print('empty list');
  //     return [];
  //   }
  // }

  List<Task> _completedTask = [];
  void getCompletedTasksF() async {
    var box = await Hive.openBox<Task>(boxName);
    _completedTask =
        box.values.where((task) => task.isFinished == true).toList();
    _taskList = box.values.toList();
  }

  List<Task> get getCompletedTasksList {
    List<Task> completedTasks =
        _taskList.where((task) => task.isFinished == true).toList();
    return [...completedTasks];
  }

  String stringOfDedTime = '';
  DateTime objectOfDedTime = DateTime.now();

  void sortTaskByTime() {
    _sortedTasksByDate.sort((a, b) => a.deadLineTime.compareTo(b.deadLineTime));
  }

  String stringOfSelectedDate = '';
  DateTime objectOfSelectedDate = DateTime.now();
  List<Task> _sortedTasksByDate = [];
//  String stringOfToday = DateFormat('dd-MMM').format(DateTime.now());

  void sortTaskByDate(DateTime date) async {
    objectOfSelectedDate = date;
    stringOfSelectedDate = DateFormat('dd-MM-yyyy').format(date);
    var box = await Hive.openBox<Task>(boxName);
    _sortedTasksByDate = box.values
        .where((task) => task.deadLineDate == stringOfSelectedDate)
        .toList();
    print('sorted task by date : $_sortedTasksByDate');
    _taskList = box.values.toList();

    notifyListeners();
  }
  // List<Task> get getSortedTaskList {
  //   return [..._sortedTasksByDate];
  // }

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

  int currentTotalTaskCount(List<Task> tskList) {
    return tskList.length;
  }

  int currentFinishedTaskCount(List<Task> tskList) {
    List<Task> newList =
        tskList.where((task) => task.isFinished == true).toList();
    //notifyListeners();
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
    // _taskList[editItemIndex] = edititedTask;
    await box.putAt(editItemIndex, edititedTask);
    _taskList = box.values.toList();
    _sortedTasksByDate = box.values
        .where((task) => task.deadLineDate == stringOfSelectedDate)
        .toList();
    _taskList = box.values.toList();
    notifyListeners();
  }

  // void removeTask({required int indx}) async {
  //   var box = await Hive.openBox<Task>(boxName);
  //   await box.deleteAt(indx);
  //   _taskList = box.values.toList();
  //   notifyListeners();
  // }
  void removeTask({required DateTime id, required String taskTitle}) async {
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

  void deleteOldTasks() async {
    var box = await Hive.openBox<Task>(boxName);
    _taskList = box.values.toList();
    List<Task> toDeleteOlderTasks = box.values
        .where((task) =>
            task.createdDate.day ==
            DateTime.now().subtract(Duration(days: 4)).day)
        .toList();
    for (Task task in toDeleteOlderTasks) {
      if (toDeleteOlderTasks.isNotEmpty) {
        await box.deleteAt(_taskList.indexOf(task));
        print('old 4 days task ${task.taskName}');
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
    // Future.delayed(const Duration(seconds: 2), () {});
    notifyListeners();
  }
}
