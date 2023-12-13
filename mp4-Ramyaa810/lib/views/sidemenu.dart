import 'package:battleships/utils/api_service.dart';
import 'package:battleships/utils/session_manager.dart';
import 'package:battleships/views/homescreen.dart';
import 'package:battleships/views/loginpage.dart';
import 'package:flutter/material.dart';

class SideMenuScreen extends StatefulWidget {
  final List<Map<String, dynamic>> completedGamesList;
  final VoidCallback toggleGamesList;
  final bool showCompletedGames;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideMenuScreen(
      {Key? key,
      required this.completedGamesList,
      required this.toggleGamesList,
      required this.showCompletedGames,
      required this.scaffoldKey,})
      : super(key: key);

  @override
  State createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenuScreen> {
  bool showCompletedGames = false;
  ApiService apiService = ApiService();
  void _toggleGamesList() {
    setState(() {
      widget.toggleGamesList();
      showCompletedGames = !widget.showCompletedGames;
      widget.scaffoldKey.currentState?.openEndDrawer();
    });
  
  }

  Future<void> _doLogout() async {
    await SessionManager.clearSession();

    if (!mounted) return;

    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => const LoginScreen(),
    ));
  }

   @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 20),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(              
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Battleships',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                FutureBuilder<String>(
                  future: SessionManager.getusername(),
                  builder: (context, snapshot) {
                    final username = snapshot.data;

                    return Text(
                      'Logged in as $username',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('New Game'),
            
            onTap: () {
              navigateToShipPlacement(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.airplay),
            title: const Text('New game (AI)'),
            onTap: () {
              showAIDialog(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: Text(widget.showCompletedGames
                ? 'Show active games'
                : 'Show completed games'),
            onTap: _toggleGamesList,          
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log out'),
            onTap: () {
              _doLogout();
            },
          ),
        ],
        ),
      ),
    );
  }
}
