import 'package:mp3/models/deck_model.dart';
import 'package:mp3/utils/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class DeckRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  DeckRepository();

  Future<void> clearTables() async {
    Database database = await _databaseHelper.database;
    await database.delete('decks');
    await database.delete('flashcards');
  }

  Future<int?> insertDeck(Deck deck) async {
    Database database = await _databaseHelper.database;
    return await database.insert('decks', deck.toMap());
  }

  Future<List<Deck>> getAllDecks() async {
    Database database = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await database.query('decks');

    return List.generate(maps.length, (i) {
      return Deck(
        id: maps[i]['id'],
        name: maps[i]['name'],
      );
    });
  }

  Future<void> deleteDeck(int deckId) async {
    Database database = await _databaseHelper.database;
    await database.delete(
      'decks',
      where: 'id = ?',
      whereArgs: [deckId],
    );
    await database.delete(
      'flashcards',
      where: 'deckId = ?',
      whereArgs: [deckId],
    );
  }

  Future<void> updateDeck(Deck deck) async {
    Database database = await _databaseHelper.database;
    await database.update(
      'decks',
      deck.toMap(),
      where: 'id = ?',
      whereArgs: [deck.id],
    );
  }

  Future<int> getFlashcardCount(int deckId) async {
    Database database = await _databaseHelper.database;
    List<Map<String, dynamic>> flashcards = await database.query(
      'flashcards',
      where: 'deckId = ?',
      whereArgs: [deckId],
    );
    return flashcards.length;
  }
}
