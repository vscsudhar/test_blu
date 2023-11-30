import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:test_blu/ui/common/shared/styles.dart';
import 'package:test_blu/ui/common/ui_helpers.dart';
import 'package:test_blu/ui/views/weight/weight_viewmodel.dart';

class Stream extends StackedView<WeightViewModel> {
  const Stream({super.key});

  @override
  Widget builder(
    BuildContext context,
    WeightViewModel viewModel,
    Widget? child,
  ) {
    return Center(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Text(
                    viewModel.date,
                    style: fontFamilyMedium.size30,
                  ),
                  horizontalSpaceLarge,
                  Text(
                    viewModel.session,
                    style: fontFamilyMedium.size30,
                  ),
                ],
              ),
            ],
          ),
          verticalSpacing20,
          Focus(
            focusNode: FocusNode(canRequestFocus: true, descendantsAreFocusable: true),
            child: StreamBuilder<double>(
              stream: viewModel.dataStreamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  double? data = snapshot.data;
                  if (data == 0.0) {
                    viewModel.isButtonEnabled = false;
                  }

                  // viewModel.isButtonEnabled = (data == 0.00);
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Text(
                          viewModel.isButtonEnabled! ? data.toString() : '$data',
                          style: const TextStyle(fontSize: 40),
                        ),
                      ),
                      verticalSpacing20,
                    ],
                  );
                } else {
                  return const Text(
                    'Waiting for data...\n Click to connect',
                    style: TextStyle(fontSize: 16),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  WeightViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      WeightViewModel();
}
