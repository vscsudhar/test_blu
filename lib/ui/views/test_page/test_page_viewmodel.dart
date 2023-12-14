import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:test_blu/app/app.locator.dart';
import 'package:test_blu/core/mixin.dart';
import 'package:test_blu/core/model/user.model.dart';
import 'package:test_blu/services/user_service.dart';
import 'package:test_blu/ui/views/home/home_view.dart';
import 'package:xml/xml.dart' as xml;

class TestPageViewModel extends BaseViewModel with NavigationMixin {
  TestPageViewModel() {
    requestExternalStoragePermission();
  }

  final _sharedPreference = locator<SharedPreferences>();

  DateTime? _pickDate;
  DateTime get pickDate => _pickDate ?? DateTime.now();
  String? get fDate => DateFormat('dd-MM-yyyy').format(pickDate);
  String? csvData = '';
  String? xmlData = '';
  String? _filePath;
  String? get csvFilePath => _filePath;
  String? get Date1 => DateFormat('ddMMyyyy').format(pickDate);

  String? get locationId => _sharedPreference.getString('locationId') ?? "MalumachamPatti";

  late final List<User> _userList = [];
  final _userService = UserService();
  List<User> get userList => _userList ?? [];

  Future<void> selectFromDate(BuildContext context) async {
    final DateTime? fromDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );

    if (fromDate != null) {
      _pickDate = fromDate;
      notifyListeners();
    }
    _sharedPreference.setString('fromdate', fDate ?? '');
  }

  Future<void> getDate() async {
    _userList.clear();
    var users1 = await _userService.readDate(fDate);
    notifyListeners();
    users1.forEach((user) {
      notifyListeners();
      var userModel = User();
      userModel.id = user['id'];
      userModel.center = user['center'];
      userModel.customerId = user['customerId'];
      userModel.dateTime = user['dateTime'];
      userModel.session = user['session'];
      userModel.weight = user['weight'];
      userModel.time = user['time'];
      _userList.add(userModel);
    });
    var usersList = users1.map((user) => user.values.toList()).toSet().toList();
    print(usersList);
    csvData = const ListToCsvConverter().convert(usersList.cast<List<dynamic>?>());
    print(csvData);
    final xmlData = convertListToXml(usersList);

    await writeToInternalStorage();
    await writeToPenDrive();
    var flatUsersList = usersList.expand((list) => list).toList();
    notifyListeners();
    // csvData = flatUsersList.join(',');
    print(csvData);
  }

  Future<String> getExternalStorageDirectoryPath() async {
    final directory = await getExternalStorageDirectory();
    return directory!.path;
  }

  Future<void> writeToPenDrive() async {
    try {
      final externalDir = await getExternalStorageDirectoryPath();

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '$Date1-($locationId).csv';

      final filePath = '$externalDir/$fileName';

      final file = File(filePath);

      await file.writeAsString(csvData!);
      notifyListeners();
      // _filePath = filePath;

      print('CSV data written to pen drive: $filePath');
    } catch (e) {
      print('Error writing to pen drive: $e');
    }
  }

  Future<String> getInternalStorageDirectoryPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> writeToInternalStorage() async {
    try {
      final internalDir = await getInternalStorageDirectoryPath();

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '$locationId.csv';
      final xmlFileName = '$locationId.xml';

      final xmlFilePath = '$internalDir/$xmlFileName';
      final filePath = '$internalDir/$fileName';

      final xmlFile = File(xmlFilePath);
      final file = File(filePath);

      await xmlFile.writeAsString(xmlData!);
      // await xmlFile.writeAsString(xmlData.toXmlString(pretty: true));
      await file.writeAsString(csvData!);
      _filePath = filePath;

      print('CSV data written to internal storage: $filePath');
    } catch (e) {
      print('Error writing to internal storage: $e');
    }
  }

  Future<void> submitData() async {
    await getDate();
    print(csvData);
    notifyListeners();
  }

  Future<void> requestExternalStoragePermission() async {
    final status = await Permission.storage.status;

    if (!status.isGranted) {
      final result = await Permission.storage.request();
      if (result == PermissionStatus.granted) {
        print('External storage permission granted');
      } else {
        print('External storage permission denied');
      }
    } else {
      print('External storage permission already granted');
    }
  }

  xml.XmlDocument convertListToXml(List<Map<String, dynamic>> userList) {
    final xmlBuilder = xml.XmlBuilder();

    xmlBuilder.element('root', nest: () {
      for (var user in userList) {
        xmlBuilder.element('user', nest: () {
          user.forEach((key, value) {
            xmlBuilder.element(key, nest: value.toString());
          });
        });
      }
    });

    return xmlBuilder.buildDocument();
  }

  void goBack(context) {
    notifyListeners();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeView(),
      ),
    );
  }
}
