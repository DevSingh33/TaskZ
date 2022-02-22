import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'package:todo_app_kudhse/models/task.dart';
import 'package:todo_app_kudhse/providers/task_provider.dart';
import 'package:todo_app_kudhse/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final Directory dir = await getApplicationDocumentsDirectory();
  final String path = dir.path;
  await Hive.initFlutter(path);
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );
  // await Hive.initFlutter();

  Hive.registerAdapter<Task>(TaskAdapter());
  await Hive.openBox<Task>(TaskProvider.boxName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //     overlays: [SystemUiOverlay.bottom]);
    print('whole app rebuild');
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        builder: (context, widget) {
          return ResponsiveWrapper.builder(
            BouncingScrollWrapper.builder(context, widget!),
            // maxWidth: 1200,
            // minWidth: 400,
            defaultScale: true,
            breakpoints: [
              const ResponsiveBreakpoint.resize(600, name: MOBILE),
              const ResponsiveBreakpoint.autoScale(700, name: TABLET),
              const ResponsiveBreakpoint.resize(800, name: DESKTOP),
              const ResponsiveBreakpoint.autoScale(1700, name: "4K"),
            ],
          );
        },

        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        // theme: ThemeData.dark(),
        theme: ThemeData(
          // canvasColor: Colors.pinkAccent[100],
          canvasColor: const Color(0xffd1faff),
          // primarySwatch: Colors.deepPurple,
          primaryColor: const Color(0xff0c89dd),
        ),
        home: AnimatedSplashScreen(
          splash: SizedBox(
            width: 300,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              //     crossAxisAlignment: CrossAxisAlignment.end,
              // mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.asset(
                    'assets/images/bg_removed.png',
                  ),
                ),
                const Spacer(),
                const Text(
                  'TaskZ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Kaushan Script',
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Color(0xffffd900),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: const Color(0xff49b6ff),
          // centered: true,
          nextScreen: const HomeScreen(),
          splashTransition: SplashTransition.slideTransition,

          splashIconSize: 160,
        ),
      ),
    );
  }
}
