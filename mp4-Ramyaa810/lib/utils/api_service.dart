import 'package:battleships/utils/session_manager.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://165.227.117.48';

  Future<bool> deletePost(int id) async {
    String headerValue = await SessionManager.getSessionToken();
    bool success = false;
    final response = await http.delete(
      Uri.parse('$baseUrl/games/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $headerValue',
      },
    );
    if (response.statusCode == 200) {
      success = true;
    }
    if (response.statusCode == 401) {
      throw Exception('Token Expired');
    }
    return success;
  }

  Future<List<dynamic>> loadPosts() async {
    String headerValue = await SessionManager.getSessionToken();
    final response = await http.get(Uri.parse('$baseUrl/games'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $headerValue',
    });

    final posts = json.decode(response.body);
    List<dynamic> result = List.empty(growable: true);
    if (posts['games'] != null) {
      final a = posts['games'];
      for (var b in a) {
        if (b['status'] == 0 || b['status'] == 3) result.add(b);
      }
    }
    if (response.statusCode == 401) {
      throw Exception('Token Expired');
    }

    return result;
  }

  Future<Map<String, dynamic>> loadShipPositions(String gameId) async {
    final Map<String, dynamic> gameDetails;
    String headerValue = await SessionManager.getSessionToken();
    final response = await http.get(
      Uri.parse('$baseUrl/games/$gameId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $headerValue',
      },
    );

    if (response.statusCode == 200) {
      gameDetails = json.decode(response.body);
      return gameDetails;
    }
    if (response.statusCode == 401) {
      throw Exception('Token Expired');
    } else {
      throw Exception('Failed to load ship positions');
    }
  }

  Future<List<dynamic>> loadCompletedGames() async {
    String headerValue = await SessionManager.getSessionToken();
    final response = await http.get(
      Uri.parse('http://165.227.117.48/games'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $headerValue',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> games = json.decode(response.body)['games'];
      final completedGames = games
          .where((game) => game['status'] == 1 || game['status'] == 2)
          .toList();

      return completedGames;
    }
    if (response.statusCode == 401) {
      throw Exception('Token Expired');
    } else {
      throw Exception('Failed to load completed games');
    }
  }

  Future<bool> login(String username, String password) async {
    final url = Uri.parse('http://165.227.117.48/login');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }));

    if (response.statusCode == 200) {
      final response1 = response.body;
      Map<String, dynamic> map = jsonDecode(response1);
      String? token = map['access_token'];
      await SessionManager.setSessionToken(token!, username);
      return true;
    }
    if (response.statusCode == 401) {
      throw Exception('Token Expired');
    }
    return false;
  }

  Future<bool> register(String username, String password) async {
    final url = Uri.parse('http://165.227.117.48/register');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
        }));
    if (response.statusCode == 200) {
      final response2 = response.body;
      Map<String, dynamic> map = jsonDecode(response2);
      String? token = map['access_token'];
      await SessionManager.setSessionToken(token!, username);
      return true;
    }
    if (response.statusCode == 401) {
      throw Exception('Token Expired');
    }
    return false;
  }

  Future<int> persistSelectedPositions(
      List<String> selectedPositions, String? aiType) async {
    final url = Uri.parse('http://165.227.117.48/games');
    final headerValue = await SessionManager.getSessionToken();
    String encodedj;
    if (aiType != "") {
      encodedj = jsonEncode({"ships": selectedPositions, "ai": aiType});
    } else {
      encodedj = jsonEncode({"ships": selectedPositions});
    }
    final response = await http.post(url,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $headerValue',
        },
        body: encodedj);
    if (response.statusCode == 401) {
      throw Exception('Token Expired');
    }
    return response.statusCode;
  }
}
