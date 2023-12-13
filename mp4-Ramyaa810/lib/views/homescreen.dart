import 'package:battleships/utils/api_service.dart';
import 'package:battleships/utils/session_manager.dart';
import 'package:battleships/views/completedgames.dart';
import 'package:battleships/views/placeship.dart';
import 'package:battleships/views/playgamepage.dart';
import 'package:battleships/views/sidemenu.dart';
import 'package:flutter/material.dart';
part "show_a_i_dialog.dart";
part "startgamewith_a_i.dart";
part "shipplacement.dart";
part "activegames.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<dynamic>>? futurePosts;
  List<List<bool>> grid =
      List.generate(5, (index) => List<bool>.filled(5, false));
  List<Map<String, dynamic>> completedGamesList = [];
  ApiService apiService = ApiService();
  String? username = '';
  Future<List<dynamic>>? completedGames;
  bool showCompletedGames = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    futurePosts = apiService.loadPosts();
    _getStoredUsername();
  }

  Future<void> _getStoredUsername() async {
    username = await SessionManager.getusername();
  }

  void _toggleGamesList() {
    setState(() {
      showCompletedGames = !showCompletedGames;
      if (showCompletedGames) {
      } else {
        _refreshPosts();
      }
    });
  }

  Future<void> _refreshPosts() async {    
    username = await SessionManager.getusername();
    await apiService.loadPosts();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Battleship'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshPosts(),
          ),
        ],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: showCompletedGames
          ? const CompletedGamesPage()
          : ActiveGamesPage(username:  username, futurePosts: futurePosts),
      drawer: SideMenuScreen(
        completedGamesList: completedGamesList,
        toggleGamesList: _toggleGamesList,
        showCompletedGames: showCompletedGames,
        scaffoldKey: _scaffoldKey,
      ),
    );
  }
}
