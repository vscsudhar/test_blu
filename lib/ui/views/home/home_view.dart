import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:test_blu/ui/common/shared/styles.dart';
import 'package:test_blu/ui/common/widgets/box.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return RawKeyboardListener(
      autofocus: true,
      focusNode: viewModel.focusNode,
      onKey: (RawKeyEvent event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.f1) {
            viewModel.weightPage();
          } else if (event.logicalKey == LogicalKeyboardKey.f2) {
            viewModel.dataPage();
          } else if (event.logicalKey == LogicalKeyboardKey.f3) {
            viewModel.export();
          } else if (event.logicalKey == LogicalKeyboardKey.f4) {
            viewModel.location();
          }
        }
      },
      child: Scaffold(
          body: SingleChildScrollView(
        child: Padding(
          padding: defaultPadding14,
          child: Column(children: [
            verticalSpacing40,
            Text(
              'Weight Scale',
              style: fontFamilyMedium.size26,
            ),
            verticalSpacing12,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Box(
                    onTap: () => viewModel.weightPage(),
                    boxColor: appChambray,
                    margin: zeroPadding,
                    padding: defaultPadding12,
                    child: Text(
                      'Weight',
                      style: fontFamilyBold.size18.appwhite,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                horizontalSpacing12,
                Expanded(
                  child: Box(
                      onTap: () => viewModel.goToDataView(),
                      boxColor: appChambray,
                      margin: zeroPadding,
                      padding: defaultPadding12,
                      child: Text(
                        'Data',
                        style: fontFamilyBold.size18.appwhite,
                        textAlign: TextAlign.center,
                      )),
                ),
              ],
            ),
            verticalSpacing10,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Box(
                    onTap: () => viewModel.goToTest(),
                    boxColor: appChambray,
                    margin: zeroPadding,
                    padding: defaultPadding12,
                    child: Text(
                      'Export',
                      style: fontFamilyBold.size18.appwhite,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                horizontalSpacing12,
                Expanded(
                  child: Box(
                      onTap: () => viewModel.goToLogin(),
                      boxColor: appChambray,
                      margin: zeroPadding,
                      padding: defaultPadding12,
                      child: Text(
                        'Center Id',
                        style: fontFamilyBold.size18.appwhite,
                        textAlign: TextAlign.center,
                      )),
                ),
              ],
            ),
            verticalSpacing16,
            // Focus(
            //   onKey: (node, event) {
            //     if (event.logicalKey == LogicalKeyboardKey.f5) {
            //       viewModel.goToWeight();
            //       return KeyEventResult.handled;
            //     }
            //     return KeyEventResult.ignored;
            //   },
            //   child:
            // Box(
            //     onTap: () => viewModel.goToThermalPrint(),
            //     boxColor: appChambray,
            //     margin: zeroPadding,
            //     padding: defaultPadding12,
            //     child: Text(
            //       'print',
            //       style: fontFamilyBold.size18,
            //       textAlign: TextAlign.center,
            //     )),
            // ),
          ]),
        ),
      )),
    );
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();
}
