import 'package:flutter/material.dart';
import '../view/game_screen.dart';
/// A reusable custom text widget for the Nulldle app.
///
/// This widget ensures consistent styling across the app by applying
/// Courier font family, Bold pink text, Centered alignment,
/// A configurable font size (default: 24.0).
///
/// This will give the app a constant feel.

class NulldleText extends StatelessWidget {
  final String text;
  final double size;

  const NulldleText(this.text, {super.key, this.size = 24.0});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: 'Courier',
        color: Colors.pink,
        fontWeight: FontWeight.bold,
        fontSize: size,
      ),
    );
  }
}

// The landing screen showing the title, game blurb, and a button to start the game.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Center(
            child: Text(
              'Nulldle',
              style: TextStyle(
                fontFamily: 'Courier',
                color: Colors.pink,
                fontWeight: FontWeight.bold,
                fontSize: 48.0,
              ),
            ),
          ),
          Center(
            child: Image.asset(
              'assets/title.png',
              width: 200,
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: NulldleText(
                'Guess the hidden five-letter word in just six tries! After each guess, tiles will light up, green means the letter is in the right spot, yellow means the letter is in the word but in the wrong spot, and grey means the letter is not in the word at all.',
                size: 14.0,
              ),
            ),
          ),
          Center(
            child: ElevatedButton(
              child: Text(
                'Play Game',
                style: TextStyle(
                  fontFamily: 'Courier',
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => GameScreen()),
                );
              },
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}

