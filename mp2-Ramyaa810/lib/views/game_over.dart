import 'package:flutter/material.dart';
import 'package:mp2/models/scorecard.dart';
import 'package:provider/provider.dart';

class GameOver extends StatelessWidget {
  const GameOver({Key? key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScoreCard>(builder: (context, scoreCard, child) {
      if (scoreCard.isGameOver()) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Game Over'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Total Score: ${scoreCard.calculateTotalScore()}'),
                    ElevatedButton(
                      onPressed: () {
                        scoreCard.clear();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Play Again'),
                    ),
                  ],
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              );
            },
          );
        });
      }

      return const SizedBox.shrink();
    });
  }
}
