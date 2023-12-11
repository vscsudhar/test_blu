import 'package:flutter/material.dart';
import 'package:test_blu/app/app.locator.dart';
import 'package:test_blu/app/permission_service.dart';
import 'package:test_blu/core/mixin.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel with NavigationMixin {
  HomeViewModel() {
    _permissionService.requestBlePermission();
  }

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

  final PermissionService _permissionService = locator<PermissionService>();
}
