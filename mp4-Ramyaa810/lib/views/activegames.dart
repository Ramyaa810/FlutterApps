part of "homescreen.dart";

class ActiveGamesPage extends StatefulWidget {
  final String? username;
  final Future<List<dynamic>>? futurePosts;

  const ActiveGamesPage({required this.username, required this.futurePosts, super.key});

  @override
  State createState() => ActiveGames();
}

class ActiveGames extends State<ActiveGamesPage> {
  ApiService apiService = ApiService();

  List<Map<String, dynamic>> deletedGameList = [];
String username = '';
  Future<void> _deletePost(int id) async {
    Future<bool> response = apiService.deletePost(id);
    if (await response) {
      final deletedGame = {
        'id': id,
        'status': 2,
        'player1': widget.username,
        'player2': '',
      };

      _addToCompletedGamesList(deletedGame);
    } else {
      throw Exception('Failed to delete post');
    }
    _refreshPosts();
  }

  Future<void> _refreshPosts() async {
    await apiService.loadPosts();
    
    username = await SessionManager.getusername();
    setState(() {});
  }

  void _addToCompletedGamesList(Map<String, dynamic> game) {
    setState(() {
      deletedGameList.insert(0, game);
    });
  }
   Future<void> _getStoredUsername() async {
    username = await SessionManager.getusername();
  }

  @override
  void initState()  {
    super.initState();    
    _getStoredUsername();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: widget.futurePosts,
      initialData: null,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final post = snapshot.data![index];

              String gameInfo =
                  '#${post['id']} ${post['player1']} vs ${post['player2']}';

              String turnInfo = '';

              if (post['status'] == 0 && post['player2'] == null) {
                gameInfo = '#${post['id']} waiting for oponent';
                turnInfo = 'Matchmaking';
              } else if (post['status'] == 3) {
                int userturn = 0;
                if (username == post['player1']) {
                  userturn = 1;
                } else {
                  userturn = 2;
                }
                turnInfo =
                    post['turn'] == userturn ? 'my Turn' : 'Opponent Turn';
              }

              return Dismissible(
                key: Key(post['id'].toString()),
                onDismissed: (_) {
                  snapshot.data!.remove(post);
                  _deletePost(post['id']);
                },
                background: Container(
                  color: Colors.red,
                  child: const Icon(Icons.delete),
                ),
                child: ListTile(
                  title: Text(gameInfo),
                  trailing: Text(turnInfo),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GameViewPage(gameId: post['id'].toString()),
                      ),
                    );
                  },
                ),
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
