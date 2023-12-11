class UserData {
  int? id;
  String? dateTime;
  String? userName;
  String? password;

  userDataMap() {
    var mapping = <String, dynamic>{};
    mapping['id'] = id;
    mapping['dateTime'] = dateTime;
    mapping['userName'] = userName!;
    mapping['password'] = password!;
  
    return mapping;
  }
}
