
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:test_blu/app/app.locator.dart';
import 'package:test_blu/core/enum/dialog_type.dart';
import 'package:test_blu/core/mixin.dart';
import 'package:test_blu/core/model/users_data_model.dart';
import 'package:test_blu/services/user_service.dart';
import 'package:test_blu/ui/views/home/home_view.dart';

class LoginViewModel extends BaseViewModel with NavigationMixin {
  LoginViewModel();

  final _userService = UserService();
  final _dialogService = locator<DialogService>();

  DateTime now = DateTime.now();
  String? _userName;
  String? _passWord;

  String? get userName => _userName;
  String? get password => _passWord;

  Future<void> submitData() async {
    notifyListeners();
    var user = UserData();
    user.dateTime = now.toIso8601String(); // formattedTime;
    user.userName = userName;
    user.password = password;
    var result = await _userService.saveUserData(user);
    goToLogin();
    notifyListeners();
  }

  Future<void> loginData() async {
    var userData = await _userService.checkUserData(userName, password);
    notifyListeners();
    if (userData != null && userData.isNotEmpty) {
      print('Login successful!');
      notifyListeners();
      goToLocation();
    } else {
      print('Invalid credentials. Login failed.');
      showErrDialog('Invalid credentials. Login failed.');
    }
  }

  void setUserName(String userName) {
    _userName = userName;
    notifyListeners();
  }

  void setUserPass(String passWord) {
    _passWord = passWord;
    notifyListeners();
  }

   void goBack(context) {
    notifyListeners();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const HomeView(),
      ),
    );
  }

  void showErrDialog(String message) {
    _dialogService.showCustomDialog(variant: DialogType.error, title: "Message", description: message);
  }
}
