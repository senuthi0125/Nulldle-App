import '../model/game_model.dart';
import 'package:flutter/material.dart';

/// Manages the state and interaction logic for the GameScreen.
/// This acts as the presentation layer between the GameScreen (View) and GameModel (Model).
class GameViewModel {
  final GameModel model = GameModel();
  
  // Public getters to expose essential Model data to the View
  List<String> get guesses => model.guesses;
  String get targetWord => model.targetWord;
  Map<String, Color> get keyboardColors => model.keyboardColors;
  int get maxGuesses => model.maxGuesses;

  //Stats to view
  int get wins => model.wins;
  int get losses => model.losses;
  int get incorrectGuesses => model.incorrectGuesses;

  // Handles initial loading of data
  Future<void> loadGame() async {
    await model.loadDictionaryAndNewGame();
  }

  // Handles player's guess submission
  Future<String?> submitGuess(String guess) async {
    return model.submitGuess(guess);
  }

  // Handles game reset
  void resetGame() {
    model.resetGame();
  }

  // Exposes tile color logic for the View to build the grid
  Color getTileColor(String guess, int index) {
    return model.tileColor(guess, index);
  }
}