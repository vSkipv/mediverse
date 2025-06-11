import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart' as Constant;

class CachedData {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    print('SharedPreferences initialized: ${_prefs != null}');
  }

  static Future<bool> setData(String key, dynamic value) async {
    if (_prefs == null) {
      await init();
    }

    print('Setting data for key: $key, value: $value');

    bool result = false;
    if (value is String) {
      result = await _prefs!.setString(key, value);
    } else if (value is bool) {
      result = await _prefs!.setBool(key, value);
    } else if (value is int) {
      result = await _prefs!.setInt(key, value);
    } else if (value is double) {
      result = await _prefs!.setDouble(key, value);
    } else if (value is List<String>) {
      result = await _prefs!.setStringList(key, value);
    }

    print('Data set result: $result');
    return result;
  }

  static Future<dynamic> getData(String key) async {
    if (_prefs == null) {
      await init();
    }
    final value = _prefs!.get(key);
    print('Getting data for key: $key, value: $value');
    return value;
  }

  static Future<bool> removeData(String key) async {
    if (_prefs == null) {
      await init();
    }
    final result = await _prefs!.remove(key);
    print('Removed data for key: $key, result: $result');
    return result;
  }

  static Future<bool> clearData() async {
    if (_prefs == null) {
      await init();
    }
    final result = await _prefs!.clear();
    print('Cleared all data, result: $result');
    return result;
  }

  // Token specific methods
  static Future<bool> saveToken(String token) async {
    print('Saving token: $token');
    final result = await setData(Constant.accessToekn, token);
    print('Token save result: $result');
    return result;
  }

  static Future<String?> getToken() async {
    final token = await getData(Constant.accessToekn) as String?;
    print('Getting token: $token');
    return token;
  }

  static Future<bool> removeToken() async {
    print('Removing token');
    return await removeData(Constant.accessToekn);
  }

  static Future<bool> hasToken() async {
    final token = await getToken();
    final hasToken = token != null && token.isNotEmpty;
    print('Has token: $hasToken');
    return hasToken;
  }

  static Future<String?> getimage() async {
    final image = await getData(Constant.image) as String?;
    print('Getting image: $image');
    return image;
  }

  static Future<bool> saveImage(String? imageUrl) async {
    print('Saving image: $imageUrl');
    final result = await setData(Constant.image, imageUrl);
    print('Image save result: $result');
    return result;
  }

  /// Converts a relative image path to a complete URL
  static String? processImagePath(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return null;
    }

    String processedPath = imagePath;

    // Remove file:/// prefix if present
    if (processedPath.startsWith('file:///')) {
      processedPath = processedPath.substring(8); // Remove 'file:///'
    }

    // Ensure path starts with /
    if (!processedPath.startsWith('/')) {
      processedPath = '/$processedPath';
    }

    // Construct complete URL
    return 'http://projectmetaverse.runasp.net$processedPath';
  }
}