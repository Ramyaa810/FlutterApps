import 'dart:math';
import 'package:flutter/material.dart';

class Dice extends ChangeNotifier {
  final Random random = Random();
  List<int?> diceValues = [null, null, null, null, null];
  List<bool> diceHeld = [false, false, false, false, false];
  bool isRolling = false;
  int currentRoll = 1;

  void roll() {
    if (currentRoll <= 3 && !isRolling) {
      isRolling = true;
      currentRoll++;

      for (int i = 0; i < diceValues.length; i++) {
        if (!diceHeld[i]) {
          diceValues[i] = random.nextInt(6) + 1;
        }
      }
      isRolling = false;
      notifyListeners();
    }
  }

  void toggleHold(int index) {
    if (!isRolling) {
      diceHeld[index] = !diceHeld[index];
      notifyListeners();
    }
  }

  void clearDice() {
    diceValues = [null, null, null, null, null];
    diceHeld = [false, false, false, false, false];
    isRolling = false;
    currentRoll = 1;
    notifyListeners();
  }
}
