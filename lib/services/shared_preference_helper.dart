import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_config.dart';

class SharedPreferenceHelper {
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
    AppConfig.accessToken = token;
    log("SAVED TOKEN : $token");
  }

  static Future<void> saveCounterID(String counterID) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("counter", counterID);
    AppConfig.counterID = counterID;
    log("SAVED COUNTER : $counterID");
  }

  static Future<String> getCounterID() async {
    final prefs = await SharedPreferences.getInstance();
    String id = prefs.getString("counter") ?? "";
    log('counter $id');
    AppConfig.counterID = id;
    return id;
  }

  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? "";
    log(token);
    AppConfig.accessToken = token;
    return token;
  }

  static Future<void> clearWholeData() async {
    AppConfig.accessToken = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
