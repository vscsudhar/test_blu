class User {
  int? id;
  String? dateTime;
  String? weight;
  String? session;
  String? customerId;
  String? time;

  userMap() {
    var mapping = <String, dynamic>{};
    mapping['id'] = id;
    mapping['dateTime'] = dateTime!;
    mapping['weight'] = weight!;
    mapping['session'] = session!;
    mapping['customerId'] = customerId!;
    mapping['time'] = time!;
    return mapping;
  }
}
