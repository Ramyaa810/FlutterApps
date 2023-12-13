import 'package:flutter/material.dart';
import 'package:mp3/utils/decks_helper.dart';
import 'package:mp3/views/EditDeck.dart';
import 'package:mp3/views/flashcardlist.dart';
import '/models/deck_model.dart';

class DeckListScreen extends StatefulWidget {
  final List<Deck> decks;

  const DeckListScreen({super.key, required this.decks});

  @override
  // ignore: library_private_types_in_public_api
  _DeckListScreenState createState() => _DeckListScreenState();
}

class _DeckListScreenState extends State<DeckListScreen> {
  final DecksHelper decksHelper = DecksHelper();
  final TextEditingController _deckNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcard Decks'),
      ),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: widget.decks.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlashcardScreen(
                    deck: widget.decks[index],
                    onFlashcardListChanged: (bool refreshDeckList) {
                      if (refreshDeckList) {
                        _loadDeckList();
                      }
                    },
                  ),
                ),
              );
            },
            child: Card(
              elevation: 5.0,
              color: const Color.fromARGB(255, 223, 189, 87),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FutureBuilder<int>(
                      future: _getFlashcardCount(index),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text('Loading...');
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          int flashcardCount = snapshot.data ?? 0;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Text(
                                    widget.decks[index].name,
                                    style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Text(
                                '($flashcardCount cards)',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditDeckScreen(
                                  deck: widget.decks[index],
                                  onDeckUpdated: () {
                                    setState(() {});
                                  },
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            int? id = widget.decks[index].id;
                            decksHelper.deleteDeck(id!);
                            setState(() {
                              widget.decks.removeAt(index);
                            });
                          },
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddDeckDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _loadDeckList() async {
    List<Deck> updatedDecks = await decksHelper.getAllDecks();
    setState(() {
      widget.decks.clear();
      widget.decks.addAll(updatedDecks);
    });
  }

  void _showAddDeckDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Deck'),
          content: TextField(
            controller: _deckNameController,
            decoration: const InputDecoration(labelText: 'Deck Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addDeck();
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addDeck() async {
    Deck newDeck = Deck(name: _deckNameController.text);
    int? insertedId = await decksHelper.insertDeck(newDeck);

    setState(() {
      newDeck = newDeck.copyWith(id: insertedId);
      widget.decks.add(newDeck);
    });
  }

  Future<int> _getFlashcardCount(int index) async {
    return await decksHelper.getFlashcardCount(widget.decks[index].id!);
  }
}


