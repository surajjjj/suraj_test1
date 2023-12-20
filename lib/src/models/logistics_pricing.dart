class LogisticsPricing {
  String id;
  int fromRange;
  int toRange;
  int amount;

  LogisticsPricing();

  LogisticsPricing.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'];
      fromRange = int.tryParse(jsonMap['fromRange'] ?? '0') ?? 0.0;
      toRange = int.tryParse(jsonMap['toRange'] ?? '0') ?? 0.0;
      amount = int.tryParse(jsonMap['amount'] ?? '0') ?? 0.0;
    } catch (e) {
      id = '';
      fromRange = 0;
      toRange = 0;
      amount = 0;

    }
  }
}
