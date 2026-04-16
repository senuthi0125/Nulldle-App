import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Represents the state and core logic of the Wordle-style game.
class GameModel {
  late List<String> _dictionary;
  String _targetWord = '';
  final int maxGuesses = 6;

  final List<String> _guesses = [];
  Map<String, Color> _keyboardColors = {};

  //Statistics for tracking
  int wins = 0;
  int losses = 0;
  int incorrectGuesses = 0;

  List<String> get guesses => _guesses;
  String get targetWord => _targetWord;
  Map<String, Color> get keyboardColors => _keyboardColors;

  GameModel() {
    _initializeKeyboardColors();
  }

  void _initializeKeyboardColors() {
    _keyboardColors = {
      for (var c in 'QWERTYUIOPASDFGHJKLZXCVBNM'.split('')) c: Colors.grey.shade300,
    };
  }

  // Load dictionary and select the word for play
  Future<void> loadDictionaryAndNewGame() async {
    final dict = await rootBundle.loadString('assets/english_dict.txt');
    _dictionary = dict.split('\n').map((w) => w.trim().toLowerCase()).where((w) => w.length == 5).toList();
    await _loadStats(); //Loading the stored stats
    _targetWord = _dictionary[Random().nextInt(_dictionary.length)];
    resetGame();
  }

  //Loading statisctics from shared prefernces
  Future<void> _loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    wins = prefs.getInt('wins') ?? 0;
    losses = prefs.getInt('losses') ?? 0;
    incorrectGuesses = prefs.getInt('incorrectGuesses') ?? 0;
  }

  //Saving the statistics in shared preferences
  Future<void> _saveStats() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('wins', wins);
    await prefs.setInt('losses', losses);
    await prefs.setInt('incorrectGuesses', incorrectGuesses);
  }

  // Figures out what color each tile should be
  Color tileColor(String guess, int index) {
    if (index >= _targetWord.length || index >= guess.length) {
      return Colors.grey; // Should not happen with 5-letter words, but defensive
    }
    
    // Safety: ensure guess and target are compared correctly (lowercase)
    final targetLetter = _targetWord[index];
    final guessLetter = guess[index];

    if (targetLetter == guessLetter) {
      return Colors.green;
    } else if (_targetWord.contains(guessLetter)) {
      return Colors.yellow;
    } else {
      return Colors.grey;
    }
  }

  // Updates the on-screen keyboard colors after each guess
  void updateKeyboard(String guess) {
    for (int i = 0; i < guess.length; i++) {
      String letter = guess[i].toUpperCase();
      Color newColor = tileColor(guess, i);

      // Priority order: Green > Yellow > Grey
      if (_keyboardColors[letter] == Colors.green) continue;
      if (_keyboardColors[letter] == Colors.yellow && newColor == Colors.grey) continue;

      _keyboardColors[letter] = newColor;
    }
  }

  //Helper functions for the statistics and to save data
  Future<void> recordWin() async {
    wins++;
    await _saveStats();
  }

  Future<void> recordLoss() async {
    losses++;
    await _saveStats();
  }

  Future<void> recordIncorrectGuess() async {
    incorrectGuesses++;
    await _saveStats();
  }

  // Submits a guess and returns a result message or null if the guess is successful/valid.
  // Returns: null for valid/successful guess, or an error message string.
  String? submitGuess(String guess) {
    final lowerCaseGuess = guess.toLowerCase();

    if (_guesses.contains(lowerCaseGuess)) {
      return "You already guessed that word!";
    }

    if (!_dictionary.contains(lowerCaseGuess)) {
      return "Not a valid word!";
    }

    _guesses.add(lowerCaseGuess);
    updateKeyboard(lowerCaseGuess);

    //Count of incorrect guesses
    if (lowerCaseGuess != _targetWord) {
      recordIncorrectGuess();
    }

    if (lowerCaseGuess == _targetWord) {
      recordWin();
      return "win";
    } else if (_guesses.length >= maxGuesses) {
      recordLoss();
      return "lose";
    }

    return null;
  }

  void resetGame() {
    _guesses.clear();
    incorrectGuesses = 0;
    _initializeKeyboardColors();
    // Select a new word (assuming _dictionary is already loaded)
    if (_dictionary.isNotEmpty) {
      _targetWord = _dictionary[Random().nextInt(_dictionary.length)];
    }
  }
}