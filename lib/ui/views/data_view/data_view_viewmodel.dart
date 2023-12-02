import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:test_blu/app/app.locator.dart';
import 'package:test_blu/core/mixin.dart';
import 'package:test_blu/core/model/user.model.dart';
import 'package:test_blu/services/user_service.dart';
import 'package:test_blu/ui/common/shared/styles.dart';
import 'package:test_blu/ui/views/data_view/data_view_view.dart';

class DataViewViewModel extends BaseViewModel with NavigationMixin {
  DataViewViewModel() {
    getDateAndSessionUsers();
  }

  late final List<User> _userList = [];
  final _userService = UserService();
  final _sharedPreference = locator<SharedPreferences>();

  final now = DateTime.now();
  DateTime? _fromDate;
  DateTime get fromDate => _fromDate ?? DateTime(now.year, now.month, 1);
  String get fDate => DateFormat('dd-MM-yyyy').format(fromDate); //DateFormat('MM-dd-yyyy').format(fromDate);
  // String get date => DateFormat('dd-MM-yyyy').format(now);

  String? _selectedValue;
  String? get selectedValue => _selectedValue ?? "AM";
  String? _file;

  List<User> get userList => _userList ?? [];

  List<String> get customerId => userList.map((e) => e.customerId.toString()).toSet().toList();
  List<String> get weight => userList.map((e) => e.weight.toString()).toSet().toList();

  Future<void> getAllUserDetails() async {
    var users = await _userService.readAllUser();
    // var users = await _userService.readDateAndSession(fDate, selectedValue);

    users.forEach((user) {
      notifyListeners();
      var userModel = User();
      userModel.id = user['id'];
      userModel.customerId = user['customerId'];
      userModel.dateTime = user['dateTime'];
      userModel.session = user['session'];
      userModel.weight = user['weight'];
      userModel.time = user['time'];
      _userList.add(userModel);
    });
  }

  Future<void> getDateAndSessionUsers() async {
    var users1 = await _userService.readDateAndSession(fDate, selectedValue);

    users1.forEach((user) {
      notifyListeners();
      var userModel = User();
      userModel.id = user['id'];
      userModel.customerId = user['customerId'];
      userModel.dateTime = user['dateTime'];
      userModel.session = user['session'];
      userModel.weight = user['weight'];
      userModel.time = user['time'];
      _userList.add(userModel);
    });
  }

  void deleteFromDialog(BuildContext context, userId) async {
    notifyListeners();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Delete"),
            content: const Text('Are you sure to want Delete?'),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.redAccent,
                  )),
              IconButton(
                  onPressed: () {
                    var user = _userService.deleteUser(userId);

                    notifyListeners();
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const DataViewView()), (route) => false);

                    getDateAndSessionUsers();
                  },
                  icon: const Icon(
                    Icons.done,
                    color: appcolor2699FB,
                  ))
            ],
          );
        });
  }

  void deleteDialog(BuildContext context) async {
    notifyListeners();
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("All Data Delete"),
            content: const Text('Are you sure to want All Data Delete?'),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.redAccent,
                  )),
              IconButton(
                  onPressed: () {
                    var result = _userService.deleteData();

                    notifyListeners();
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const DataViewView()), (route) => false);

                    getDateAndSessionUsers();
                  },
                  icon: const Icon(
                    Icons.done,
                    color: appcolor2699FB,
                  ))
            ],
          );
        });
  }

  void deleteDatas() async {
    var result = await _userService.deleteData();
    goToDataView();
    notifyListeners();
  }

  Future<void> selectFromDate(BuildContext context) async {
    final DateTime? fromDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (fromDate != null) {
      _fromDate = fromDate;
      notifyListeners();
    }
    _sharedPreference.setString('fromdate', fDate ?? '');
  }

  void selectSession(String value) {
    notifyListeners();
    _selectedValue = value;
  }

  void submitbutton() {
    notifyListeners();
    getDateAndSessionUsers();
  }

  Future<void> exportTableToCSV(String filePath) async {
    List<Map<String, dynamic>> results = await _userService.readDateAndSession(fDate, selectedValue);

    if (results.isNotEmpty) {
      String csv = '${results.first.keys.join(',')}\n'; // Header row

      for (var row in results) {
        csv += '${row.values.join(',')}\n'; // Data rows
      }

      await File(filePath).writeAsString(csv);
      _file = filePath;
    }
  }

  void export() {
    exportTableToCSV(_file.toString());
    notifyListeners();
  }
}
