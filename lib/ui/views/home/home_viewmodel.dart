import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_blu/app/app.locator.dart';
import 'package:test_blu/app/permission_service.dart';
import 'package:test_blu/core/mixin.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel with NavigationMixin {
  HomeViewModel() {
    _permissionService.requestBlePermission();
    notifyListeners();
    print('object');
    init();
  }

  init() {
    startDiscovery();
  }

  final PermissionService _permissionService = locator<PermissionService>();
  final _sharedPreference = locator<SharedPreferences>();

  final controller = TextEditingController();

  final FocusNode focusNode = FocusNode();

  bool? isPrintButtonVisible = false;

  String? get printerDevice => _sharedPreference.getString('printerDevice') ?? '';
  String? get printerDeviceName => _sharedPreference.getString('printerName') ?? '';
  String? get weightDevice => _sharedPreference.getString('weightDevice') ?? '';

  BluetoothConnection? _printerConnection;
  BluetoothConnection? get printerConnection => _printerConnection;

  List<BluetoothDevice> devices = [];

  void weightPage() {
    goToWeight(isPrintButtonVisible!);
    notifyListeners();
  }

  void dataPage() {
    goToDataView();
    notifyListeners();
  }

  void export() {
    goToTest();
    notifyListeners();
  }

  void location() {
    goToLogin();
    notifyListeners();
  }

  Future<void> startDiscovery() async {
    try {
      FlutterBluetoothSerial.instance.startDiscovery().listen((result) {
        notifyListeners();
        if (printerDevice!.contains(result.device.address)) {
          isPrintButtonVisible = true;
        }
      });
    } catch (ex) {
      print('Error starting discovery: $ex');
    }
  }
}
