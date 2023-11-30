import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:test_blu/ui/common/shared/styles.dart';
import 'package:test_blu/ui/common/ui_helpers.dart';
import 'package:test_blu/ui/common/widgets/button.dart';
import 'package:test_blu/ui/common/widgets/text_field2.dart';
import 'package:test_blu/ui/views/test_page/test_page_viewmodel.dart';

class TestPageView extends StackedView<TestPageViewModel> {
  const TestPageView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, TestPageViewModel viewModel, Widget? child) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          viewModel.area.toString(),
          style: const TextStyle(fontSize: 22),
        ),
        centerTitle: true,
        actions: const [
          //  ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: viewModel.isBluetoothConnected ? Colors.red : Colors.green,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(10.0),
          //       ),
          //     ),
          //     onPressed: () {
          //       viewModel.init();
          //     },
          //     child: Text(viewModel.isBluetoothConnected ? 'Disconnect' : 'Connect'),
          //   ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              verticalSpacing20,
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
              verticalSpaceLarge,
              Center(
                child: Text(
                  viewModel.weightData.join(),
                  style: fontFamilyBold.copyWith(fontSize: 44),
                ),
              ),
              verticalSpaceLarge,
              verticalSpaceLarge,
              verticalSpaceMedium,
              Visibility(
                visible: viewModel.isEnabled ?? false,
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      verticalSpacing20,
                      TextField2(
                        textAlign: TextAlign.center,
                        hintText: 'Enter Customer Code',
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Customer Id is required';
                          } else if (val.length < 5) {
                            return 'Customer Id must be at least 5 characters long';
                          }
                          return null;
                        },
                        onSaved: (id) => viewModel.setCustomerId(id.toString()),
                      ),
                      verticalSpaceMedium,
                      verticalSpacing20,
                      Button(
                          name: 'Submit',
                          onTap: () {
                            if (formKey.currentState?.validate() ?? false) {
                              formKey.currentState?.save();
                              viewModel.submitData();
                              // formKey.currentState?.reset();
                            }
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  TestPageViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      TestPageViewModel();
}
