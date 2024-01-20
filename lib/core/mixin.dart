import 'package:stacked_services/stacked_services.dart';
import 'package:test_blu/app/app.locator.dart';
import 'package:test_blu/app/app.router.dart';

mixin NavigationMixin {
  final NavigationService _navigationService = locator<NavigationService>();

  void goToHome() => _navigationService.clearStackAndShow(Routes.homeView);
  void goToTest() => _navigationService.navigateTo(Routes.testPageView);
  void goToDataView() => _navigationService.navigateTo(Routes.dataViewView);
  void goToWeight(bool isPrintButtonVisible) => _navigationService.clearStackAndShow(Routes.weightView, arguments: WeightViewArguments(isPrintButtonVisible: isPrintButtonVisible));
  void goToLocation() => _navigationService.navigateTo(Routes.locatioIdView);
  void goToLogin() => _navigationService.navigateTo(Routes.loginView);
  void goToThermalPrint() => _navigationService.navigateTo(Routes.thermalPrintView);
  void goToBack() => _navigationService.popRepeated(0);
}
