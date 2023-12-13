part of '../main.dart'; 
class Die extends StatelessWidget {
  const Die({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Dice>(builder: (context, dice, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          for (int i = 0; i < 5; i++)
                            GestureDetector(
                              onTap: () => dice.toggleHold(i),
                              child: DieHold(
                                value: dice.diceValues[i],
                                isHeld: dice.diceHeld[i],
                              ),
                            ),
                        ],
                      );
                    });
  }
}