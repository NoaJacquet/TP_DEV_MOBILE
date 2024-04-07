import 'package:shared_preferences/shared_preferences.dart';

class PreferencesManager {
  static Future<void> saveUserCredentials(String pseudo, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(pseudo, password);
  }

  static Future<String?> getPassword(String pseudo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(pseudo);
  }

  static Future<String?> getLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('logged_in_user');
  }

  static Future<void> setLoggedInUser(String pseudo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('logged_in_user', pseudo);
  }

  static Future<void> removeLoggedInUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('logged_in_user');
  }

  // Enregistrer les parties jouées
  static Future<void> saveGames(String userId, List<Map<String, dynamic>> games) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(userId, games.map((game) => game.toString()).toList());
  }

  // Obtenir les parties jouées
  static Future<List<Map<String, dynamic>>?> getGames(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? gamesStringList = prefs.getStringList(userId);
    if (gamesStringList != null) {
      List<Map<String, dynamic>> games = gamesStringList.map((gameString) {
        Map<String, dynamic> game = Map<String, dynamic>();
        List<String> parts = gameString.split(',');
        for (String part in parts) {
          List<String> keyValue = part.split(':');
          String key = keyValue[0].trim();
          dynamic value = keyValue[1].trim();
          if (value.contains('{') && value.contains('}')) {
            // Si la valeur est un map
            value = value.replaceAll('{', '').replaceAll('}', '').trim();
            List<String> entries = value.split(';');
            Map<String, dynamic> innerMap = Map<String, dynamic>();
            for (String entry in entries) {
              List<String> innerKeyValue = entry.split(':');
              String innerKey = innerKeyValue[0].trim();
              dynamic innerValue = innerKeyValue[1].trim();
              innerMap[innerKey] = innerValue;
            }
            game[key] = innerMap;
          } else {
            game[key] = value;
          }
        }
        return game;
      }).toList();
      return games;
    } else {
      return null;
    }
  }


}