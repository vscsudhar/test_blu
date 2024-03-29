import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_blu/app/permission_service.dart';
import 'package:test_blu/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:test_blu/ui/views/home/home_view.dart';
import 'package:test_blu/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:test_blu/ui/views/test_page/test_page_view.dart';
import 'package:test_blu/services/user_service.dart';
import 'package:test_blu/ui/views/data_view/data_view_view.dart';
import 'package:test_blu/ui/views/weight/weight_view.dart';
import 'package:test_blu/ui/views/locatio_id/locatio_id_view.dart';
import 'package:test_blu/ui/views/login/login_view.dart';
import 'package:test_blu/services/api_service.dart';
import 'package:test_blu/ui/views/thermal_print/thermal_print_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: TestPageView),
    MaterialRoute(page: DataViewView),
    MaterialRoute(page: WeightView),
    MaterialRoute(page: LocatioIdView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: ThermalPrintView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: PermissionService),
    Presolve(
        classType: SharedPreferences,
        presolveUsing: SharedPreferences.getInstance),

    LazySingleton(classType: UserService),
    LazySingleton(classType: ApiService, resolveUsing: ApiService.init),
// @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  // dialogs: [
  //   StackedDialog(classType: InfoAlertDialog),
  // @stacked-dialog
  // ],
)
class App {}
