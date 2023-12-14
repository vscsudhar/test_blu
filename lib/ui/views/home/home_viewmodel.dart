import 'package:flutter/material.dart';
import 'package:test_blu/app/app.locator.dart';
import 'package:test_blu/app/permission_service.dart';
import 'package:test_blu/core/mixin.dart';
import 'package:stacked/stacked.dart';
import 'package:thermal_printer/thermal_printer.dart';

class HomeViewModel extends BaseViewModel with NavigationMixin {
  HomeViewModel() {
    _permissionService.requestBlePermission();
  }

  var printerManager = PrinterManager.instance;

  final PermissionService _permissionService = locator<PermissionService>();

  final controller = TextEditingController();

  final FocusNode focusNode = FocusNode();

  void weightPage() {
    goToWeight();
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

  void scan() {
    var devices = [];
    scan(PrinterType type, {bool isBle = false}) {
      // Find printers
      PrinterManager.instance.discovery(type: type, isBle: isBle).listen((device) {
        devices.add(device);
      });
    }
  }

  _sendBytesToPrint(List<int> bytes, PrinterType type) async {
    PrinterManager.instance.send(type: type, bytes: bytes);
  }

  _connectDevice(PrinterDevice selectedPrinter, PrinterType type, {bool reconnect = false, bool isBle = false, String? ipAddress}) async {
    switch (type) {
      // only windows and android
      case PrinterType.usb:
        await PrinterManager.instance.connect(type: type, model: UsbPrinterInput(name: selectedPrinter.name, productId: selectedPrinter.productId, vendorId: selectedPrinter.vendorId));
        break;
      // only iOS and android
      case PrinterType.bluetooth:
        await PrinterManager.instance.connect(type: type, model: BluetoothPrinterInput(name: selectedPrinter.name, address: selectedPrinter.address!, isBle: isBle, autoConnect: reconnect));
        break;
      case PrinterType.network:
        await PrinterManager.instance.connect(type: type, model: TcpPrinterInput(ipAddress: ipAddress ?? selectedPrinter.address!));
        break;
      default:
    }
  }
}
