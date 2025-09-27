import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:habit_tracker_app/habit_tracker_screen.dart';
import 'package:habit_tracker_app/login_screen.dart';
import 'package:habit_tracker_app/notifications_screen.dart';
import 'package:habit_tracker_app/personal_info_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyAJCWIsfR71inIQO2bPdAo-TywOaoR0-zE",
      authDomain: "habit-tracker-8ae47.firebaseapp.com",
      projectId: "habit-tracker-8ae47",
      storageBucket: "habit-tracker-8ae47.firebasestorage.app",
      messagingSenderId: "251810538816",
      appId: "1:251810538816:web:532d3b1d9e3821854946a5"
    ), 
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habit Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:  LoginScreen(),
    );
  }
}
