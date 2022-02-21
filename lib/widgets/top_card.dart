import 'dart:ui';
import 'package:date_picker_timeline/extra/style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_kudhse/constants.dart';
import 'package:todo_app_kudhse/providers/task_provider.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';

//import 'package:calendar_timeline/calendar_timeline.dart';

class TopCardWithDate extends StatefulWidget {
  const TopCardWithDate({
    required this.topCardColor,
    Key? key,
  }) : super(key: key);
  final Color topCardColor;
  @override
  State<TopCardWithDate> createState() => _TopCardWithDateState();
}

class _TopCardWithDateState extends State<TopCardWithDate> {
  double percentValue = 0.05;
  final DatePickerController _datePickerController = DatePickerController();
  DateTime? selectedDate = DateTime.now();
  bool isDateTimePickerSelected = false;
  bool _isElevated = true;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TaskProvider>(context, listen: true);
    percentValue = provider.getTotalDoneTaskCount / provider.getTotalTaskCount;
    print('whole top card called');
    return Card(
      margin: kCardMargin,

      elevation: 4,
      shadowColor: widget.topCardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      color: widget.topCardColor,
      // color: Colors.transparent,
      // child: OldWidget(selectedDate: selectedDate),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 2,
          bottom: 2,
          left: 10,
          right: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const SizedBox(
            //   width: 8,
            // ),
            Expanded(
              flex: 1,
              child: AnimatedContainer(
                height: MediaQuery.of(context).size.height * 0.11,
                duration: const Duration(milliseconds: 500),
                padding: const EdgeInsets.all(6),
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    //  color: Color(0xffffd900),
                    color: isDateTimePickerSelected
                        ? Theme.of(context).primaryColor
                        : const Color(0xffffd900),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: _isElevated
                        ? const [
                            BoxShadow(
                              color: Colors.white60,
                              offset: Offset(-4, -4),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                            BoxShadow(
                              color: Colors.amber,
                              offset: Offset(5, 5),
                              blurRadius: 4,
                              spreadRadius: 1,
                            ),
                          ]
                        : null),
                child: InkWell(
                  splashColor: Colors.pinkAccent,
                  onTap: () async {
                    selectedDate = await showDatePicker(
                        context: context,
                        initialDate: provider.objectOfSelectedDate,
                        firstDate: DateTime(2022),
                        lastDate: DateTime(2099));
                    if (selectedDate != null) {
                      setState(() {
                        isDateTimePickerSelected = true;
                        _isElevated = false;
                      });
                    } else {
                      // showDialog(
                      //     context: context,
                      //     builder: (ctx) => AlertDialog(
                      //           title: Text('Select From Picker'),
                      //         ));

                      return;
                    }
                    provider.sortTaskByDate(selectedDate ?? DateTime.now());
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        provider.objectOfSelectedDate.year.toString(),
                        style: kDateTimeStyleForTopButton.copyWith(
                          color: isDateTimePickerSelected
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                      Icon(
                        Icons.date_range_rounded,
                        size: 30,
                        color: isDateTimePickerSelected
                            ? Colors.white
                            : const Color(0xff49b6ff),
                      ),
                      Text(
                        DateFormat('dd-MMM')
                            .format(provider.objectOfSelectedDate),
                        style: kDateTimeStyleForTopButton.copyWith(
                          color: isDateTimePickerSelected
                              ? Colors.white
                              : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                //  padding: const EdgeInsets.all(1),
                //height: MediaQuery.of(context).size.height * 0.2,
                decoration: BoxDecoration(
                    //    border: Border.all(width: 1, color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(10)),
                child: DatePicker(
                  DateTime.now().subtract(const Duration(days: 2)),
                  height: MediaQuery.of(context).size.height * 0.11,
                  monthTextStyle: defaultMonthTextStyle.copyWith(
                    color: Colors.black87,
                    fontSize: 12,
                  ),
                  dateTextStyle: defaultDateTextStyle.copyWith(
                      color: const Color(0xff49b6ff),
                      fontSize: 20,
                      fontWeight: FontWeight.w900),
                  dayTextStyle: defaultDayTextStyle.copyWith(
                    color: Colors.black87,
                    fontSize: 12,
                  ),
                  selectionColor: isDateTimePickerSelected
                      ? widget.topCardColor
                      : Theme.of(context).primaryColor,
                  selectedTextColor:
                      isDateTimePickerSelected ? Colors.black : Colors.white,
                  initialSelectedDate: selectedDate,
                  controller: _datePickerController,
                  onDateChange: (selDate) {
                    if (selectedDate != null) {
                      setState(() {
                        isDateTimePickerSelected = false;
                        _isElevated = true;
                        selectedDate = selDate;
                      });

                      provider.sortTaskByDate(selectedDate!);
                    } else {
                      setState(() {
                        selectedDate = selDate;
                        provider.sortTaskByDate(selectedDate!);
                      });
                    }
                  },
                ),
              ),
            ),

            Expanded(
              flex: 1,
              child: Container(
                // height: MediaQuery.of(context).size.height * 0.2,
                padding: const EdgeInsets.only(top: 2, bottom: 2, left: 8),
                child: FittedBox(
                  child: CircularPercentIndicator(
                    radius: 36,
                    lineWidth: 8,
                    animation: true,
                    // animationDuration: 1000,
                    animateFromLastPercent: true,
                    percent: percentValue.isNaN ? 0.00 : percentValue,
                    circularStrokeCap: CircularStrokeCap.round,
                    backgroundColor: Theme.of(context).primaryColorLight,
                    progressColor: Theme.of(context).primaryColorDark,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FittedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              provider.getTotalDoneTaskCount.toString() +
                                  '/' +
                                  provider.getTotalTaskCount.toString(),
                              textAlign: TextAlign.center,
                              style: kTopTaskIndicatorStyle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // const SizedBox(
            //   width: 8,
            // ),
          ],
        ),
      ),
    );
  }
}
