// ignore: file_names
import 'package:flutter/material.dart';
import 'package:mp3/datatransfer/flashcard_repository.dart';
import 'package:mp3/models/flashcard_model.dart';

class EditFlashcardScreen extends StatelessWidget {
  final Flashcard flashcard;
  final Function() onFlashcardUpdated;
  final FlashcardRepository flashcardRepository = FlashcardRepository();

  EditFlashcardScreen(
      {super.key, required this.flashcard, required this.onFlashcardUpdated});

  @override
  Widget build(BuildContext context) {
    TextEditingController questionController =
        TextEditingController(text: flashcard.question);
    TextEditingController answerController =
        TextEditingController(text: flashcard.answer);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Flashcard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: questionController,
              onChanged: (value) {
                flashcard.question = value;
              },
            ),
            TextFormField(
              controller: answerController,
              onChanged: (value) {
                flashcard.answer = value;
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                await flashcardRepository.updateFlashcard(flashcard);
                onFlashcardUpdated();
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
