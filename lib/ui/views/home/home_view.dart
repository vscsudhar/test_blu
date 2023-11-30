import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:test_blu/ui/common/shared/styles.dart';
import 'package:test_blu/ui/common/widgets/box.dart';
import 'package:test_blu/ui/views/weight/weight_view.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    TextEditingController controller;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Weight Scale App'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: defaultPadding14,
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RawKeyboardListener(
                      focusNode: viewModel.focusNode,
                      onKey: (RawKeyEvent event) {
                        if (event is RawKeyDownEvent) {
                          if (event.logicalKey == LogicalKeyboardKey.f1) {
                            viewModel.weightPage();
                          } else if (event.logicalKey == LogicalKeyboardKey.f2) {
                            viewModel.dataPage();
                          }
                        }
                      },
                      child: Box(
                          onTap: () => viewModel.goToWeight(),
                          boxColor: appChambray,
                          margin: zeroPadding,
                          padding: defaultPadding12,
                          child: Text(
                            'Weight',
                            style: fontFamilyBold.size18,
                            textAlign: TextAlign.center,
                          )),
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
                          'data',
                          style: fontFamilyBold.size18,
                          textAlign: TextAlign.center,
                        )),
                  ),
                ],
              ),
              verticalSpacing16,

              // Box(
              //     onTap: () => viewModel.goToTest(),
              //     boxColor: appChambray,
              //     margin: zeroPadding,
              //     padding: defaultPadding12,
              //     child: Text(
              //       'weight1',
              //       style: fontFamilyBold.size18,
              //       textAlign: TextAlign.center,
              //     )),
            ]),
          ),
        ));
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();
}
