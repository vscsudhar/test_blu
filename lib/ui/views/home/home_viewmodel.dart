import 'package:flutter/material.dart';
import 'package:test_blu/core/mixin.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel with NavigationMixin {
  HomeViewModel();

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

  // final PermissionService _permissionService = locator<PermissionService>();
}
