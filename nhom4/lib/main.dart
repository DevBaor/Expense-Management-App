import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:nhom4/GUI/screens/introduction_screens/introduction_screen.dart';
import 'package:nhom4/core/services/firebase_authentication_services.dart';
import 'package:nhom4/GUI/screens/authentication_screens/logintest.dart';
import 'package:nhom4/GUI/screens/authentication_screens/register_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:nhom4/core/API/API_Helper.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: IntroductionScreen(),
      debugShowCheckedModeBanner: false,

    );
  }
}


