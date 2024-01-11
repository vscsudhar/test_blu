import 'dart:io';

import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:location/location.dart' hide PermissionStatus;
import 'package:test_blu/app/app.locator.dart';

class PermissionService {
  PermissionService() {
    _dialogService = locator<DialogService>();
  }
  late DialogService _dialogService;

  Location? _location;

  Future<bool> requestBlePermission() async {
    List<Permission> permissions = [];
    // final result = (await FlutterBluePlus.instance.isOn);
    // final result1 = await FlutterBluePlus.instance.turnOn();
    // print(result);
    // print(result1);
    if (Platform.isIOS) {
      permissions.addAll([Permission.location, Permission.bluetooth]);
    } else {
      permissions.addAll([
        Permission.location,
        Permission.bluetoothConnect,
        Permission.bluetoothScan
      ]);
    }
    Map<Permission, PermissionStatus> permissionsStatus =
        await permissions.request();

    _location ??= Location();
    bool locationServiceEnabled = false;
    locationServiceEnabled = await _location!.serviceEnabled();
    if (!locationServiceEnabled) {
      locationServiceEnabled = await _location!.requestService();
    }

    bool isBluetoothenabled = false;
    await BluetoothEnable.enableBluetooth.then((result) {
      if (result == "true") {
        isBluetoothenabled = true;
      } else if (result == "false") {
        isBluetoothenabled = false;
      }
    }).catchError((e) {});

    var isAllPermissionsEnabled =
        permissionsStatus.values.every((permission) => permission.isGranted) &&
            isBluetoothenabled &&
            locationServiceEnabled;
    // var isAllPermissionsEnabled = statuses.values.every((permission) => permission.isGranted);
    if (!isAllPermissionsEnabled) {
      _showDialog(
          "Please make sure your device's location and Bluetooth are turned on and the app has been given permission to access those services.");
      return false;
    }

    return isAllPermissionsEnabled;
  }

  Future _showDialog(String description) async {
    final DialogResponse? dialogResponse =
        await _dialogService.showConfirmationDialog(
      title: 'Access Denied',
      description: description,
      confirmationTitle: 'Settings',
      cancelTitle: 'Cancel',
    );
    // if (dialogResponse?.confirmed ?? false) openAppSettings();
  }

  void requestLocationPermissions() {}
}
