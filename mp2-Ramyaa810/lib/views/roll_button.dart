part of '../main.dart';

class RollButton extends StatelessWidget {
  const RollButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Dice>(builder: (context, dice, child) {
      return ElevatedButton(
        onPressed: dice.currentRoll == 4 ? null : dice.roll,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            dice.currentRoll == 4 ? Colors.grey : Colors.blue,
          ),
        ),
        child: Text(
          dice.currentRoll == 4
              ? 'Out of Rolls'
              : dice.isRolling
                  ? 'Rolling... (${dice.currentRoll})'
                  : 'Roll (${dice.currentRoll})',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      );
    });
  }
}
