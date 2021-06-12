import 'package:flutter/material.dart';

class GameSetupWidget extends StatefulWidget {
  GameSetupWidget({Key key}) : super(key: key);

  @override
  _GameSetupWidgetState createState() => _GameSetupWidgetState();
}

class _GameSetupWidgetState extends State<GameSetupWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Align(
          alignment: Alignment.center,
          child: Container(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _startGame,
                  child: Text("Start Game"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startGame() {
    print("Do something");
  }
}
