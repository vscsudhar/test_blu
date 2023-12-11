import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:test_blu/app/app.locator.dart';
import 'package:test_blu/core/mixin.dart';

class LocatioIdViewModel extends BaseViewModel with NavigationMixin {
  LocatioIdViewModel();

  final _sharedPreference = locator<SharedPreferences>();

  String? _locationId;
  String? get locationId =>
      _sharedPreference.getString('locationId') ?? "MalumachamPatti";

  void selectLocation(String locationId) {
    notifyListeners();
    _locationId = locationId;
  }

  void submitAction() {
    notifyListeners();
    _sharedPreference.setString('locationId', _locationId.toString());
  }
}
