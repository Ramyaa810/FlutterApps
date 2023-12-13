import 'package:battleships/utils/api_service.dart';
import 'package:battleships/utils/session_manager.dart';
import 'package:battleships/views/homescreen.dart';
import 'package:battleships/views/loginpage.dart';
import 'package:flutter/material.dart';

class ShipPlacementPage extends StatefulWidget {
  final String? aiType;
  const ShipPlacementPage({this.aiType, super.key});

  @override
  State createState() => _ShipPlacementPageState();
}

class _ShipPlacementPageState extends State<ShipPlacementPage> {
  List<List<bool>> grid =
      List.generate(5, (index) => List<bool>.filled(5, false));

  List<String> selectedPositions = [];
  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _retrieveSelectedPositions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Place Ships'),
      ),
      body: Column(
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
                    return GestureDetector(
                      onTap: () {
                        _togglePosition(
                            '${String.fromCharCode(row + 65)}${col + 1}');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          color: selectedPositions.contains(
                                  '${String.fromCharCode(row + 65)}${col + 1}')
                              ? Colors.blue
                              : Colors.white,
                        ),
                        child: Center(
                          child: selectedPositions.contains(
                                  '${String.fromCharCode(row + 65)}${col + 1}')
                              ? const Icon(
                                  Icons.directions_boat_filled,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (selectedPositions.length <= 5) {
                _persistSelectedPositions();
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Alert'),
                      content: const Text('You can only place upto 5 ships.'),
                      actions: [
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
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _togglePosition(String position) {
    setState(() {
      if (!selectedPositions.contains(position)) {
        if (selectedPositions.length < 5) {
          grid[int.parse(position.substring(1)) - 1]
                  [position.codeUnitAt(0) - 65] =
              !grid[int.parse(position.substring(1)) - 1]
                  [position.codeUnitAt(0) - 65];
          selectedPositions.add(position);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You can only place upto 5 ships.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      } else {
        grid[int.parse(position.substring(1)) - 1]
                [position.codeUnitAt(0) - 65] =
            !grid[int.parse(position.substring(1)) - 1]
                [position.codeUnitAt(0) - 65];
        selectedPositions.remove(position);
      }
    });
  }

  void _persistSelectedPositions() async {
    if (selectedPositions.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please place 5 ships to start the game')),
      );
    } else {
      int result = await apiService.persistSelectedPositions(
          selectedPositions, widget.aiType);
      if (result == 200) {
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } else if (result == 401) {
        await SessionManager.clearSession();
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ));
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to create a game')),
        );
      }
    }
  }

  void _retrieveSelectedPositions() async {
    selectedPositions = await SessionManager.getShipPositions();
    for (String position in selectedPositions) {
      int row = int.parse(position.substring(1)) - 65;
      int col = position.codeUnitAt(0) - 1;
      grid[row][col] = true;
    }
  }
}
