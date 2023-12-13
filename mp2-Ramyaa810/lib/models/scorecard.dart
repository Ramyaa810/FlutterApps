import 'package:flutter/material.dart';
import 'dice.dart';
part 'category_score.dart';

enum ScoreCategory {
  ones("Ones"),
  twos("Twos"),
  threes("Threes"),
  fours("Fours"),
  fives("Fives"),
  sixes("Sixes"),
  threeOfAKind("Three of a Kind"),
  fourOfAKind("Four of a Kind"),
  fullHouse("Full House"),
  smallStraight("Small Straight"),
  largeStraight("Large Straight"),
  yahtzee("Yahtzee"),
  chance("Chance");

  const ScoreCategory(this.name);
  final String name;
}

class ScoreCard extends ChangeNotifier {
  late Dice diceModel;
  late CategoryScore calculateCategoryScore;
  BuildContext context;
  ScoreCard(this.diceModel, this.calculateCategoryScore, this.context);

  String selectedCategory = '';

  List<String> categories = [
    ScoreCategory.ones.name,
    ScoreCategory.twos.name,
    ScoreCategory.threes.name,
    ScoreCategory.fours.name,
    ScoreCategory.fives.name,
    ScoreCategory.sixes.name,
    ScoreCategory.threeOfAKind.name,
    ScoreCategory.fourOfAKind.name,
    ScoreCategory.fullHouse.name,
    ScoreCategory.smallStraight.name,
    ScoreCategory.largeStraight.name,
    ScoreCategory.yahtzee.name,
    ScoreCategory.chance.name,
  ];
  
  Map<ScoreCategory, int?> scores = {
    for (var category in ScoreCategory.values) category: 0
  };
  Map<ScoreCategory, bool> categoryPicked = {
    for (var category in ScoreCategory.values) category: false
  };

  void clear() {
    selectedCategory = '';
    scores = {for (var category in ScoreCategory.values) category: 0};
    categoryPicked = {
      for (var category in ScoreCategory.values) category: false
    };
    notifyListeners();
  }

  bool isGameOver() {
    return categoryPicked.values.every((picked) => picked);
  }

  int? calculateTotalScore() {
    return scores.values.reduce((value, element) => value! + element!);
  }

  void selectCategory(String category) {
    if (!diceModel.isRolling) {
      selectedCategory = category;
      diceModel.currentRoll = 1;
      categoryPicked[getCategoryEnum(category)] = true;
      notifyListeners();
    }
  }

  void updateScore() {
    if (selectedCategory.isNotEmpty &&
        scores[getCategoryEnum(selectedCategory)] == 0) {
      registerScore(selectedCategory);
      selectedCategory = '';
      diceModel.clearDice();
      notifyListeners();
    }
  }

  ScoreCategory getCategoryEnum(String categoryName) {
    return ScoreCategory.values.firstWhere(
      (e) => e.name == categoryName,
      orElse: () => throw Exception('Invalid category name: $categoryName'),
    );
  }

  void registerScore(String category) {
    int? score = 0;

    switch (getCategoryEnum(category)) {
      // ignore: constant_pattern_never_matches_value_type
      case ScoreCategory.ones:
        score = calculateCategoryScore.calculateOnes(diceModel.diceValues);
        break;
      // ignore: constant_pattern_never_matches_value_type
      case ScoreCategory.twos:
        score = calculateCategoryScore.calculateTwos(diceModel.diceValues);
        break;
      // ignore: constant_pattern_never_matches_value_type
      case ScoreCategory.threes:
        score = calculateCategoryScore.calculateThrees(diceModel.diceValues);
        break;
      // ignore: constant_pattern_never_matches_value_type
      case ScoreCategory.fours:
        score = calculateCategoryScore.calculateFours(diceModel.diceValues);
        break;
      // ignore: constant_pattern_never_matches_value_type
      case ScoreCategory.fives:
        score = calculateCategoryScore.calculateFives(diceModel.diceValues);
        break;
      // ignore: constant_pattern_never_matches_value_type
      case ScoreCategory.sixes:
        score = calculateCategoryScore.calculateSixes(diceModel.diceValues);
        break;
      // ignore: constant_pattern_never_matches_value_type
      case ScoreCategory.threeOfAKind:
        score =
            calculateCategoryScore.calculateThreeOfAKind(diceModel.diceValues);
        break;
      // ignore: constant_pattern_never_matches_value_type
      case ScoreCategory.fourOfAKind:
        score =
            calculateCategoryScore.calculateFourOfAKind(diceModel.diceValues);
        break;
      // ignore: constant_pattern_never_matches_value_type
      case ScoreCategory.fullHouse:
        score = calculateCategoryScore.calculateFullHouse(diceModel.diceValues);
        break;
      // ignore: constant_pattern_never_matches_value_type
      case ScoreCategory.smallStraight:
        score =
            calculateCategoryScore.calculateSmallStraight(diceModel.diceValues);
        break;
      // ignore: constant_pattern_never_matches_value_type
      case ScoreCategory.largeStraight:
        score =
            calculateCategoryScore.calculateLargeStraight(diceModel.diceValues);
        break;
      // ignore: constant_pattern_never_matches_value_type
      case ScoreCategory.yahtzee:
        score = calculateCategoryScore.calculateYahtzee(diceModel.diceValues);
        break;
      // ignore: constant_pattern_never_matches_value_type
      case ScoreCategory.chance:
        score = calculateCategoryScore.calculateChance(diceModel.diceValues);
        break;
    }
    if (score! > 0 && scores[getCategoryEnum(category)] == 0) {
      scores[getCategoryEnum(category)] = score;
      selectedCategory = '';
      notifyListeners();
    }
  }
}
