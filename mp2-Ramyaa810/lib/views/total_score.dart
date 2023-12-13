part of '../main.dart';

class ToTalScore extends StatelessWidget {
  const ToTalScore({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScoreCard>(builder: (context, scoreCard, child) {
      return Text(
        'Current Total Score: ${scoreCard.calculateTotalScore()}',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      );
    });
  }
}
