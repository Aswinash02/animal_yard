import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LocaleController extends GetxController {
  var locale = Locale('en', '').obs;
  var localData = 'en'.obs;

  void setLocale(String code) {
    locale.value = Locale(code, '');
    localData.value = code;
    print("SET lOCALE ----------------------->${locale.value}");
    print("SET lOCALE Data----------------------->${code}");
  }

  void clearLocale() {
    locale.value = Locale('en', '');
    localData.value = '';
  }
}
