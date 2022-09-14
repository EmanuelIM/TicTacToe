// ignore_for_file: sized_box_for_whitespace, non_constant_identifier_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:tic_tac_toe/shared/game.dart';

class GlobalVar {
  static String ai_mode = "";
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MainMenu(),
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('TicTacToe')),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text("Welcome to TicTacToe!",
                style: TextStyle(color: Colors.black, fontSize: 46)),
            const SizedBox(
              height: 5.0,
            ),
            const Text("Choose the mode to play",
                style: TextStyle(color: Colors.black, fontSize: 46)),
            const SizedBox(
              height: 30.0,
            ),
            ElevatedButton(
              child: const Text('Play with an AI'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DifficultyScreen()),
                );
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              child: const Text('Play with a Friend'),
              onPressed: () {
                GlobalVar.ai_mode = "";
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BoardScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DifficultyScreen extends StatelessWidget {
  const DifficultyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double Width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Difficulty Selection')),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Novice'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0)),
                minimumSize: Size(Width / 4, Width / 8),
              ),
              onPressed: () {
                GlobalVar.ai_mode = "E";
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BoardScreen()),
                );
              },
            ),
            const SizedBox(
              width: 50.0,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32.0)),
                minimumSize: Size(Width / 4, Width / 8),
              ),
              child: const Text('Advanced'),
              onPressed: () {
                GlobalVar.ai_mode = "H";
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BoardScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class BoardScreen extends StatefulWidget {
  const BoardScreen({Key? key}) : super(key: key);

  @override
  _BoardScreenState createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  String currentPlayer = "X";
  String winner = "";
  bool gameOver = false;
  Game game = Game(GlobalVar.ai_mode);

  @override
  void initState() {
    super.initState();
    currentPlayer = game.player_symbol;
  }

  @override
  Widget build(BuildContext context) {
    double Width = MediaQuery.of(context).size.width / 2;
    return Scaffold(
        backgroundColor: GlobalVar.ai_mode == "E"
            ? Colors.green[600]!
            : GlobalVar.ai_mode == "H"
                ? Colors.red[600]!
                : Colors.orange[600]!,
        appBar: AppBar(
          title: const Text('Game'),
          backgroundColor: GlobalVar.ai_mode == "E"
              ? Colors.green
              : GlobalVar.ai_mode == "H"
                  ? Colors.red
                  : Colors.orange,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                  gameOver
                      ? winner == "D"
                          ? "It's a draw! Play again?"
                          : "Player $winner wins! Play Again?"
                      : GlobalVar.ai_mode == "E" || GlobalVar.ai_mode == "H"
                          ? "Your assigned symbol is ${game.player_symbol}. Good luck!"
                          : "It's $currentPlayer's turn",
                  style: const TextStyle(color: Colors.black, fontSize: 46)),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Container(
              width: Width / 1.25,
              height: Width / 1.25,
              child: GridView.count(
                  crossAxisCount: Game.boardSize,
                  padding: const EdgeInsets.all(2.0),
                  mainAxisSpacing: 2.0,
                  crossAxisSpacing: 2.0,
                  children: List.generate(Game.boardSize * 3, (index) {
                    return InkWell(
                      onTap: gameOver
                          ? null
                          : () {
                              setState(() {
                                if (game.board![index] == Symbols.free) {
                                  game.board![index] = currentPlayer;
                                  game.last_move = index;
                                  winner = game.checkWinner();
                                  if (winner.isNotEmpty) {
                                    gameOver = true;
                                  } else {
                                    if (currentPlayer == "X") {
                                      currentPlayer = "O";
                                      if (game.ai_symbol == "O") {
                                        if (GlobalVar.ai_mode == "E") {
                                          game.placePieceEasy();
                                          currentPlayer = "X";
                                          winner = game.checkWinner();
                                          if (winner.isNotEmpty) {
                                            gameOver = true;
                                          }
                                        } else if (GlobalVar.ai_mode == "H") {
                                          game.placePieceHardO();
                                          currentPlayer = "X";
                                          winner = game.checkWinner();
                                          if (winner.isNotEmpty) {
                                            gameOver = true;
                                          }
                                        }
                                      }
                                    } else {
                                      currentPlayer = "X";
                                      if (game.ai_symbol == "X") {
                                        if (GlobalVar.ai_mode == "E") {
                                          game.placePieceEasy();
                                          currentPlayer = "O";
                                          winner = game.checkWinner();
                                          if (winner.isNotEmpty) {
                                            gameOver = true;
                                          }
                                        } else if (GlobalVar.ai_mode == "H") {
                                          game.placePieceHardX();
                                          currentPlayer = "O";
                                          winner = game.checkWinner();
                                          if (winner.isNotEmpty) {
                                            gameOver = true;
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              });
                            },
                      child: Container(
                          width: Game.blockSize,
                          height: Game.blockSize,
                          decoration: BoxDecoration(
                            color: GlobalVar.ai_mode == "E"
                                ? Colors.green[800]!
                                : GlobalVar.ai_mode == "H"
                                    ? Colors.red[800]!
                                    : Colors.orange[800]!,
                          ),
                          child: Center(
                              child: Text(game.board![index],
                                  style: TextStyle(
                                      color: game.board![index] == "X"
                                          ? Colors.black
                                          : Colors.white,
                                      fontSize: 46)))),
                    );
                  })),
            ),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  game = Game(GlobalVar.ai_mode);
                  currentPlayer = game.player_symbol;
                  gameOver = false;
                });
              },
              icon: const Icon(Icons.replay),
              label: const Text("New game?"),
              style: ElevatedButton.styleFrom(
                primary: GlobalVar.ai_mode == "E"
                    ? Colors.green
                    : GlobalVar.ai_mode == "H"
                        ? Colors.red
                        : Colors.orange,
              ),
            )
          ],
        ));
  }
}
