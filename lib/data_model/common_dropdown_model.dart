import 'language_list_response.dart';

class CommonDropDownItems {
  String? key, value;

  CommonDropDownItems(this.key, this.value);
}

class ColorModel {
  String? key, value, name;

  ColorModel(this.key, this.value);
}

class LanguageDropModel {
  String key, value;
  Language language;

  LanguageDropModel(this.key, this.value, this.language);
}