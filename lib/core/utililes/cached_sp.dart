import 'package:shared_preferences/shared_preferences.dart';

class CachedData {
  static late SharedPreferences prefs;

  static cachInit() async {
    prefs = await SharedPreferences.getInstance();
  }

  static void storeData(String key, dynamic value) {
    if (value is String) {
      prefs.setString(key, value);
    } else if (value is int) {
      prefs.setInt(key, value);
    } else if (value is double) {
      prefs.setDouble(key, value);
    } else {
      prefs.setBool(key, value);
    }
  }


  static dynamic getData(String key) {
    return prefs.get(key);
  }

  static void removeData(String key) {
    prefs.remove(key);
  }
}