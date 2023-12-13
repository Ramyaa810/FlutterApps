part of '../main.dart';

class Category extends StatelessWidget {
  const Category({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ScoreCard>(builder: (context, scoreCard, child) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (int i = 0; i < 13; i += 6)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (int j = i; j < i + 6 && j < 13; j++)
                  Row(
                    children: [
                      SizedBox(
                        width: 150,
                        height: 50,
                        child: Text(
                          '${scoreCard.categories[j]}:',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        height: 50,
                        child: Stack(
                          children: [
                            if (!scoreCard
                                .categoryPicked[scoreCard.getCategoryEnum(scoreCard.categories[j])]!)
                              TextButton(
                                onPressed: () {
                                  scoreCard
                                      .selectCategory(scoreCard.categories[j]);
                                  scoreCard.updateScore();
                                },
                                child: const Text(
                                  'Pick',
                                  style: TextStyle(fontSize: 16),
                                ),
                              )
                            else
                              Text(
                                scoreCard.categoryPicked[
                                        scoreCard.getCategoryEnum(scoreCard.categories[j]) ]!
                                    ? '${scoreCard.scores[scoreCard.getCategoryEnum(scoreCard.categories[j])]}'
                                    : '',
                                style: const TextStyle(fontSize: 16),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
              ],
            ),
        ],
      );
    });
  }
}
