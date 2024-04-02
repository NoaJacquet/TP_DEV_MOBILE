import 'package:flutter/material.dart';
import 'UI/mytheme.dart'; // Assuming that 'mytheme.dart' contains the MyTheme class
import 'UI/home.dart';

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "TD2",
      theme: MyTheme.dark(), // Use 'dark()' method from MyTheme class
      home: MyScaffold(), // You might need to pass any required parameters here
    ),
  );
}


