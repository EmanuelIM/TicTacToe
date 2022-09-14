// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables

import 'dart:math';

class Symbols {
  static const x = "X";
  static const o = "O";
  static const free = "";
}

class Game {
  static const boardSize = 3;
  static const blockSize = 10.0;
  var ai_mode;
  String player_symbol = "";
  String ai_symbol = "";
  var last_move;
  var scores_x = {"X": 1, "O": -1, "D": 0};
  var scores_o = {"X": -1, "O": 1, "D": 0};

  Game(String ai) {
    board = Game.initGameBoard();
    player_symbol = "X";
    if (ai.isNotEmpty) {
      Random random = Random();
      bool rand = random.nextBool();
      if (rand == true) {
        player_symbol = "X";
        ai_symbol = "O";
      } else {
        player_symbol = "O";
        ai_symbol = "X";
        if (ai == "E") {
          placePieceEasy();
        } else {
          placePieceHardX();
        }
      }
      ai_mode = ai;
    }
  }

  List<String>? board;

  static List<String>? initGameBoard() =>
      List.generate(boardSize * 3, (index) => Symbols.free);

  String checkWinner() {
    for (var i = 0; i <= 2; i++) {
      var pos = i * 3;
      if (board![pos] == board![pos + 1] &&
          board![pos + 1] == board![pos + 2]) {
        return board![pos];
      }
      if (board![i] == board![i + 3] && board![i + 3] == board![i + 6]) {
        return board![i];
      }
    }
    if (board![0] == board![4] && board![4] == board![8]) return board![0];
    if (board![2] == board![4] && board![4] == board![6]) return board![2];
    for (var i = 0; i <= 8; ++i) {
      if (board![i] == Symbols.free) return "";
    }
    return "D";
  }

  void placePieceEasy() {
    while (true) {
      Random random = Random();
      var rnd = random.nextInt(9);
      if (board![rnd] == Symbols.free) {
        board![rnd] = ai_symbol;
        break;
      }
    }
  }

  int? minimaxX(var board, var depth, var isMaximizing) {
    var result = checkWinner();
    if (result != "") {
      var score = scores_x[result];
      return score;
    }
    if (isMaximizing) {
      var bestScore = -1000000;
      for (var i = 0; i <= 8; ++i) {
        if (board![i] == Symbols.free) {
          board![i] = ai_symbol;
          var score = minimaxX(board, depth + 1, false);
          board![i] = "";
          if (score! > bestScore) {
            bestScore = score;
          }
        }
      }
      return bestScore;
    } else {
      var bestScore = 1000000;
      for (var i = 0; i <= 8; ++i) {
        if (board![i] == Symbols.free) {
          board![i] = player_symbol;
          var score = minimaxX(board, depth + 1, true);
          board![i] = "";
          if (score! < bestScore) {
            bestScore = score;
          }
        }
      }
      return bestScore;
    }
  }

  void placePieceHardX() {
    //90% chance to make the correct move
    Random random = Random();
    var rnd = random.nextDouble();
    if (rnd >= 0.9) {
      placePieceEasy();
    } else {
      var bestScore;
      bestScore = -1000000;
      var bestMove;
      for (var i = 0; i <= 8; ++i) {
        if (board![i] == Symbols.free) {
          board![i] = ai_symbol;
          var score;
          score = minimaxX(board, 0, false);
          board![i] = "";
          var rnd1 = random.nextDouble();
          if (score! > bestScore! || (score! == bestScore! && rnd1 >= 0.5)) {
            bestScore = score;
            bestMove = i;
          }
        }
      }
      board![bestMove] = ai_symbol;
    }
  }

  int? minimaxO(var board, var depth, var isMaximizing) {
    var result = checkWinner();
    if (result != "") {
      var score = scores_o[result];
      return score;
    }
    if (isMaximizing) {
      var bestScore = -1000000;
      for (var i = 0; i <= 8; ++i) {
        if (board![i] == Symbols.free) {
          board![i] = ai_symbol;
          var score = minimaxO(board, depth + 1, false);
          board![i] = "";
          if (score! > bestScore) {
            bestScore = score;
          }
        }
      }
      return bestScore;
    } else {
      var bestScore = 1000000;
      for (var i = 0; i <= 8; ++i) {
        if (board![i] == Symbols.free) {
          board![i] = player_symbol;
          var score = minimaxO(board, depth + 1, true);
          board![i] = "";
          if (score! < bestScore) {
            bestScore = score;
          }
        }
      }
      return bestScore;
    }
  }

  void placePieceHardO() {
    //90% chance to make the correct move
    Random random = Random();
    var rnd = random.nextDouble();
    if (rnd >= 0.9) {
      placePieceEasy();
    } else {
      var bestScore;
      bestScore = -1000000;
      var bestMove;
      for (var i = 0; i <= 8; ++i) {
        if (board![i] == Symbols.free) {
          board![i] = ai_symbol;
          var score;
          score = minimaxO(board, 0, false);
          board![i] = "";
          var rnd1 = random.nextDouble();
          if (score! > bestScore! || (score! == bestScore! && rnd1 >= 0.5)) {
            bestScore = score;
            bestMove = i;
          }
        }
      }
      board![bestMove] = ai_symbol;
    }
  }
}
