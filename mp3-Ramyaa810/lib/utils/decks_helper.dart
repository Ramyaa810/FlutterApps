import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:mp3/datatransfer/deck_repository.dart';
import 'package:mp3/datatransfer/flashcard_repository.dart';
import 'package:mp3/models/deck_model.dart';
import 'package:mp3/models/flashcard_model.dart';

class DecksHelper {
  DecksHelper();
  final DeckRepository deckRepository = DeckRepository();
  final FlashcardRepository flashcardRepository = FlashcardRepository();

  Future<List<Deck>> loadDecks() async {
    final String jsonString =
        await rootBundle.loadString('assets/flashcards.json');
    final List<dynamic> jsonData = json.decode(jsonString);

   // deckRepository.clearTables();
    List<Deck> decks = [];
    for (dynamic deckData in jsonData) {
      Deck deck = Deck(
        name: deckData['title'],
      );

      int? deckId = await deckRepository.insertDeck(deck);
      deck = deck.copyWith(id: deckId);
      decks.add(deck);
    }

    for (int i = 0; i < decks.length; i++) {
      List<dynamic> flashcardsData = jsonData[i]['flashcards'];

      for (dynamic flashcardData in flashcardsData) {
        Flashcard flashcard = Flashcard(
          deckId: decks[i].id, 
          question: flashcardData['question'],
          answer: flashcardData['answer'],
        );

        int flashcardId = await flashcardRepository.insertFlashcard(flashcard);
        flashcard = flashcard.copyWith(id: flashcardId);
      }
    }
    return await deckRepository.getAllDecks();
  }

  Future<void> deleteDeck(int deckId) async {
    await deckRepository.deleteDeck(deckId);
  }

  Future<void> updateDeck(Deck deck) async {
    await deckRepository.updateDeck(deck);
  }

  Future<int?> insertDeck(Deck deck) async {
    return await deckRepository.insertDeck(deck);
  }

  Future<int> getFlashcardCount(int deckId) async {
    return await deckRepository.getFlashcardCount(deckId);
  }

  Future<List<Deck>> getAllDecks() async {
    return await deckRepository.getAllDecks();
  }
}
