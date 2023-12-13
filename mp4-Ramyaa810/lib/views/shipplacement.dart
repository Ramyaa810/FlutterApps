part of "homescreen.dart"; 
Future<void> navigateToShipPlacement(BuildContext context) async {
    final dynamic result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ShipPlacementPage()),
    );

    if (result != null && result is Map<String, dynamic>) {
      final gameId = result['id'];
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => GameViewPage(gameId: gameId
              ),
        ),
      );
    }
  }