import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:test_blu/app/app.locator.dart';
import 'package:test_blu/app/permission_service.dart';
import 'package:test_blu/core/enum/dialog_type.dart';
import 'package:test_blu/core/mixin.dart';
import 'package:test_blu/core/model/user.model.dart';
import 'package:test_blu/services/user_service.dart';
import 'package:flutter/services.dart';
import 'package:usb_serial/usb_serial.dart';

class WeightViewModel extends BaseViewModel with NavigationMixin {
  WeightViewModel(this._isPrintButtonVisible) {
    init();
  }

  init() async {
    toggleBluetoothConnection();
    if (isPrintButtonVisible != false) {
      await connectToPrinter();
    }
    notifyListeners();
  }

  bool? _isPrintButtonVisible;
  bool? _isBluetoothConnected = false;

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
  DateTime now = DateTime.now();
  final String _address = '00:22:09:01:4C:30';
  String? _weightData;
  String? get locationId => _sharedPreference.getString('locationId') ?? '01';
  String? get weightDevice => _sharedPreference.getString('weightDevice') ?? '';
  String? get printerDevice => _sharedPreference.getString('printerDevice') ?? '';
  String? get printerDeviceName => _sharedPreference.getString('printerName') ?? '';

  TextInputType? keyboardType;
  // final _controller = TextEditingController();
  // TextEditingController? get controller => _controller;

  BluetoothConnection? _connection;
  BluetoothConnection? _printerConnection;
  //UUID=c8d1e6e6-dcd1-44b6-a923-35b4b1196a5a

  String? get name => _name;
  String get formattedTime => DateFormat.jm().format(now);
  String get formattedTimeOnly => DateFormat('h:mm a').format(now);
  String get session => DateFormat('a').format(now);
  String get date => DateFormat('dd-MM-yyyy').format(now);
  String? get customerId => _customerId;
  String? get address => weightDevice;
  double lastvalue = 0;

  BluetoothConnection? get connection => _connection;
  BluetoothConnection? get printerConnection => _printerConnection;
  bool? get isPrintButtonVisible => _isPrintButtonVisible;
  bool isConnected = false;

  String? get weightData => _weightData;

  bool? get isBluetoothConnected => _isBluetoothConnected;
  bool? isButtonEnabled = true;

  final FocusNode focusNode = FocusNode();
  final PermissionService _permissionService = locator<PermissionService>();

// Function to toggle the Bluetooth connection state
  Future<void> toggleBluetoothConnection() async {
    final Stopwatch stopwatch = Stopwatch()..start();

    if (isBluetoothConnected!) {
      // If already connected, disconnect
      _connection?.finish();
      print('Disconnecting by user');
    } else {
      // If not connected, establish a new connection
      stopwatch.reset();
      _connection = await BluetoothConnection.toAddress(address);

      _connection?.input?.listen((Uint8List data) {
        if (isBluetoothConnected!) {
          String decodedData = utf8.decode(data);
          print('Data incoming: $decodedData');

          // Extract only numeric values from the data
          List<double> numericValues = extractFirstDouble(decodedData);
          List<double> numericValues1 = extractFirstDouble(decodedData);
          print('Data : $numericValues');

          // if (numericValues.isNotEmpty && numericValues1.length > 1&& numericValues[0] == numericValues1[0])
          // {
          // _weightData = numericValues[0].toString();
          // Add each numeric value to the stream
          for (double value in numericValues) {
            _dataStreamController.add(value);
            _weightData = value.toString();
          }
          // }

          _connection?.output.add(data); // Sending data

          if (decodedData.contains('!')) {
            _connection?.finish(); // Closing connection
            print('Disconnecting by local host');
            _isBluetoothConnected = false;
          }
        }
      }).onDone(() {
        print('Disconnected by remote request');
        _isBluetoothConnected = false;
        _dataStreamController.add(0.0);
      });

      print('Connecting by user');
      _isBluetoothConnected = true;
    }
    // startDataStream();
    notifyListeners();
  }

  List<double> extractFirstDouble(String input) {
    RegExp regex = RegExp(r'([+-]?\d*\.?\d+)');
    List<double> numericValues = [];
    print(numericValues.length);

    // Extract the numeric values from the input string
    Iterable<Match> matches = regex.allMatches(input);
    for (Match match in matches) {
      String numericString = match.group(1)!;
      print(numericValues.length);
      String numericString1 = match.group(0)!;
      if (numericString == numericString1) {
        double numericValue = double.parse(numericString);
        numericValues.add(numericValue);
      }
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
    user.customerId = customerId! ?? '123';
    user.dateTime = date;
    user.center = locationId;
    user.weight = weightData.toString() ?? '3.00';
    var result = await _userService.saveUser(user);
    isButtonEnabled = true;
    await sendPrintCommands();
    notifyListeners();
  }

  void setCustomerId(String customerId) {
    _customerId = customerId;
    notifyListeners();
  }

  void showErrDialog(String message) {
    _dialogService.showCustomDialog(variant: DialogType.error, title: "Message", description: message);
  }

  void goBack() {
    disconnectBluetooth();
    disconnectPrinter();
    notifyListeners();
    willpop();
  }

  void disconnectBluetooth() {
    notifyListeners();
    if (isBluetoothConnected!) {
      _connection?.finish();
      dataStreamController.close();
      _connection = null;
      print('Disconnecting by dispose');
      _isBluetoothConnected = false;
    }
  }

  Future<void> disconnectPrinter() async {
    await _printerConnection?.close();
    notifyListeners();
    _printerConnection = null;
    _isPrintButtonVisible = false;

    print('Disconnected from the printer.');
  }

  Future<void> connectToPrinter() async {
    String? staticDeviceName = printerDeviceName;
    String? staticDeviceAddress = printerDevice;

    BluetoothDevice? selectedDevice;
    List<BluetoothDevice> devices = await FlutterBluetoothSerial.instance.getBondedDevices();

    for (BluetoothDevice device in devices) {
      if (device.name == staticDeviceName || device.address == staticDeviceAddress) {
        selectedDevice = device;
        break;
      }
    }

    if (selectedDevice != null) {
      BluetoothConnection.toAddress(selectedDevice.address).then((BluetoothConnection newConnection) {
        notifyListeners();
        _printerConnection = newConnection;
        _isPrintButtonVisible = true;
        print('Connected to the printer.');
      }).catchError((dynamic error) {
        print('Error connecting to printer: $error');
      });
    } else {
      print('Printer not found in the list of bonded devices.');
    }
  }

  String generateFontSizeCommand(int size) {
    String fontSizeCommand = '\x1B\x21'; // ESC !

    fontSizeCommand += String.fromCharCode(size);

    return fontSizeCommand;
  }

  String header2 = 'Cowma Center';
  String subHeader2 = 'collection';

  Future<void> sendPrintCommands() async {
    String header1 = generateFontSizeCommand(20);
    String subheader1 = generateFontSizeCommand(16);
    String all = generateFontSizeCommand(12);
    int spacesForAlignment = 12;
    int spacesForAlignment1 = 6;

    String spaces = ' ' * spacesForAlignment;
    String spaces1 = ' ' * spacesForAlignment1;

    String header = '$header1$header2-$locationId';
    String subheader = '$subheader1$customerId';
    String dateSession = '$all$date $formattedTimeOnly';
    String weight1 = '$all$spaces$weightData';
    String customerId1 = '$all${'Member Code:$subheader$all$spaces1 COWMILK'}';

    String centerCommand = '\x1B\x61\x01';

    String printCommand = '$centerCommand$header\n............................\n$customerId1\n\n$dateSession\n\nWeight:$weight1\n\n$centerCommand${'Thank you'}\n\n\n';

    _printerConnection!.output.add(Uint8List.fromList(printCommand.codeUnits));
    await _printerConnection!.output.allSent;
    await Future.delayed(const Duration(seconds: 2));
    print('Print command sent to the printer.');
  }

  Future<void> connectToUSBPrinter() async {
    List<UsbDevice> devices = await UsbSerial.listDevices();

    if (devices.isEmpty) {
      print('No USB devices found.');
      return;
    }

    UsbPort? port = await devices[1].create();

    if (await port!.open()) {
      print('Connected to USB Printer');

      String textToPrint = "Hello, Printer!\n";
      List<int> data = utf8.encode(textToPrint);

      port.write(Uint8List.fromList(data));

      await port.close();
    } else {
      print('Failed to connect to USB Printer');
    }
  }

  void willpop() {
    notifyListeners();
    goToHome();
    // Navigator.push(context, MaterialPageRoute(builder: (context) => const HomeView()));
  }

  List<BluetoothDevice> devices = [];
  Future<void> startDiscovery() async {
    try {
      FlutterBluetoothSerial.instance.startDiscovery().listen((result) {
        notifyListeners();
        if (printerDevice!.contains(result.device.address)) {
          _isPrintButtonVisible = true;
        }
      });
    } catch (ex) {
      print('Error starting discovery: $ex');
    }
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
