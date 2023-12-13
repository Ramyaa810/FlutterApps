part of "homescreen.dart"; 

  Future<void> showAIDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Which AI do you want to play against?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                GestureDetector(
                  onTap: () {
                    _startGameWithAI("random", context);
                  },
                  child: const Text('Random'),
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  onTap: () {
                    _startGameWithAI("perfect", context);
                  },
                  child: const Text('Perfect'),
                ),
                const Padding(padding: EdgeInsets.all(8.0)),
                GestureDetector(
                  onTap: () {
                    _startGameWithAI("oneship", context);
                  },
                  child: const Text('One Ship (AI)'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }