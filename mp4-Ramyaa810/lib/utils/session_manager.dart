import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static const String _sessionKey = 'sessionToken';
  static const String _username = 'username';

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionToken = prefs.getString(_sessionKey);
    return sessionToken != null;
  }

  static Future<String> getSessionToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionKey) ?? '';
  }

  static Future<String> getusername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_username) ?? '';
  }

  static Future<void> setSessionToken(String token, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, token);
    await prefs.setString(_username, username);
  }

  static Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  static const String _shipPositionsKey = 'shipPositions';

  static Future<void> setShipPositions(List<String> positions) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_shipPositionsKey, positions);
  }

  static Future<List<String>> getShipPositions() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_shipPositionsKey) ?? [];
  }

 static Future<void> setUsername(String username) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', username);
}
}
