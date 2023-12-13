import 'package:battleships/utils/api_service.dart';
import 'package:flutter/material.dart';

class GamecompletedPage extends StatefulWidget {
  final int gameId;

  const GamecompletedPage({Key? key, required this.gameId}) : super(key: key);

  @override
  State createState() => _GamecompletedPageState();
}

class _GamecompletedPageState extends State<GamecompletedPage> {
  String selectedPositions = "";
  List<String> ships = [];
  List<String> shots = [];
  List<String> sunk = [];
  List<String> wrecks = [];
  ApiService apiService = ApiService();
  @override
  void initState() {
    super.initState();
    _loadShipPositions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('completed Game ID : ${widget.gameId}'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                5,
                (index) => Padding(
                    padding: const EdgeInsets.only(left: 50, top: 50),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(fontSize: 20),
                      ),
                    )),
              ),
            ),
          ),
             Expanded(
            child: Padding(
               padding: const EdgeInsets.only(right: 10),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  childAspectRatio: 0.8,
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
                    bool isShip = false;
                    bool isSunk = false;
                    bool isShots = false;
                    bool iswrecks = false;
                    String ship = ships.firstWhere(
                        (element) => element == rowName,
                        orElse: () => '');
                    if (ship.isNotEmpty) {
                      isShip = true;
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
                            isShip
                                ? const Icon(
                                    Icons.directions_boat_filled,
                                    color: Colors.green,
                                  )
                                : Container(),
                            isSunk
                                ? const Icon(
                                    Icons.waves_sharp,
                                    color: Colors.red,
                                  )
                                : Container(),
                            isShots
                                ? const Icon(
                                    Icons.ballot_rounded,
                                    color: Color.fromARGB(255, 244, 54, 184),
                                  )
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
             )
          ],
        ),
      ),
    );
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

  Future<void> _loadShipPositions() async {
    final Map<String, dynamic> gameDetails =
        await apiService.loadShipPositions(widget.gameId.toString());
    
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
}
