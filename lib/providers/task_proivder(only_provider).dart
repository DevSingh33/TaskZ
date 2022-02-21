// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// import '../models/task.dart';

// class TaskProvider extends ChangeNotifier {
//   final List<Task> _taskList = [
//     //   Task(
//     //     createdTime: DateFormat.Hm().format(DateTime.now()),
//     //     deadLineDate: DateFormat('dd-MMM-yyyy').format(DateTime.now()),
//     //     deadLineTime: DateFormat.Hm().format(DateTime.now()),
//     //     taskName: 'Buy Time',
//     //     taskId: DateTime.now(),
//     //     completedOn: DateTime.now(),
//     //     createdDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
//     //   ),
//     //   Task(
//     //     createdTime: DateFormat.Hm().format(DateTime.now()),
//     //     deadLineDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
//     //     deadLineTime: DateFormat.Hm().format(DateTime.now()),
//     //     taskName: '2 kg  task',
//     //     completedOn: DateTime.now(),
//     //     taskId: DateTime.now(),
//     //     createdDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
//     //     isImportant: true,
//     //   ),
//     //   Task(
//     //     createdTime: DateFormat.Hm().format(DateTime.now()),
//     //     deadLineDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
//     //     deadLineTime: DateFormat.Hm().format(DateTime.now()),
//     //     completedOn: DateTime.now(),
//     //     taskId: DateTime.now(),
//     //     taskName: '90 Movies play',
//     //     createdDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
//     //   ),
//     //   Task(
//     //     createdTime: DateFormat.Hm().format(DateTime.now()),
//     //     deadLineDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
//     //     deadLineTime: DateFormat.Hm().format(DateTime.now()),
//     //     completedOn: DateTime.now(),
//     //     taskId: DateTime.now(),
//     //     taskName: 'Important task 2',
//     //     createdDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
//     //     isImportant: true,
//     //   ),
//     //   Task(
//     //     createdTime: DateFormat.Hm().format(DateTime.now()),
//     //     deadLineDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
//     //     deadLineTime: DateFormat.Hm().format(DateTime.now()),
//     //     completedOn: DateTime.now(),
//     //     taskId: DateTime.now(),
//     //     taskName: ' 250 mg panner',
//     //     createdDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
//     //   ),
//     //   Task(
//     //     createdTime: DateFormat.Hm().format(DateTime.now()),
//     //     deadLineDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
//     //     deadLineTime: DateFormat.Hm().format(DateTime.now()),
//     //     completedOn: DateTime.now(),
//     //     taskId: DateTime.now(),
//     //     taskName: 'Important task 3',
//     //     createdDate: DateFormat('dd-MM-yyyy').format(DateTime.now()),
//     //     isImportant: true,
//     //   ),
//     //   // Task(
//     //   //   createdTime: TimeOfDay.now().toString(),
//     //   //   deadLineDate: DateTime.now().toString(),
//     //   //   deadLineTime: TimeOfDay.now().toString(),
//     //   //   taskName: 'Finish This',
//     //   //   createdDate: DateTime.now().toString(),
//     //   // ),
//     //   // Task(
//     //   //   createdTime: TimeOfDay.now().toString(),
//     //   //   deadLineDate: DateTime.now().toString(),
//     //   //   deadLineTime: TimeOfDay.now().toString(),
//     //   //   taskName: 'Jaldi Karo ',
//     //   //   createdDate: DateTime.now().toString(),
//     //   // ),
//     // ];
//   ];
//   List<Task> get getAllTaskList {
//     return [..._taskList];
//   }

//   List<Task> get getTaskList {
//     return [
//       ..._taskList.where((element) => element.isImportant == false).toList()
//     ];
//   }

//   List<Task> get getPriortyList {
//     List<Task> newPriorityList =
//         _taskList.where((item) => item.isImportant == true).toList();
//     return [...newPriorityList];
//   }

//   List<Task> get getCompletedTasksList {
//     List<Task> completedTasks =
//         _taskList.where((task) => task.isFinished == true).toList();
//     return [...completedTasks];
//   }

//   void addNewTask(
//       {required String crtTime,
//       required String dedTime,
//       required String crtDate,
//       required String dedDate,
//       required String tskName,
//       required bool isImprtnt}) {
//     _taskList.add(
//       Task(
//         createdTime: crtTime,
//         deadLineDate: dedDate,
//         deadLineTime: dedTime,
//         taskName: tskName,
//         createdDate: crtDate,
//         isImportant: isImprtnt,
//         taskId: DateTime.now(),
//         completedOn: DateTime.now(),
//       ),
//     );

//     notifyListeners();
//   }

//   void editTask({required DateTime taskId, required Task edititedTask}) {
//     Task toEditTask = _taskList.firstWhere((task) => task.taskId == taskId);
//     int editItemIndex = _taskList.indexOf(toEditTask);
//     _taskList[editItemIndex] = edititedTask;

//     notifyListeners();
//   }

//   void removeTask({required DateTime id, required String taskTitle}) {
//     _taskList
//         .removeWhere((item) => item.taskId == id && item.taskName == taskTitle);
//     notifyListeners();
//   }

//   void deleteAllCompletedTasks() {
//     _taskList.removeWhere((task) => task.isFinished == true);
//     notifyListeners();
//   }

//   void toggleTask(
//       {required DateTime id,
//       required String taskTitle,
//       required DateTime completeOnDate}) {
//     Task modifyTask = _taskList.firstWhere(
//       (item) => item.taskId == id && item.taskName == taskTitle,
//     );
//     modifyTask.isFinished = true;
//     modifyTask.completedOn = completeOnDate;
//     notifyListeners();
//   }

//   // void reOrderList(int oldIndx, int newIndx, List<Task> tskList) {
//   //   _taskList.insert(newIndx, _taskList[oldIndx]);
//   //   if (oldIndx < newIndx) {
//   //     _taskList.removeAt(oldIndx);
//   //   } else {
//   //     _taskList.removeAt(oldIndx + 1);
//   //   }
//   //   notifyListeners();
//   // }
//   void reOrderList(int oldIndx, int newIndx, List<Task> tskList) {
//     if (oldIndx < newIndx) {
//       newIndx -= 1;
//     }
//     final removedItem = getTaskList.removeAt(oldIndx);
//     getTaskList.insert(newIndx, removedItem);
//     notifyListeners();
//   }
// }
