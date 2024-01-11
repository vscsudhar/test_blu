import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:test_blu/app/app.locator.dart';
import 'package:test_blu/core/mixin.dart';

class LocatioIdViewModel extends BaseViewModel with NavigationMixin {
  LocatioIdViewModel() {
    getBondedDevices();
  }

  final _sharedPreference = locator<SharedPreferences>();

  List<BluetoothDevice> bondedDevices = [];
  BluetoothDevice? selectedDevice;
  BluetoothDevice? selectedPrinter;

  String? _weightDevice;
  String? _printerDevice;

  String? _locationId;
  String? get locationId => _sharedPreference.getString('locationId') ?? "01";

  void selectLocation(String locationId) {
    notifyListeners();
    _locationId = locationId;
  }

  void selectweightValue(weightDevice) {
    notifyListeners();
    _weightDevice = weightDevice;
  }

  void selectPrinterValue(printerDevice) {
    notifyListeners();
    _printerDevice = printerDevice;
  }

  void submitAction() {
    notifyListeners();
    _sharedPreference.setString('locationId', _locationId.toString());
    _sharedPreference.setString('weightDevice', selectedDevice!.address.toString());
    print(selectedDevice!.address.toString());
    _sharedPreference.setString('printerDevice', selectedPrinter!.address.toString());
    print(selectedPrinter!.address);
    _sharedPreference.setString('printerName', selectedPrinter!.name.toString());
    print(selectedPrinter!.name);
    goToHome();
  }

  void goBack(context) {
    notifyListeners();
    goToBack();
  }

  void onChangeWeight(newValue) {
    notifyListeners();
    selectedDevice = newValue;
  }

  void onChangePrinter(newValue) {
    notifyListeners();
    selectedPrinter = newValue;
  }

  void getBondedDevices() async {
    try {
      List<BluetoothDevice> devices = await FlutterBluetoothSerial.instance.getBondedDevices();
      bondedDevices = devices;
      notifyListeners();
      selectedDevice = devices.isNotEmpty ? devices[0] : null;
    } catch (error) {
      print("Error getting bonded devices: $error");
    }
  }
}
