part of '../main.dart';

class _YahtzeeGameState extends State<YahtzeeGame> {
  late Dice dice;
  late ScoreCard scoreCard;
  late CategoryScore calculateCategoryScore;

  @override
  void initState() {
    super.initState();
    dice = Dice();
    calculateCategoryScore = CategoryScore();
    scoreCard = ScoreCard(dice, calculateCategoryScore, context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: dice),
        ChangeNotifierProvider.value(value: scoreCard),
      ],
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Yahtzee',
              style: TextStyle(fontSize: 24),
            ),
          ),
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1280, maxHeight: 720),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Die(),
                    SizedBox(height: 20),
                    RollButton(),
                    SizedBox(height: 20),
                    Category(),
                    SizedBox(height: 20),
                    ToTalScore(),
                    GameOver(),                    
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
