import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:test_blu/app/app.locator.dart';
import 'package:test_blu/core/mixin.dart';
import 'package:test_blu/core/model/fileUpload_model.dart';
import 'package:test_blu/services/api_service.dart';
import 'package:http/http.dart' as http;

class ThermalPrintViewModel extends BaseViewModel with NavigationMixin {
  ThermalPrintViewModel() {
    connectToPrinter();
  }

  BluetoothConnection? _connection;
  BluetoothConnection? get connection => _connection;
  bool isPrintButtonVisible = false;
  bool isConnected = false;

  Dio? dio;
  late FileUploadResponse? _fileUploadResponse;
  final _apiService = ApiService.init();

  final _sharedPreference = locator<SharedPreferences>();

  final StreamController<double> _dataStreamController = StreamController<double>();
  StreamController<double> get dataStreamController => _dataStreamController;
  StreamSubscription<double>? dataStreamSubscription;

  init() {
    weihtScale();
  }

  Future<void> connectToPrinter() async {
    String staticDeviceName = "MPT-II";
    String staticDeviceAddress = "66:32:77:1C:32:07";

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
        _connection = newConnection;
        isPrintButtonVisible = true;

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

    String header = '$header1$header2';
    String subheader = subheader1;
    String dateSession = all;
    String weight1 = '$all$spaces';
    String customerId1 = '$all${'Member Code:$subheader$all$spaces1 COWMILK'}';

    String centerCommand = '\x1B\x61\x01';

    String printCommand = '$centerCommand$header\n............................\n$customerId1\n\n$dateSession\n\nWeight:$weight1\n\n$centerCommand${'Thank you'}\n\n\n';

    _connection!.output.add(Uint8List.fromList(printCommand.codeUnits));
    await _connection!.output.allSent;
    await Future.delayed(const Duration(seconds: 2));
    print('Print command sent to the printer.');
  }

  Future<void> disconnectPrinter() async {
    await _connection?.finish();
    notifyListeners();
    _connection = null;
    isPrintButtonVisible = false;

    print('Disconnected from the printer.');
  }

  PlatformFile? _file;
  PlatformFile? get file => _file;

  Future<void> uploadFile1() async {
    var dio = Dio();

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path ?? '');

      String fileName = file.path.split('/').last;

      String filePath = file.path;

      FormData data = FormData.fromMap({
        // 'key': '0963360015cf3b081b5bf1cf7867a707',
        'File': await MultipartFile.fromFile(filePath, filename: fileName),
        'CreatedOn': DateTime.now().toIso8601String(),
        'CreatedBy': 'user',
      });

      print(data);
      print(data.toString());

      var response = await dio.post('https://47f0-2401-4900-7b91-7f23-fc96-2200-e19c-3e87.ngrok-free.app/Api/CenterData/File', data: data, onSendProgress: (int sent, int total) {
        print('$sent , $total');
      });

      print(response.data);
    } else {
      print('result is null');
    }
  }

  String? get weightDevice => _sharedPreference.getString('weightDevice') ?? '';
  String? get address => weightDevice;
  String? _weight;
  String? get weight => _weight;

  Future<void> weihtScale() async {
    try {
      BluetoothConnection connection = await BluetoothConnection.toAddress(address);
      print('Connected to the device');

      connection.input?.listen((Uint8List data) {
        String datas = ascii.decode(data);
        print('Data incoming: $datas');

        List<double> numericValues = datas.codeUnits.map((value) => value.toDouble()).toList();

        for (double value in numericValues) {
          _dataStreamController.add(value);
        }

        if (datas.contains('!')) {
          connection.finish(); // Closing connection
          print('Disconnecting by local host');
        }
      }).onDone(() {
        print('Disconnected by remote request');
      });
    } catch (exception) {
      print('Cannot connect, exception occurred');
    }
  }

  List<BluetoothDevice> devices = [];
  Future<void> startDiscovery() async {
    try {
      FlutterBluetoothSerial.instance.startDiscovery().listen((result) {
        notifyListeners();
        if (!devices.contains(result.device)) {
          devices.add(result.device);
          print(devices);
        }
      });
    } catch (ex) {
      print('Error starting discovery: $ex');
    }
  }
}
