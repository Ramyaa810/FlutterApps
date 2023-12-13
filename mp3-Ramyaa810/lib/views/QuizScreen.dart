import 'package:flutter/material.dart';
import 'package:mp3/models/flashcard_model.dart';

class QuizScreen extends StatefulWidget {
  final List<Flashcard> flashcards;
  final String deckname;

  const QuizScreen(
      {super.key, required this.flashcards, required this.deckname});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  bool _showingAnswer = false;
  int _totalCardsViewed = 1;
  int _totalAnswersViewed = 0;
  bool _isAnswerPeeked = false;
  @override
  void initState() {
    super.initState();
    widget.flashcards.shuffle();
  }

  void _showAnswer() {
    setState(() {
      if (!_isAnswerPeeked) {
        _totalAnswersViewed++;
        _isAnswerPeeked = true;
      }
      _showingAnswer = !_showingAnswer;
    });
  }

  void _nextQuestion() {
    setState(() {
      if (_currentIndex < widget.flashcards.length - 1) {
        _currentIndex++;
        _showingAnswer = false;
        _totalCardsViewed++;
        _isAnswerPeeked = false;
      }
    });
  }

  void _previousQuestion() {
    setState(() {
      if (_currentIndex > 0) {
        _currentIndex--;
        _showingAnswer = false;
        _totalCardsViewed++;
        _isAnswerPeeked = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.deckname} Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 5.0,
              color: _showingAnswer
                  ? const Color.fromARGB(255, 181, 232, 183)
                  : const Color.fromARGB(255, 162, 207, 244),
              child: SizedBox(
                width: 300.0,
                height: 200.0,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _showingAnswer
                          ? widget.flashcards[_currentIndex].answer
                          : widget.flashcards[_currentIndex].question,
                      style:
                          const TextStyle(fontSize: 18.0, color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: _previousQuestion,
                  icon: const Icon(Icons.navigate_before),
                ),
                IconButton(
                  onPressed: _showAnswer,
                  icon: const Icon(Icons.receipt),
                ),
                IconButton(
                  onPressed: _nextQuestion,
                  icon: const Icon(Icons.navigate_next),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Text(
              'Seen $_totalCardsViewed of ${widget.flashcards.length} cards',
              style: const TextStyle(fontSize: 16.0),
            ),
            Text(
              'Peeked at $_totalAnswersViewed of $_totalCardsViewed cards',
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
