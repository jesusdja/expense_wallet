import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesLocal {

  static late SharedPreferences prefs;

  static Future<void> configurePrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  static int get walletLogin => prefs.getInt("walletLogin") ?? 0;
  static set walletLogin(int value) => prefs.setInt("walletLogin", value);

  static String get trakerNumber => prefs.getString("trakerNumber") ?? '+584249178826';
  static set trakerNumber(String value) => prefs.setString("trakerNumber", value);
}
