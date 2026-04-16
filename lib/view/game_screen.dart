import 'package:flutter/material.dart';
import '../viewmodel/game_viewmodel.dart'; // Import the ViewModel

/// The main play screen of the app.
///
/// This is the View, responsible only for presenting the UI
/// and handling user input by calling methods on the ViewModel.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final TextEditingController _controller = TextEditingController();
  final GameViewModel _viewModel = GameViewModel();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialGame();
  }

  Future<void> _loadInitialGame() async {
    await _viewModel.loadGame();
    setState(() {
      _isLoading = false;
    });
  }

  //async update
  Future<void> _submitGuess() async {
    final guess = _controller.text;
    _controller.clear();

    final result = await _viewModel.submitGuess(guess); // await the async call

    setState(() {}); // Refresh UI

    if (result == "win") {
      _showSnackBar("You win!");
      _showWinDialog();
    } else if (result == "lose") {
      _showSnackBar("Out of guesses! Word was ${_viewModel.targetWord}");
      _showLoseDialog();
    } else if (result != null) {
      _showSnackBar(result);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // Displays a win dialog
  void _showWinDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                ":D",
                style: TextStyle(
                  fontSize: 64,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "You guessed it!\nThe word was: ${_viewModel.targetWord.toUpperCase()}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 20,
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // close dialog
                _handleReset(); // Reset the game via ViewModel
              },
              child: Text(
                "Close",
                style: TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 64,
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Displays a lose dialog
  void _showLoseDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // must press Close
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                ":(",
                style: TextStyle(
                  fontFamily: 'Courier',
                  fontSize: 64,
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "The word was: ${_viewModel.targetWord.toUpperCase()}",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // close dialog
                _handleReset(); // Now reset the game via ViewModel
              },
              child: Text(
                "Close",
                style: TextStyle(
                  fontFamily: 'Courier',
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleReset() {
    setState(() {
      _viewModel.resetGame(); // Delegate reset to ViewModel
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    Widget buildKeyboard() {
      // Reconstitute keyboard rows from the original code
      const keyboardRows = ["QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM"];

      return Column(
        children: keyboardRows.map((row) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: row.split('').map((letter) {
              return Container(
                margin: EdgeInsets.all(4.0),
                width: 30,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _viewModel.keyboardColors[letter], // Use ViewModel state
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.black26),
                ),
                child: Text(
                  letter,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              );
            }).toList(),
          );
        }).toList(),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (rowIndex) {
                  String? guess = rowIndex < _viewModel.guesses.length ? _viewModel.guesses[rowIndex] : null; // Use ViewModel state
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (colIndex) {
                      String letter = '';
                      Color bgColor = Colors.grey.shade300;

                      if (guess != null && colIndex < guess.length) {
                        letter = guess[colIndex].toUpperCase();
                        bgColor = _viewModel.getTileColor(guess, colIndex); // Use ViewModel logic
                      }

                      return Container(
                        margin: EdgeInsets.all(4.0),
                        width: 48,
                        height: 48,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.black26),
                        ),
                        child: Text(
                          letter,
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      );
                    }),
                  );
                }),
              ),
            ),

            //Statistics tracker
            Text(
              "Wins: ${_viewModel.wins}   Losses: ${_viewModel.losses}   Incorrect: ${_viewModel.incorrectGuesses}",
              style: TextStyle(
                fontFamily: 'Courier',
                color: Colors.pink,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 12),

            // The input field and buttons interact with the ViewModel
            TextField(
              controller: _controller,
              maxLines: 1,
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.none,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter your guess",
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _submitGuess, // Call handler which uses ViewModel
                  child: Text(
                    "Submit",
                    style: TextStyle(
                      fontFamily: 'Courier',
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                SizedBox(width: 12),
                ElevatedButton(
                  onPressed: _handleReset, // Call handler which uses ViewModel
                  child: Text(
                    "New Game",
                    style: TextStyle(
                      fontFamily: 'Courier',
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            buildKeyboard(),
          ],
        ),
      ),
    );
  }
}