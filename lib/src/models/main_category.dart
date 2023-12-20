

class MainCategoryModel {
  String id;
  String name;
  bool selected;


  MainCategoryModel();

  MainCategoryModel.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'];
      name = jsonMap['name'];
      selected = jsonMap['selected'];

    } catch (e) {
      id = '';
      name = '';
      selected = false;

    }
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "selected": selected,
  };
}
