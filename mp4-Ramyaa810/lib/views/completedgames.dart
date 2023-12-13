import 'package:battleships/utils/api_service.dart';
import 'package:battleships/views/completeddetails.dart';
import 'package:flutter/material.dart';

class CompletedGamesPage extends StatefulWidget { 

  const CompletedGamesPage({super.key});
  @override
  State createState() => _CompletedGamesPageState();
}

class _CompletedGamesPageState extends State<CompletedGamesPage> {
  Future<List<dynamic>>? completedGames;
  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    setState(() {
    });
  }

  Future<void> _viewCompletedGameDetails(gameId) async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => GamecompletedPage(gameId: gameId
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
        future: apiService.loadCompletedGames(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final game = snapshot.data![index];

              
                final gameId = game['id'];
                final status = game['status'];
                final player1 = game['player1'];
                final player2 = game['player2'];

                final isGameWon = status == 1;
                final gameResult = isGameWon ? 'won' : 'lost';

                return ListTile(
                  title: Text('#$gameId $player1 vs $player2 '),
                  trailing: Text(gameResult),
                  onTap: () {
                    _viewCompletedGameDetails(gameId);
                  },
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('${snapshot.error}'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
  }
}
