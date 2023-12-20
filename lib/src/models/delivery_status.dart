class DeliveryStatus {
  String admin;
  String pending;
  int time;

  DeliveryStatus();

  DeliveryStatus.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      admin = jsonMap['id'].toString();
      pending = jsonMap['pending'] ?? '';
      time = jsonMap['time'] ?? 0;
    } catch (e) {
      admin = '';
      pending = '';
      time = 0;

    }
  }
}
