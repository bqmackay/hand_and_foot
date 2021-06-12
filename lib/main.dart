import 'package:flutter/material.dart';
import 'package:handandfoot/views/hand_widget.dart';

void main() {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hand And Foot",
      home: HandWidget(),
    );
  }
}
