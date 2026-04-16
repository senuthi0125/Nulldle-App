import 'package:flutter/material.dart';
import 'package:nulldle/view/home_screen.dart';
//import 'view/home_screen.dart';
//import 'package:async/async.dart';

void main() {
  runApp(WordleApp());
}

// entry point that configures app-wide settings and decides the initial screen.
class WordleApp extends StatelessWidget {
  const WordleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: HomeScreen(),
    );
  }
}
