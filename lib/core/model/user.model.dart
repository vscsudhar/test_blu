class User {
  int? id;
  String? dateTime;
  String? weight;
  String? session;
  String? customerId;
  String? time;
  String? center;

  userMap() {
    var mapping = <String, dynamic>{};
    mapping['id'] = id;
    mapping['dateTime'] = dateTime!;
    mapping['weight'] = weight!;
    mapping['session'] = session!;
    mapping['customerId'] = customerId!;
    mapping['time'] = time!;
    mapping['center'] = center!;
    return mapping;
  }
}
