

class RegisterModel {
  String name;
  // ignore: non_constant_identifier_names
  String email_id;
  String phone;
  String password;
  String loginType;
  String regVia;
  String img;
  String description;
  RegisterModel();

  RegisterModel.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      name = jsonMap['name'];
      email_id = jsonMap['email_id'];
      phone = jsonMap['phone'];
      password = jsonMap['password'];
      loginType = jsonMap['loginType'];
      regVia = jsonMap['regVia'];
      img = jsonMap['img'];
      description = jsonMap['description'];
    } catch (e) {
      name = '';
      email_id = '';
      phone = '';
      password = '';
      loginType = '';
      regVia = '';
      img = '';
      description = '';

    }
  }
  Map toMap() {
    var map = <String, dynamic>{};
    map["name"] = name;
    map["email_id"] = email_id;
    map["phone"] = phone;
    map["password"] = password;
    map["loginType"] = loginType;
    map["regVia"] = regVia;
    map["img"] = img;
    map["description"] = description;
    return map;
  }
}
