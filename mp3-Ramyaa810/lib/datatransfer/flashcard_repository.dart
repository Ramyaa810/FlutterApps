import 'package:mp3/models/flashcard_model.dart';
import 'package:mp3/utils/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class FlashcardRepository {
  final DatabaseHelper _databaseHelper = DatabaseHelper.instance;

  FlashcardRepository();

  Future<List<Flashcard>> getAllFlashcards() async {
    Database database = await _databaseHelper.database;
    final List<Map<String, dynamic>> maps = await database.query('flashcards');

    return List.generate(maps.length, (index) {
      return Flashcard(
        id: maps[index]['id'],
        deckId: maps[index]['deckId'],
        question: maps[index]['question'],
        answer: maps[index]['answer'],
      );
    });
  }

  Future<int> insertFlashcard(Flashcard flashcard) async {
    Database database = await _databaseHelper.database;
    return await database.insert('flashcards', flashcard.toMap());
  }

  Future<List<Flashcard>> getFlashcardsByDeckId(int? deckId) async {
    Database database = await _databaseHelper.database;
    List<Map<String, dynamic>> maps = await database.query(
      'flashcards',
      where: 'deckId = ?',
      whereArgs: [deckId],
      orderBy: 'id DESC',
    );
    return List.generate(maps.length, (index) {
      return Flashcard.fromMap(maps[index]);
    });
  }

  Future<List<Flashcard>> getFlashcardsSortedAlphabetically(int deckId) async {
    Database database = await _databaseHelper.database;

    final List<Map<String, dynamic>> maps = await database.query(
      'flashcards',
      where: 'deckId = ?',
      whereArgs: [deckId],
      orderBy: 'question',
    );

    return List.generate(maps.length, (index) {
      return Flashcard(
        id: maps[index]['id'],
        deckId: maps[index]['deckId'],
        question: maps[index]['question'],
        answer: maps[index]['answer'],
      );
    });
  }

  Future<void> deleteFlashcard(int flashcardId) async {
    Database database = await _databaseHelper.database;
    await database.delete(
      'flashcards',
      where: 'id = ?',
      whereArgs: [flashcardId],
    );
  }

  Future<void> updateFlashcard(Flashcard flashcard) async {
    Database database = await _databaseHelper.database;
    await database.update(
      'flashcards',
      flashcard.toMap(),
      where: 'id = ?',
      whereArgs: [flashcard.id],
    );
  }
}
