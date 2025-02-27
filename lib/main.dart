import 'package:flutter/material.dart';
import 'constants.dart';
import 'features/MainScreen/presentaion/views/MainScreen_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

