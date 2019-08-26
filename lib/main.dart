import 'package:flutter/material.dart';

import 'frontend/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) 
  {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CodeLib',
      theme: ThemeData(
        fontFamily: 'SF Pro Display',
        backgroundColor: Colors.blue[800],
        brightness: Brightness.dark,
        primaryColor: Colors.blueGrey[900], //Changing this will change the color of the TabBar
        accentColor: Colors.cyan[600], // displays when scroll limit
      ),
      home: Home(),
    );
  }
}

