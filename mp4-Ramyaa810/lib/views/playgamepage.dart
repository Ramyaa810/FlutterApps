import 'package:battleships/utils/api_service.dart';
import 'package:battleships/utils/session_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GameViewPage extends StatefulWidget {
  final String gameId;

  const GameViewPage({Key? key, required this.gameId}) : super(key: key);

  @override
  State createState() => _GameViewPageState();
}

class _GameViewPageState extends State<GameViewPage> {
  String selectedPositions = "";
  List<String> ships = [];
  List<String> shots = [];
  List<String> sunk = [];
  List<String> wrecks = [];
  bool isGameOver = false;
  ApiService apiService = ApiService();
  @override
  void initState() {
    super.initState();

    _loadShipPositions();
  }

  Future<void> _loadShipPositions() async {
    final Map<String, dynamic> gameDetails =
        await apiService.loadShipPositions(widget.gameId);
    final List<String> ships = List<String>.from(gameDetails['ships']);
    final List<String> shots = List<String>.from(gameDetails['shots']);
    final List<String> sunk = List<String>.from(gameDetails['sunk']);
    final List<String> wrecks = List<String>.from(gameDetails['wrecks']);
    setState(() {
      this.ships = ships;
      this.shots = shots;
      this.sunk = sunk;
      this.wrecks = wrecks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game ID: ${widget.gameId}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                5,
                (index) => Text(
                  '${index + 1}',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
            ),
            Container(
              height: 400,
              width: 400,
              padding: const EdgeInsets.all(4.0),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                ),
                itemCount: 30,
                itemBuilder: (context, index) {
                  if (index % 6 == 0) {
                    return Center(
                      child: Text(
                        String.fromCharCode((index ~/ 6) + 65),
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  } else {
                    final row = (index - 1) ~/ 6;
                    final col = (index - 1) % 6;
                    final rowName =
                        '${String.fromCharCode((row) + 65)}${col + 1}';
                    bool isShipVisible = false;
                    bool isSunk = false;
                    bool isShots = false;
                    bool iswrecks = false;
                    String ship = ships.firstWhere(
                        (element) => element == rowName,
                        orElse: () => '');
                    if (ship.isNotEmpty) {
                      isShipVisible = true;
                    }
                    String sunk1 = sunk.firstWhere(
                        (element) => element == rowName,
                        orElse: () => '');
                    if (sunk1.isNotEmpty) {
                      isSunk = true;
                    }
                    String shots1 = shots.firstWhere(
                        (element) => element == rowName,
                        orElse: () => '');
                    if (shots1.isNotEmpty) {
                      isShots = true;
                    }
                    String wrecks1 = wrecks.firstWhere(
                        (element) => element == rowName,
                        orElse: () => '');
                    if (wrecks1.isNotEmpty) {
                      iswrecks = true;
                    }

                    return GestureDetector(
                      onTap: () {
                        debugPrint(rowName);
                        _togglePosition(rowName);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          color: selectedPositions.contains(rowName)
                              ? Colors.lightGreen
                              : Colors.white,
                        ),
                       child: SingleChildScrollView(
                           scrollDirection: Axis.horizontal,
                            child: Row(
                          children: [
                            Text(rowName),
                            isShipVisible
                                ? const Icon(
                                    Icons.directions_boat,
                                    color: Colors.green,
                                  )
                                : Container(),
                            isSunk
                                ? const Icon(
                                    Icons.waves,
                                    color: Colors.red,
                                  )
                                : Container(),
                            isShots
                                ? Text(String.fromCharCode(128163))
                                : Container(),
                            iswrecks
                                ? const Icon(
                                    Icons.shopping_basket,
                                    color: Color.fromARGB(255, 244, 143, 54),
                                  )
                                : Container(),
                          ],
                        )),
                      ),
                    );
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: isGameOver ? null : _playShot,
              child: const Text('Play Shot'),
            ),
          ],
        ),
      ),
    );
  }

  void _playShot() async {
    if (shots.contains(selectedPositions)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Position already selected')),
      );
    } else {
      String headerValue = await SessionManager.getSessionToken();
      String shotposition = jsonEncode({"shot": selectedPositions});
      final response = await http.put(
          Uri.parse('http://165.227.117.48/games/${widget.gameId}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $headerValue',
          },
          body: shotposition);

      if (response.statusCode == 200) {
        final jasonencode = jsonDecode(response.body);
        bool sunkship = jasonencode['sunk_ship'];
        bool won = jasonencode['won'];
        if (sunkship == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('ship sink')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Didnt hit the ship')),
          );
        }

        if (won == true) {
          _showGameOverDialog(true);
          setState(() {
            isGameOver = true;
          });
        }

        _loadShipPositions();
      } else if (response.body.contains("Game not active")) {
        _showGameOverDialog(false);
      } else if (response.body.contains("Not your turn") ||
          response.body.contains("Illegal shot")) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Not your turn')),
        );
      }
     else if (response.statusCode == 401) {
        throw Exception('Token Expired');
      } else {
        throw Exception('Failed to load ship positions');
      }
    }
  }

  void _togglePosition(String position) {
    setState(() {
      if (!selectedPositions.contains(position)) {
        selectedPositions = (position);
      } else {
        selectedPositions = "";
      }
    });
  }

  void _showGameOverDialog(bool gameWon) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: Text(gameWon ? 'You have won!' : 'You have lost!'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
