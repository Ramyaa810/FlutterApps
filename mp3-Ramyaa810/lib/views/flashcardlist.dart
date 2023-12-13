import 'package:flutter/material.dart';
import 'package:mp3/datatransfer/flashcard_repository.dart';
import 'package:mp3/models/flashcard_model.dart';
import 'package:mp3/views/CreateCard.dart';
import 'package:mp3/views/EditCard.dart';
import 'package:mp3/views/QuizScreen.dart';
import '/models/deck_model.dart';

class FlashcardScreen extends StatefulWidget {
  final Deck deck;
  final void Function(bool) onFlashcardListChanged;
  const FlashcardScreen({super.key, required this.deck, required this.onFlashcardListChanged});

  @override
  // ignore: library_private_types_in_public_api
  _FlashcardScreenState createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends State<FlashcardScreen> {
  final FlashcardRepository flashcardRepository = FlashcardRepository();
  bool _isSortedAlphabetically = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deck.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              setState(() {
                _isSortedAlphabetically = !_isSortedAlphabetically;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () async {
              List<Flashcard> flashcards = await flashcardRepository
                  .getFlashcardsByDeckId(widget.deck.id!);              
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuizScreen(
                      flashcards: flashcards, deckname: widget.deck.name),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Flashcard>>(
        future: _isSortedAlphabetically
            ? flashcardRepository
                .getFlashcardsSortedAlphabetically(widget.deck.id!)
            : flashcardRepository.getFlashcardsByDeckId(widget.deck.id!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Flashcard> flashcards = snapshot.data ?? [];

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 5.0,
                  color: const Color.fromARGB(255, 198, 227, 250),
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(snapshot.data![index].question),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditFlashcardScreen(
                                      flashcard: flashcards[index],
                                      onFlashcardUpdated: () {
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () async {
                                await flashcardRepository
                                    .deleteFlashcard(snapshot.data![index].id!);
                                widget.onFlashcardListChanged(true);
                                setState(() {});
                              },
                              icon: const Icon(Icons.delete),
                              color: Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateFlashcardScreen(
                deckId: widget.deck.id!,
                onFlashcardCreated: () {
                  widget.onFlashcardListChanged(true);
                  setState(() {});
                },
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}






