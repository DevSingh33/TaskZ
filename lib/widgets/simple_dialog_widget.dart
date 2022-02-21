import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_kudhse/constants.dart';
import 'package:todo_app_kudhse/models/task.dart';
import 'package:todo_app_kudhse/providers/task_provider.dart';

class Dia extends StatefulWidget {
  const Dia({Key? key, required this.ctx, this.passedTask, required this.index})
      : super(key: key);
  final BuildContext ctx;
  final Task? passedTask;
  final int? index;
  @override
  _DiaState createState() => _DiaState();
}

class _DiaState extends State<Dia> {
  DateTime disDate = DateTime.now();
  String newTask = '';
  bool isDatePicked = false;
  bool isTimePicked = false;
  bool isImportant = false;
  bool validate = false;
  bool remindMe = true;
  double sliderVal = 10;

  String? initTaskName;
  DateTime? iniTtaskId;
  DateTime? iniTcreatedDate;
  String? iniTdeadLineDate;
  String? iniTcreatedTime;
  String? iniTdeadLineTime;
  DateTime? iniTcompletedOn;
  bool? iniTisImp;
  bool? iniTisFinished;
  @override
  void initState() {
    initTaskName = widget.passedTask?.taskName;
    iniTtaskId = widget.passedTask?.taskId;
    iniTcreatedDate = widget.passedTask?.createdDate;
    iniTdeadLineDate = widget.passedTask?.deadLineDate;
    iniTcreatedTime = widget.passedTask?.createdTime;
    iniTdeadLineTime = widget.passedTask?.deadLineTime;
    iniTcompletedOn = widget.passedTask?.completedOn;
    iniTisImp = widget.passedTask?.isImportant;
    iniTisFinished = widget.passedTask?.isFinished;
    // print(widget.passedTask?.taskName);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TaskProvider tskProvider =
        Provider.of<TaskProvider>(context, listen: false);
    print('whole dialog called');
    return SimpleDialog(
      backgroundColor: Theme.of(context).canvasColor,
      contentPadding: const EdgeInsets.all(10),
      titlePadding: const EdgeInsets.all(10),
      title: Text(
        'Add Task',
        style: kAddTaskDialogDateTimeDisplayStyle.copyWith(
          fontSize: 22,
          color: Theme.of(context).primaryColorDark,
        ),
        textAlign: TextAlign.center,
      ),
      children: [
        TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          initialValue: initTaskName,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Add a new task',
            fillColor: Colors.yellowAccent[100],
            filled: true,
            errorText: validate ? 'Field can\'t be empty' : null,
          ),
          style: const TextStyle(
            fontFamily: 'Handlee',
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
          onChanged: (value) {
            String trimmedValue = value.trim();
            initTaskName = trimmedValue;
          },
        ),
        CheckboxListTile(
          contentPadding: const EdgeInsets.all(1),
          value: iniTisImp ?? isImportant,
          onChanged: (newVal) {
            if (newVal != null) {
              setState(() {
                iniTisImp = newVal;
                isImportant = newVal;
              });
            }
          },
          title: Text(
            'Top Priority',
            style: kAddTaskDialogDateTimeDisplayStyle.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () async {
                final pickedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  String di;
                  setState(() {
                    isTimePicked = true;
                    {
                      if (pickedTime.hour > 12) {
                        di = 'PM';
                      } else {
                        di = 'AM';
                      }
                    }
                    iniTdeadLineTime =
                        '${pickedTime.hourOfPeriod}:${pickedTime.minute} $di';
                  });
                }
              },
              child: Text(
                iniTdeadLineTime == null
                    ? DateFormat.jm().format(DateTime.now())
                    : iniTdeadLineTime!,
                textAlign: TextAlign.left,
                style: kAddTaskDialogDateTimeDisplayStyle,
              ),
            ),
            TextButton(
              onPressed: () async {
                final pickedDate = await showDatePicker(
                  context: context,
                  initialDate: tskProvider.objectOfSelectedDate,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2099),
                );

                if (pickedDate != null) {
                  setState(() {
                    iniTdeadLineDate =
                        DateFormat('dd-MM-yyyy').format(pickedDate);
                    isDatePicked = true;
                  });
                }
              },
              child: Text(
                iniTdeadLineDate ?? tskProvider.stringOfSelectedDate,
                // iniTdeadLineDate ??
                //     DateFormat('dd-MM-yyyy').format(DateTime.now()),
                style: kAddTaskDialogDateTimeDisplayStyle,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (initTaskName != null) {
                    newTask = initTaskName!;
                  }
                  newTask.isEmpty ? validate = true : validate = false;

                  if (validate == false & newTask.isNotEmpty) {
                    print('widget.index= ${widget.index}');

                    if (widget.passedTask == null) {
                      final DateTime currentDate = DateTime.now();
                      final String currentTime =
                          DateFormat.jm().format(DateTime.now());
                      tskProvider.addNewTask(
                        crtTime: currentTime,
                        dedTime: isTimePicked ? iniTdeadLineTime! : currentTime,
                        crtDate: currentDate,
                        dedDate: isDatePicked
                            ? iniTdeadLineDate!
                            : tskProvider.stringOfSelectedDate,
                        tskName: newTask,
                        isImprtnt: isImportant,
                      );
                    } else {
                      print('widget.index= ${widget.index}');
                      tskProvider.editTask(
                        taskId: widget.passedTask!.taskId,
                        edititedTask: Task(
                          createdTime: widget.passedTask!.createdTime,
                          deadLineDate: iniTdeadLineDate!,
                          deadLineTime: iniTdeadLineTime!,
                          taskName: newTask,
                          createdDate: widget.passedTask!.createdDate,
                          taskId: widget.passedTask!.taskId,
                          completedOn: widget.passedTask!.completedOn,
                          isImportant: iniTisImp!,
                        ),
                      );
                    }

                    Navigator.of(context).pop();
                  } else {
                    return;
                  }
                });
              },
              child: const Icon(Icons.save),
            ),
          ],
        ),
      ],
    );
  }
}
