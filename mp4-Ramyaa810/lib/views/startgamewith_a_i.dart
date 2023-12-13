part of "homescreen.dart"; 

    Future<void> _startGameWithAI(String aiType, BuildContext context ) async {
        Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ShipPlacementPage(aiType: aiType),
      ),
    );
  }