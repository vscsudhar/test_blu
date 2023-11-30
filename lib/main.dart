import 'package:flutter/material.dart';
import 'package:test_blu/app/app.bottomsheets.dart';
import 'package:test_blu/app/app.locator.dart';
import 'package:test_blu/app/app.router.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:test_blu/ui/setup_dialog_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  setupDialogUi();
  setupBottomSheetUi();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.startupView,
      onGenerateRoute: StackedRouter().onGenerateRoute,
      navigatorKey: StackedService.navigatorKey,
      navigatorObservers: [
        StackedService.routeObserver,
      ],
    );
  }
}
