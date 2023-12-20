class Notification {
  String id;
  String type;
  Map<String, dynamic> data;
  bool read;
  DateTime createdAt;

  Notification();

  Notification.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      type = jsonMap['type'] != null ? jsonMap['type'].toString() : '';
      data = jsonMap['data'] != null ? {} : {};
      read = jsonMap['read_at'] != null ? true : false;
      createdAt = DateTime.parse(jsonMap['created_at']);
    } catch (e) {
      id = '';
      type = '';
      data = {};
      read = false;
      createdAt = DateTime(0);

    }
  }

  Map markReadMap() {
    var map = <String, dynamic>{};
    map["id"] = id;
    map["read_at"] = !read;
    return map;
  }
}
