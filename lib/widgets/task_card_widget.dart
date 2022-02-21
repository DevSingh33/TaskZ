import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_kudhse/constants.dart';
import 'package:todo_app_kudhse/models/task.dart';
import 'package:todo_app_kudhse/providers/task_provider.dart';
import 'package:todo_app_kudhse/widgets/simple_dialog_widget.dart';
import 'package:percent_indicator/percent_indicator.dart';

class TaskCard extends StatelessWidget {
  TaskCard({
    required this.cardName,
    required this.cardSideColor,
    required this.isImp,
    required this.cardMaxColor,
    required this.placeholderWidget,
    Key? key,
  }) : super(key: key);
  final Color cardSideColor;
  final Color cardMaxColor;
  final String cardName;
  final bool isImp;
  final Widget placeholderWidget;

  List<Task> finalTskList = [];
  String? selectedDate;
  double percentValue = 0.05;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TaskProvider>(context, listen: true);
    // provider.sortTaskByDate(provider.objectOfSelectedDate);
    finalTskList = isImp ? provider.getPriortyList : provider.getOtherTaskList;
    percentValue = provider.currentFinishedTaskCount(finalTskList) /
        provider.currentTotalTaskCount(finalTskList);
    print('whole task card called');

    return Card(
      color: cardMaxColor,
      margin: kCardMargin,
      elevation: 4,
      shadowColor: const Color(0xffd1faff),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
          // gradient: LinearGradient(
          //   colors: [cardSideColor.withOpacity(0.95), cardMaxColor],
          //   begin: Alignment.centerLeft,
          //   end: Alignment.centerRight,
          //   stops: const [0.11, 0],
          // ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: LinearPercentIndicator(
                    animation: true,
                    animateFromLastPercent: true,
                    backgroundColor: cardSideColor.withOpacity(0.4),
                    progressColor: cardSideColor,
                    barRadius: const Radius.circular(30),
                    // percent: 0.8,
                    percent: percentValue.isNaN ? 0.00 : percentValue,
                    lineHeight: 22,
                    center: Text(
                      cardName,
                      style: kProgressStyle,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              //    flex: 6,
              child: finalTskList.isEmpty
                  ? Center(child: placeholderWidget)
                  : Consumer<TaskProvider>(
                      builder: (context, TaskProvider tskProvider, child) {
                        finalTskList = isImp
                            ? tskProvider.getPriortyList
                            : tskProvider.getOtherTaskList;
                        return ListView.separated(
                          separatorBuilder: (context, index) {
                            return Divider(
                              height: 1,
                              thickness: 1.5,
                              indent: 14,
                              endIndent: 14,
                              // indent: 30,
                              // endIndent: 8.4,

                              color: cardSideColor.withOpacity(0.1),
                            );
                          },
                          itemCount: finalTskList.length,
                          itemBuilder: (_, index) => Dismissible(
                            key: ValueKey(
                              finalTskList[index],
                            ),
                            onDismissed: (direction) {
                              // tskProvider.removeTask(indx: index);
                              tskProvider.removeTask(
                                id: finalTskList[index].taskId,
                                taskTitle: finalTskList[index].taskName,
                              );
                            },
                            background: Container(
                              padding:
                                  const EdgeInsets.only(right: 20, left: 20),
                              decoration: BoxDecoration(
                                color: Colors.redAccent[100],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Icon(Icons.delete, size: 22),
                                  Icon(Icons.delete, size: 22),
                                ],
                              ),
                            ),
                            child: ListTile(
                              key: ValueKey(
                                finalTskList[index],
                              ),
                              // /    dense: true,
                              minVerticalPadding: 0,
                              contentPadding: const EdgeInsets.only(
                                top: 0,
                                right: 0,
                                left: 6,
                                bottom: 0,
                              ),
                              iconColor: Theme.of(context).primaryColorDark,
                              horizontalTitleGap: 15,
                              leading: InkWell(
                                splashColor: Colors.pink,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => Dia(
                                      ctx: _,
                                      passedTask: finalTskList[index],
                                      index: index,
                                    ),
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.all(4),
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    // color: Color(0xffffc971),
                                    color: Theme.of(context).primaryColorLight,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: cardMaxColor,
                                      width: 4,
                                    ),
                                    // borderRadius: BorderRadius.circular(90),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      finalTskList[index].deadLineTime,
                                      style: kDisplayTimeStyle,
                                      softWrap: true,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                              textColor: cardSideColor,
                              // textColor: Theme.of(context).primaryColorDark,
                              title: InkWell(
                                splashColor: cardMaxColor,
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) => Dia(
                                      ctx: _,
                                      passedTask: finalTskList[index],
                                      index: index,
                                    ),
                                  );
                                },
                                child: Text(
                                  finalTskList[index].taskName,
                                  style: kTaskNameStyle.copyWith(
                                    decorationColor: cardSideColor,
                                    decorationThickness: 2,
                                    decoration: finalTskList[index].isFinished
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                              ),
                              // subtitle: Text(
                              //   finalTskList[index].createdDate.toString(),
                              //   style: kDeadLineDateStyle,
                              // ),
                              trailing: Checkbox(
                                value: finalTskList[index].isFinished,
                                //   checkColor: Colors.white,
                                // activeColor: Theme.of(context).primaryColor,
                                activeColor: cardSideColor,

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                side: BorderSide(
                                  color: cardSideColor,
                                  // color: Theme.of(context).primaryColor,
                                ),
                                onChanged: (newValue) {
                                  tskProvider.toggleTask(
                                    id: finalTskList[index].taskId,
                                    taskTitle: finalTskList[index].taskName,
                                    completeOnDate: DateTime.now(),
                                    newVal: newValue ?? false,
                                  );
                                  //  finalTskList[index].isFinished = newValue ?? false;
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
