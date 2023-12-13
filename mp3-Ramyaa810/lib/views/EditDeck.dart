// ignore: file_names
import 'package:flutter/material.dart';
import 'package:mp3/models/deck_model.dart';
import 'package:mp3/utils/decks_helper.dart';

class EditDeckScreen extends StatelessWidget {
  final Deck deck;
  final Function() onDeckUpdated;
  final DecksHelper decksHelper = DecksHelper();
  EditDeckScreen({super.key, required this.deck, required this.onDeckUpdated});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController(text: deck.name);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Deck'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: controller,
              onChanged: (value) {
                deck.name = value;
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                decksHelper.updateDeck(deck);
                onDeckUpdated();
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