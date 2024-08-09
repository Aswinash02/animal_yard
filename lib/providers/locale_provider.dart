import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import '../lang_config.dart';

// class LocaleProvider extends ChangeNotifier {
//   Locale? _locale = Locale('en');
//
//   Locale get locale => _locale!;
//
//   void setLocale(String code) {
//     _locale = Locale(code, '');
//     notifyListeners();
//   }
// }
class LocaleProvider extends ChangeNotifier {
  Locale? _locale = Locale('en');

  Locale get locale => _locale!;

  void setLocale(String code) {
    _locale = Locale(code);
    notifyListeners();
  }

  void clearLocale() {
    _locale = null;
    notifyListeners();
  }
}
