// ignore: file_names
import 'package:flutter/material.dart';
import 'package:mp3/datatransfer/flashcard_repository.dart';
import 'package:mp3/models/flashcard_model.dart';

class CreateFlashcardScreen extends StatelessWidget {
  final FlashcardRepository flashcardRepository = FlashcardRepository();
  final int deckId;
  final Function() onFlashcardCreated;

  CreateFlashcardScreen(
      {super.key, required this.deckId, required this.onFlashcardCreated});

  @override
  Widget build(BuildContext context) {
    TextEditingController questionController = TextEditingController();
    TextEditingController answerController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Flashcard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: questionController,
              decoration: const InputDecoration(labelText: 'Question'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: answerController,
              decoration: const InputDecoration(labelText: 'Answer'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                Flashcard newFlashcard = Flashcard(
                  question: questionController.text,
                  answer: answerController.text,
                  deckId: deckId,
                );

                await flashcardRepository.insertFlashcard(newFlashcard);

                onFlashcardCreated();

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
