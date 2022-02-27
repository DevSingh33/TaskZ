import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:todo_app_kudhse/providers/task_provider.dart';
import 'package:todo_app_kudhse/widgets/bottom_navbar_widget.dart';
import 'package:todo_app_kudhse/widgets/fab_widget.dart';
import 'package:todo_app_kudhse/widgets/quote_widget.dart';
import 'package:todo_app_kudhse/widgets/task_card_widget.dart';
import 'package:todo_app_kudhse/widgets/top_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  String formattedTime = DateFormat.Hm().format(DateTime.now());
  TimeOfDay? disTime;
  var finalTime;
  DateTime? disDate;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<TaskProvider>(context, listen: false);
    provider.getAllTask();
    provider.sortTaskByDate(provider.objectOfSelectedDate);
    //  provider.deleteOldTasks();

    return Scaffold(
      // extendBody: true,
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const FABWidget(),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.18,
            width: double.infinity,
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0, 1),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 120,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Expanded(
                    flex: 2,
                    child: TopCardWithDate(
                      topCardColor: Color(0xffffd900),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: TaskCard(
                      cardName: 'Top Priority',
                      cardSideColor: const Color(0xffee4266),
                      cardMaxColor: Colors.lime[50]!,
                      isImp: true,
                      placeholderWidget: const QuoteWidget(
                        quote: '"You May Delay, But Time Will Not." ',
                        quoteBy: '-Benjamin Franklin',
                        fontsize: 14,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: TaskCard(
                      cardName: 'Other Tasks',
                      cardSideColor: const Color(0xff0b3866),
                      cardMaxColor: Colors.lime[50]!,
                      isImp: false,
                      placeholderWidget: const QuoteWidget(
                          quote: '"A Goal Without A Plan Is Just A Wish."',
                          quoteBy: '-Antoine de Saint-Exupéry',
                          fontsize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
