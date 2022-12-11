import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo/Screens/notes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            appBarTheme: const AppBarTheme(
                systemOverlayStyle: SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.transparent,
          statusBarColor: Colors.transparent,
        ))),
        debugShowCheckedModeBanner: false,

        // Using animated splashScreen class from 3rd party library to create a good greeting screen
        home: AnimatedSplashScreen(
            duration: 3000,
            splash: Column(
              children: [
                Expanded(
                  child: Image.asset(
                    'images/tasks.png',
                    width: 250,
                    height: 250,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                const Text(
                  'Welcome to Notes',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
            // navigate to next screen the class here itself uses a navigator route so we don't have to write it
            nextScreen: const Notes(),
            splashTransition: SplashTransition.scaleTransition,
            backgroundColor: Colors.black));
  }
}
