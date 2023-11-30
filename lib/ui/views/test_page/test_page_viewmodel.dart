import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:test_blu/app/app.locator.dart';
import 'package:test_blu/core/enum/dialog_type.dart';
import 'package:test_blu/core/mixin.dart';
import 'package:test_blu/core/model/user.model.dart';
import 'package:test_blu/services/user_service.dart';

class TestPageViewModel extends BaseViewModel with NavigationMixin {
  TestPageViewModel() {
    init();
  }

  final _userService = UserService();
  final _dialogService = locator<DialogService>();

  String? _area;
  String? _customerId;
  String? _name;
  String? get area => _area ?? 'Malumachampatti';
  DateTime now = DateTime.now();

  String? get name => _name;

  bool? _isEnabled;

  bool? get isEnabled => _isEnabled;

  String get formattedTime => DateFormat.jm().format(now);
  String get session => DateFormat('a').format(now);

  String get date => DateFormat('dd-MM-yyyy').format(now);
  String? get customerId => _customerId ?? '123';
  final String _address = '00:22:09:01:4C:30';
  String get address => _address;
  StreamSubscription<Uint8List>? streamSubscription;

  late BluetoothConnection? _connection;

  List<BluetoothDiscoveryResult>? _results;

  List<BluetoothDiscoveryResult>? get results => _results;
  BluetoothConnection? connection;

  final _sharedPreference = locator<SharedPreferences>();

  String? _weightData;
  // List<double> get weightData => extractFirstDouble(_weightData);
  List<double> get weightData {
    if (_weightData != null && _isEnabled != null && _isEnabled!) {
      return extractFirstDouble(_weightData!);
    } else {
      return [0.0]; // Or handle the null case accordingly
    }
  }
  //   return (extractedData != null && extractedData != 0.0) ? extractedData : 0.00;
  // }

  init() async {
    _connection = await BluetoothConnection.toAddress(address);

    _connection?.input?.listen((Uint8List data) {
      // String newData = ascii.decode(data);
      // _weightData = _weightData != null ? '$_weightData$newData' : newData;
      if (data != null) {
        _weightData = ascii.decode(data);
        print('Data incoming:${ascii.decode(data)}');

        // print('Data incoming:$newData');
        notifyListeners();

        _connection?.output.add(data); // Sending data

        if (ascii.decode(data).contains('!')) {
          _connection?.finish(); // Closing connection
          print('Disconnecting by local host');
        }
      } else {
        return;
      }
    }).onDone(() {
      print('Disconnected by remote request');
    });
  }

  List<double> extractFirstDouble(String input) {
    RegExp regex = RegExp(r'([+-]?\d*\.?\d+)');
    List<double> numericValues = [];

    // Extract the numeric values from the input string
    Iterable<Match> matches = regex.allMatches(input);
    for (Match match in matches) {
      String numericString = match.group(1)!;
      double numericValue = double.parse(numericString);
      numericValues.add(numericValue);
    }

    return numericValues;
  }

  String? get data => _sharedPreference.getString('weightData');

  void calculateWeight() {
    _sharedPreference.setString('weightData', weightData.toString());
    notifyListeners();
  }

  Future<void> clearValueFromSharedPreferences() async {
    notifyListeners();
    String keyToRemove = "weightData";
    _sharedPreference.remove(keyToRemove);
  }

  @override
  void dispose() {
    // finished();
    super.dispose();
  }

  Future<void> submitData() async {
    notifyListeners();
    var user = User();
    user.time = now.toIso8601String(); // formattedTime;
    user.session = session;
    user.customerId = customerId!;
    user.dateTime = date;
    user.weight = data.toString();
    var result = await _userService.saveUser(user);
    notifyListeners();
    // diableForm(); // clearValueFromSharedPreferences();
  }

  void setCustomerId(String customerId) {
    _customerId = customerId;
    notifyListeners();
  }

  void diableForm() {
    if (_isEnabled != null && _isEnabled! && weightData.contains(0.00)) {
      _isEnabled;
      notifyListeners();
    }
  }

  // void setCustomerName(String name) {
  //   _name = name;
  //   notifyListeners();
  // }

  void showErrDialog(String message) {
    _dialogService.showCustomDialog(variant: DialogType.error, title: "Message", description: message);
  }
}
