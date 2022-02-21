import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_kudhse/screens/completed_task_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({
    Key? key,
  }) : super(key: key);

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int navItemIndex = 0;

  void changeScreen(int newIndex) {
    if (newIndex == 1) {
      Navigator.of(context).push(
        CupertinoPageRoute(builder: (context) => const CompletedTasksScreen()),
      );
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        color: Theme.of(context).primaryColor,
        elevation: 0,
        child: BottomNavigationBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          // selectedItemColor: Theme.of(context).colorScheme.onSurface,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          onTap: (index) => changeScreen(index),
          iconSize: 24,
          unselectedFontSize: 14,
          selectedFontSize: 16,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.task_alt_rounded),
              label: 'All Tasks',
              tooltip: 'View Tasks',
            ),
            BottomNavigationBarItem(
              tooltip: 'View All Completed Tasks',
              icon: Icon(Icons.done_all),
              label: 'CompletedTask',
            ),
            //   BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Delete'),
          ],
        ),
      ),
    );
  }
}
