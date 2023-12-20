import 'package:flutter/material.dart';
import 'package:responsive_ui/responsive_ui.dart';

import '../../generated/l10n.dart';
import '../models/language.dart';
import '../repository/settings_repository.dart' as setting_repo;

class LanguagesWidget extends StatefulWidget {
  const LanguagesWidget({Key key}) : super(key: key);

  @override
  State<LanguagesWidget> createState() => _LanguagesWidgetState();
}

class _LanguagesWidgetState extends State<LanguagesWidget> {
  LanguagesList languagesList;

  @override
  void initState() {
    languagesList = LanguagesList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.background
        ),

      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child:Center(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child:Column(
                children:[
                  Container(
                    padding: const EdgeInsets.only(bottom: 5),
                    child:Text(
                      S.of(context).language,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                     Text(S.of(context).select_your_prefered_languages)
                ]
              )
            ),
            const SizedBox(
              height: 30,
            ),
            Wrap(
              children:List.generate(languagesList.languages.length, (index) {
                Language language = languagesList.languages.elementAt(index);
                setting_repo.getDefaultLanguage(setting_repo.setting.value.mobileLanguage.value.languageCode).then((langCode) {
                  if (langCode == language.code) {
                    setState(() {
                      language.selected = true;
                    });
                  }
                });
                return InkWell(
                    onTap: () async {
                      var lang = language.code.split("_");
                      if (lang.length > 1) {
                        setting_repo.setting.value.mobileLanguage.value = Locale(lang.elementAt(0), lang.elementAt(1));
                      } else {
                        setting_repo.setting.value.mobileLanguage.value = Locale(lang.elementAt(0));
                      }
                      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                      setting_repo.setting.notifyListeners();
                      for (var l in languagesList.languages) {
                        setState(() {
                          l.selected = false;
                        });
                      }
                      language.selected = !language.selected;
                      setting_repo.setDefaultLanguage(language.code);
                    },
                    child:Div(
                  colS:6,
                  colM:6,
                  colL:6,
                  child:Container(
                    margin: const EdgeInsets.only(bottom: 25),
                    child:Stack(
                      alignment: Alignment.center,
                        children:[

                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          height: 75,
                          width: 75,
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(Radius.circular(40)),
                            image: DecorationImage(image: AssetImage(language.flag), fit: BoxFit.cover),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(language.englishName,
                          style: Theme.of(context).textTheme.titleSmall,
                          )
                        )

                      ],
                    ),
                          Positioned(
                            top: 0,
                            child:Container(
                            height: language.selected ? 75 : 0,
                            width: language.selected ? 75 : 0,
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(40)),
                              color: Theme.of(context).colorScheme.secondary.withOpacity(language.selected ? 0.85 : 0),
                            ),
                            child: Icon(
                              Icons.check,
                              size: language.selected ? 24 : 0,
                              color: Theme.of(context).colorScheme.primary.withOpacity(language.selected ? 0.85 : 0),
                            ),
                          ),)
                        ],
                    )
                  )
                ));
              })
            ),
            const SizedBox(height: 10),
            /*ListView.separated(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: languagesList.languages.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                Language _language = languagesList.languages.elementAt(index);
                settingRepo.getDefaultLanguage(settingRepo.setting.value.mobileLanguage.value.languageCode).then((_langCode) {
                  if (_langCode == _language.code) {
                    setState(() {
                      _language.selected = true;
                    });
                  }
                });
                return InkWell(
                  onTap: () async {
                    var _lang = _language.code.split("_");
                    if (_lang.length > 1)
                      settingRepo.setting.value.mobileLanguage.value = new Locale(_lang.elementAt(0), _lang.elementAt(1));
                    else
                      settingRepo.setting.value.mobileLanguage.value = new Locale(_lang.elementAt(0));
                    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                    settingRepo.setting.notifyListeners();
                    languagesList.languages.forEach((_l) {
                      setState(() {
                        _l.selected = false;
                      });
                    });
                    _language.selected = !_language.selected;
                    settingRepo.setDefaultLanguage(_language.code);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.9),
                      boxShadow: [
                        BoxShadow(color: Theme.of(context).focusColor.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 2)),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          alignment: AlignmentDirectional.center,
                          children: <Widget>[
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(40)),
                                image: DecorationImage(image: AssetImage(_language.flag), fit: BoxFit.cover),
                              ),
                            ),
                            Container(
                              height: _language.selected ? 40 : 0,
                              width: _language.selected ? 40 : 0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(40)),
                                color: Theme.of(context).colorScheme.secondary.withOpacity(_language.selected ? 0.85 : 0),
                              ),
                              child: Icon(
                                Icons.check,
                                size: _language.selected ? 24 : 0,
                                color: Theme.of(context).colorScheme.primary.withOpacity(_language.selected ? 0.85 : 0),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                _language.englishName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Text(
                                _language.localName,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),*/
          ],
        ),)
      ),
    );
  }
}
