import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_firbase/spashscreen.dart';






const SAVE_KEY_NAME = 'userLoggedIn';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {



 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme : ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Ubuntu',
        hintColor: Colors.white,
        elevatedButtonTheme: ElevatedButtonThemeData(style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,padding:const EdgeInsets.all(18.0))),
        colorScheme:const ColorScheme.dark(),
       
      ),
      home:const SplashScreen(),
    );
  }
  }





