import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_kudhse/models/task.dart';
import 'package:todo_app_kudhse/providers/task_provider.dart';
import 'package:intl/intl.dart';

import '../constants.dart';

class CompletedTasksScreen extends StatelessWidget {
  const CompletedTasksScreen({Key? key}) : super(key: key);
  static const routeName = 'completed_task-screen';

  @override
  Widget build(BuildContext context) {
    final Color wholeColor = Colors.yellow[50]!;

    List<Task> completedTaskList = Provider.of<TaskProvider>(
      context,
    ).getCompletedTasksList;
    return Scaffold(
      backgroundColor: wholeColor,
      appBar: AppBar(
        title: const Text('All Completed Tasks'),
        //  leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
      ),
      body: Column(children: [
        Expanded(
          //height: 200,
          child: ListView.separated(
              separatorBuilder: (context, index) {
                return Divider(
                  height: 1,
                  endIndent: 10,
                  indent: 10,
                  thickness: 1,
                  color: Theme.of(context).primaryColor,
                );
              },
              itemCount: completedTaskList.length,
              itemBuilder: (_, index) {
                String taskCompletedOn = DateFormat('dd-MM-yyyy')
                    .format(completedTaskList[index].completedOn);
                return ListTile(
                  tileColor: wholeColor,
                  contentPadding:
                      const EdgeInsets.only(left: 10, bottom: 0, top: 0),
                  hoverColor: Colors.green,
                  dense: true,
                  title: Text(
                    completedTaskList[index].taskName,
                    style: kTaskNameStyle,
                  ),
                  subtitle: Text('Completed On -> $taskCompletedOn',
                      style: kCompleteTaskDateStyle),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.redAccent,
                    ),
                    onPressed: () {
                      Provider.of<TaskProvider>(context, listen: false)
                          .removeTask(
                              id: completedTaskList[index].taskId,
                              taskTitle: completedTaskList[index].taskName);
                    },
                  ),
                );
              }),
        ),
      ]),
      bottomNavigationBar: BottomAppBar(
        // notchMargin: 100,
        color: Colors.red,
        child: TextButton(
          onPressed: () {
            if (completedTaskList.isNotEmpty) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  backgroundColor: Theme.of(context).canvasColor,
                  content: const Text('Delete All Completed Task ?'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('NO')),
                    TextButton(
                      onPressed: () {
                        Provider.of<TaskProvider>(context, listen: false)
                            .deleteAllCompletedTasks();
                        Navigator.of(context).pop();
                      },
                      child: const Text('YES'),
                    ),
                  ],
                ),
              );
            } else {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  const SnackBar(
                    content: Text(
                      'No New Task Completed !',
                    ),
                    duration: Duration(seconds: 2),
                  ),
                );
            }
          },
          child: const Text(
            'Clear All',
            style: kDelteAllTextStyle,
          ),
        ),
      ),
      // //  endDrawer: Drawer(),
    );
  }
}
