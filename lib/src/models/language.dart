class Language {
  String code;
  String englishName;
  String localName;
  String flag;
  bool selected;

  Language(this.code, this.englishName, this.localName, this.flag, {this.selected = false});
}

class LanguagesList {
  List<Language> _languages;

  LanguagesList() {
    _languages = [
      Language("en", "English", "English", "assets/img/united-states-of-america.png"),
      Language("ar", "Arabic", "العربية", "assets/img/united-arab-emirates.png"),

    ];
  }

  List<Language> get languages => _languages;
}
