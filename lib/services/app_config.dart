class AppConfig {
  static final AppConfig _instance = AppConfig._internal();
  factory AppConfig() => _instance;
  AppConfig._internal();
  static String baseUrl = "http://appuser.templesoftware.in/public/api/";
  static String? accessToken;
  static String? counterID;
  static int? customerId;
  static String? customerName;
  static String? customerNumber;
  static String? settings;
  static int? version = 1;
}
