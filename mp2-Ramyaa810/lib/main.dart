import 'package:flutter/material.dart';
import 'package:mp2/models/dice.dart';
import 'package:mp2/models/scorecard.dart';
import 'package:mp2/views/Die_hold.dart';
import 'package:mp2/views/game_over.dart';
import 'package:provider/provider.dart';
part 'views/roll_button.dart';
part 'views/category.dart';
part 'views/total_score.dart';
part 'views/die.dart';
part 'views/yahtzee.dart';

void main() => runApp(const YahtzeeApp());

class YahtzeeApp extends StatelessWidget {
  const YahtzeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Yahtzee',
      home: YahtzeeGame(),
    );
  }
}

class YahtzeeGame extends StatefulWidget {
  const YahtzeeGame({super.key});

  @override
  _YahtzeeGameState createState() => _YahtzeeGameState();
}


