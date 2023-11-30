import 'package:test_blu/db_helper/repository.dart';

import '../core/model/user.model.dart';

class UserService {
  late Repository _repository;
  UserService() {
    _repository = Repository();
  }

  //Save User
  saveUser(User user) async {
    return await _repository.insertData('users', user.userMap());
  }

  //read All User

  readAllUser() async {
    return await _repository.readData('users');
  }

  deleteUser(userId) async {
    return await _repository.deleteDataById('users', userId);
  }

  deleteData() async {
    return await _repository.deleteDatas();
  }

  readDateAndSession(date, session) async {
    return await _repository.readByDateAndSession('users', date, session);
  }

  exportTableToCSV() async {
    return await _repository.exportTableToCSV('users');
  }
}
