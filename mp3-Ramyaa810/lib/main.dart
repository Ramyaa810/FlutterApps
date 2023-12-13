import 'package:flutter/material.dart';
import 'package:mp3/utils/decks_helper.dart';
import 'package:mp3/views/decklist.dart';
import 'models/deck_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcards App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Deck> _loadDecksFuture;
  late DecksHelper deckhelper = DecksHelper();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    _loadDecksFuture = await deckhelper.loadDecks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Welcome to Flashcards App'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await _initializeData();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        DeckListScreen(decks: _loadDecksFuture),
                  ),
                );
              },
              child: const Text('Load Decks'),
            ),
          ],
        ),
      ),
    );
  }
}
