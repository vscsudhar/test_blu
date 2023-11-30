import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
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
import 'package:test_blu/ui/views/home/home_view.dart';
import 'package:flutter/services.dart';

class WeightViewModel extends BaseViewModel with NavigationMixin {
  WeightViewModel() {
    init();
    // ServicesBinding.instance.keyboard.addHandler(onKey as KeyEventCallback);
  }

  init() {
    toggleBluetoothConnection();
  }

  final _userService = UserService();
  final _dialogService = locator<DialogService>();
  final _sharedPreference = locator<SharedPreferences>();

  final StreamController<double> _dataStreamController = StreamController<double>();
  StreamController<double> get dataStreamController => _dataStreamController;
  StreamSubscription<double>? dataStreamSubscription;

  final TextEditingController? controller = TextEditingController(text: '');

  String? _area;
  String? _customerId;
  String? _name;
  String? get area => _area ?? 'Malumachampatti';
  DateTime now = DateTime.now();
  final String _address = '00:22:09:01:4C:30';
  String? _weightData;

  TextInputType? keyboardType;
  // final _controller = TextEditingController();
  // TextEditingController? get controller => _controller;

  BluetoothConnection? _connection;

  String? get name => _name;
  String get formattedTime => DateFormat.jm().format(now);
  String get session => DateFormat('a').format(now);
  String get date => DateFormat('dd-MM-yyyy').format(now);
  String? get customerId => _customerId;
  String get address => _address;

  String? get weightData => _weightData;

  bool isBluetoothConnected = false;
  bool? _isPaused;
  bool get isPaused => _isPaused = false;
  bool? isButtonEnabled = true;

  final FocusNode focusNode = FocusNode();

// Function to toggle the Bluetooth connection state
  void toggleBluetoothConnection() async {
    if (isBluetoothConnected) {
      // If already connected, disconnect
      _connection?.finish();
      print('Disconnecting by user');
    } else {
      // If not connected, establish a new connection
      _connection = await BluetoothConnection.toAddress(address);

      _connection?.input?.listen((Uint8List data) {
        if (isBluetoothConnected) {
          String decodedData = utf8.decode(data);
          print('Data incoming: $decodedData');

          // Extract only numeric values from the data
          List<double> numericValues = extractFirstDouble(decodedData);
          _weightData = numericValues.join(', ');
          // Add each numeric value to the stream
          for (double value in numericValues) {
            _dataStreamController.add(value);
          }

          _connection?.output.add(data); // Sending data

          if (decodedData.contains('!')) {
            _connection?.finish(); // Closing connection
            print('Disconnecting by local host');
            isBluetoothConnected = false;
          }
        }
      }).onDone(() {
        print('Disconnected by remote request');
        isBluetoothConnected = false;
        _dataStreamController.add(0.0);
      });

      print('Connecting by user');
      isBluetoothConnected = true;
    }
    // startDataStream();

    notifyListeners();
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
    _sharedPreference.setString('weightData', weightData!);
  }

  Future<void> clearValueFromSharedPreferences() async {
    notifyListeners();
    String keyToRemove = "weightData";
    _sharedPreference.remove(keyToRemove);
  }

  Future<void> submitData() async {
    notifyListeners();
    var user = User();
    user.time = now.toIso8601String(); // formattedTime;
    user.session = session;
    user.customerId = customerId!;
    user.dateTime = date;
    user.weight = weightData.toString();
    var result = await _userService.saveUser(user);
    isButtonEnabled = true;
    // pauseDataStream();
    notifyListeners();
    
    // showErrDialog('${weightData.toString()} Liter is Recived from $customerId');
  }

  void setCustomerId(String customerId) {
    _customerId = customerId;
    notifyListeners();
  }

  void showErrDialog(String message) {
    _dialogService.showCustomDialog(variant: DialogType.error, title: "Message", description: message);
  }

  void goBack(context) {
    disconnectBluetooth();
    notifyListeners();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeView(),
      ),
    );
  }

  void disconnectBluetooth() {
    if (isBluetoothConnected) {
      _connection?.finish();
      print('Disconnecting by dispose');
      isBluetoothConnected = false;
    }
  }

 

  void pauseDataStream() {
    dataStreamSubscription?.pause();
  }

  void resumeDataStream() {
    dataStreamSubscription?.resume();
  }

  @override
  void dispose() {
    dataStreamController.close();
    dataStreamSubscription?.cancel();
  }

  void buton() {
    // pauseDataStream();
    isButtonEnabled = true;
    notifyListeners();
  }

  void backSpace() {
    notifyListeners();
    controller!.text = controller!.text.substring(0, controller!.text.length - 1);
  }
}
// init() async {
//     _connection = await BluetoothConnection.toAddress(address);

//     _connection?.input?.listen((Uint8List data) {
//       // String newData = ascii.decode(data);
//       // _weightData = _weightData != null ? '$_weightData$newData' : newData;
//       if (data != null) {
//         _weightData = ascii.decode(data);
//         print('Data incoming:${ascii.decode(data)}');

//         // print('Data incoming:$newData');
//         notifyListeners();

//         _connection?.output.add(data); // Sending data

//         if (ascii.decode(data).contains('!')) {
//           _connection?.finish(); // Closing connection
//           print('Disconnecting by local host');
//         }
//       } else {
//         return;
//       }
//     }).onDone(() {
//       print('Disconnected by remote request');
//     });
//   }

//   double? extractFirstDouble(String? input) {
//     // Define a regular expression pattern for extracting a double value
//     RegExp regex = RegExp(r'(\d+\.\d+)');

//     if (input == null) {
//       return 0.0;
//     }

//     // Extract the first match from the input string
//     Match? match = regex.firstMatch(input);

//     // Check if a match is found
//     if (match != null) {
//       // Extract and parse the matched double value
//       String doubleString = match.group(1)!;
//       return double.parse(doubleString);
//     } else {
//       // No match found
//       return 0.00;
//     }
//   }
