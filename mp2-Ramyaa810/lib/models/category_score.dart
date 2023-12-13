part of "scorecard.dart";

class CategoryScore {
  
  int calculateOnes(List<int?> diceValues) {
    return diceValues.where((value) => value == 1).length * 1;
  }

  int calculateTwos(List<int?> diceValues) {
    return diceValues.where((value) => value == 2).length * 2;
  }

  int calculateThrees(List<int?> diceValues) {
    return diceValues.where((value) => value == 3).length * 3;
  }

  int calculateFours(List<int?> diceValues) {
    return diceValues.where((value) => value == 4).length * 4;
  }

  int calculateFives(List<int?> diceValues) {
    return diceValues.where((value) => value == 5).length * 5;
  }

  int calculateSixes(List<int?> diceValues) {
    return diceValues.where((value) => value == 6).length * 6;
  }

  int? calculateThreeOfAKind(List<int?> diceValues) {
    Map<int, int> countMap = {};
    for (int? value in diceValues) {
      countMap[value!] = countMap.containsKey(value) ? countMap[value]! + 1 : 1;
    }

    for (int? value in countMap.keys) {
      if (countMap[value]! >= 3) {
        return diceValues.reduce((sum, value) => sum! + value!);
      }
    }
    return 0;
  }

  int? calculateFourOfAKind(List<int?> diceValues) {
    Map<int, int> countMap = {};
    for (int? value in diceValues) {
      countMap[value!] = countMap.containsKey(value) ? countMap[value]! + 1 : 1;
    }
    for (int? value in countMap.keys) {
      if (countMap[value]! >= 4) {
        return diceValues.reduce((sum, value) => sum! + value!);
      }
    }
    return 0;
  }

  int calculateFullHouse(List<int?> diceValues) {
    Map<int, int> countMap = {};
    for (int? value in diceValues) {
      countMap[value!] = countMap.containsKey(value) ? countMap[value]! + 1 : 1;
    }
    bool hasThreeOfAKind = false;
    bool hasTwoOfAKind = false;

    for (int? value in countMap.keys) {
      if (countMap[value] == 3) {
        hasThreeOfAKind = true;
      } else if (countMap[value] == 2) {
        hasTwoOfAKind = true;
      }
    }
    return hasThreeOfAKind && hasTwoOfAKind ? 25 : 0;
  }

  int calculateSmallStraight(List<int?> diceValues) {
    Set<int?> uniqueValues = diceValues.toSet();
    return (uniqueValues.containsAll([1, 2, 3, 4]) ||
            uniqueValues.containsAll([2, 3, 4, 5]) ||
            uniqueValues.containsAll([3, 4, 5, 6]))
        ? 30
        : 0;
  }

  int calculateLargeStraight(List<int?> diceValues) {
    Set<int?> uniqueValues = diceValues.toSet();
    return ((uniqueValues.containsAll([1, 2, 3, 4, 5]) ||
            uniqueValues.containsAll([2, 3, 4, 5, 6])))
        ? 40
        : 0;
  }

  int calculateYahtzee(List<int?> diceValues) {
    Set<int?> uniqueValues = diceValues.toSet();
    return uniqueValues.length == 1 ? 50 : 0;
  }

  int? calculateChance(List<int?> diceValues) {
    return diceValues.reduce((sum, value) => sum! + value!);
  }
}
