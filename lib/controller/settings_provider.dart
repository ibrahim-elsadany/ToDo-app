import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SettingsProvider with ChangeNotifier {
  String _mode ="Light";
  String get mode => _mode;
  String _language = "English";
  String get language => _language;

  SettingsProvider(){
    _mode = "Light";
    _language = "English";
    _loadThemeFromPreferences();
    _loadLanguageFromPreferences();
  }

  void toggleTheme(String value) {
    _mode = value!;
    _saveThemeToPreferences();
    notifyListeners();
  }
  Future<void> _loadThemeFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _mode = prefs.getString('mode') ?? "Light";
    notifyListeners();
  }
  Future<void> _saveThemeToPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('mode', _mode);
  }

  void toggleLanguage(String value){
    _language = value!;
    _saveLanguageToPreferences();
    notifyListeners();
  }
  Future<void> _loadLanguageFromPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _mode = prefs.getString('lang') ?? "English";
    notifyListeners();
  }
  Future<void> _saveLanguageToPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('lang', _language);
  }

}
