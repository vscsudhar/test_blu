import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';
import 'package:test_blu/ui/common/shared/styles.dart';
import 'package:test_blu/ui/common/ui_helpers.dart';
import 'package:test_blu/ui/common/widgets/button.dart';
import 'package:test_blu/ui/common/widgets/circular_progress_indicator.dart';
import 'package:test_blu/ui/common/widgets/text_field2.dart';

import 'weight_viewmodel.dart';

class WeightView extends StackedView<WeightViewModel> {
  const WeightView(this._isPrintButtonVisible, {super.key});

  final bool _isPrintButtonVisible;

  static final formKey = GlobalKey<FormState>();

  @override
  Widget builder(
    BuildContext context,
    WeightViewModel viewModel,
    Widget? child,
  ) {
    // ignore: deprecated_member_use
    return !viewModel.isBusy
        ? Focus(
            focusNode: FocusNode(canRequestFocus: true, descendantsAreFocusable: true),
            autofocus: false,
            onKey: (node, event) {
              if (event.logicalKey == LogicalKeyboardKey.escape) {
                viewModel.willpop();
                return KeyEventResult.skipRemainingHandlers;
              } else if (event.logicalKey == LogicalKeyboardKey.f2) {
                viewModel.focusNode.requestFocus();
                return KeyEventResult.handled;
              }

              return KeyEventResult.ignored;
            },
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: appwhite1,
                automaticallyImplyLeading: true,
                leading: InkWell(onTap: () => viewModel.willpop(), child: const Icon(Icons.arrow_back)),
                title: Text(
                  'Center -${viewModel.locationId.toString()}',
                  style: fontFamilyBold.size30.copyWith(color: Colors.green),
                ),
                centerTitle: true,
                actions: [
                  horizontalSpacing16,
                  ElevatedButton(
                    focusNode: FocusNode(canRequestFocus: true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: viewModel.isBluetoothConnected! ? Colors.red : Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    onPressed: () async {
                      await viewModel.toggleBluetoothConnection();
                      // viewModel.notifyListeners();
                      // viewModel.focusNode.requestFocus();
                    },
                    child: Text(viewModel.isBluetoothConnected! ? 'Disconnect' : 'Connect'),
                  ),
                ],
              ),
              body: SingleChildScrollView(
                child: Center(
                  child: Padding(
                    padding: defaultPadding12,
                    child: Column(
                      children: <Widget>[
                        verticalSpacing8,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              children: [
                                Text(
                                  viewModel.date,
                                  style: fontFamilyMedium.size30, //size30
                                ),
                                horizontalSpaceLarge,
                                Text(
                                  viewModel.session,
                                  style: fontFamilyMedium.size30, //size30
                                ),
                              ],
                            ),
                          ],
                        ),
                        verticalSpacing16,
                        viewModel.isBluetoothConnected!
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    viewModel.weightData.toString(),
                                    style: fontFamilyBold.size85,
                                  ),
                                  verticalSpacing8,
                                  if ((viewModel.isButtonEnabled ?? false))
                                    Form(
                                        key: formKey,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            // SizedBox(
                                            //   height: MediaQuery.of(context).size.height * 0.3,
                                            // ),
                                            if ((viewModel.isButtonEnabled ?? false))
                                              RawKeyboardListener(
                                                  // autofocus: true,
                                                  focusNode: viewModel.focusNode,
                                                  onKey: (RawKeyEvent event) {
                                                    if (event is RawKeyDownEvent) {
                                                      if (event.logicalKey == LogicalKeyboardKey.enter || event.logicalKey == LogicalKeyboardKey.numpadEnter || event.logicalKey == LogicalKeyboardKey.space) {
                                                        if (!(double.tryParse(viewModel.weightData ?? '0.0')! <= 0.50)) {
                                                          _submithand(viewModel);
                                                        }
                                                      }
                                                      // else if (event.logicalKey == LogicalKeyboardKey.escape) {
                                                      //   viewModel.disconnectDevices();
                                                      // }
                                                      //  else if (event.logicalKey == LogicalKeyboardKey.f1) {
                                                      //   if (viewModel.isBluetoothConnected!) {
                                                      //   } else {
                                                      //     !(viewModel.isBluetoothConnected!);
                                                      //   }
                                                      // }
                                                    }
                                                  },
                                                  child: TextField2(
                                                    maxLength: 5,
                                                    style: fontFamilyMedium.copyWith(fontSize: 70),
                                                    type: TextInputType.number,
                                                    textAlign: TextAlign.center,
                                                    hintText: 'Enter Customer Code',
                                                    validator: (val) {
                                                      if (val == null || val.isEmpty) {
                                                        return 'Customer Id is required';
                                                      }
                                                      return null;
                                                    },
                                                    onSaved: (id) => viewModel.setCustomerId(id.toString()),
                                                  )
                                                  // : emptySpacing,
                                                  ),
                                            verticalSpacing10,
                                            if ((viewModel.isButtonEnabled ?? false))
                                              Button(
                                                height: 36,
                                                buttoncolor: Colors.green,
                                                name: 'Submit',
                                                onTap: () {
                                                  if ((!(double.tryParse(viewModel.weightData ?? '0.0')! <= 0.50))) {
                                                    _submithand(viewModel);
                                                  }
                                                },
                                              ),
                                          ],
                                        )),
                                  // Container(height: 40, width: 100, color: Colors.amber, child: Text(viewModel.isPrintButtonVisible.toString())),
                                ],
                              )
                            : Center(
                                child: Text(
                                  'connect Bluetooth (or) Restart Your Application',
                                  style: fontFamilyMedium.appChambray1.size30,
                                  textAlign: TextAlign.center,
                                ),
                              )
                      ],
                    ),
                  ),
                ),
              ),
            ))
        : const Center(
            child: SizedBox(
              height: 100,
              width: 100,
              child: AnimatedCircularProgressIndicator(
                color: Colors.pink,
              ),
            ),
          );
  }

  void _submithand(WeightViewModel viewModel) {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      viewModel.submitData();
      formKey.currentState?.reset();
      viewModel.focusNode.requestFocus();
    }
  }

  @override
  WeightViewModel viewModelBuilder(BuildContext context) => WeightViewModel(_isPrintButtonVisible);

  @override
  void onDispose(WeightViewModel viewModel) async {
    log('dispose Weight');
    viewModel.disconnectDevices();
    super.onDispose(viewModel);
  }
}

// if (data == 0.0) {
//   // viewModel.isButtonEnabled = true;
//   viewModel.buttondis(true);
//   // clear textField2
//   //change into background color green
//   viewModel.a = 1;
// } else if (viewModel.a == 1 && data != 0.0) {
//   viewModel.buttondis(false);
// }

// if (!viewModel.isPause) {
//   return Text(
//     '0.0',
//     style: fontFamilyMedium.size34,
//   );
// } else if (data == 0.01) {
//   viewModel.isPause = true;
// }
// ignore: unrelated_type_equality_checks

// Update the boolean variable based on the stream data
// else if (event.logicalKey == LogicalKeyboardKey.digit0 || event.logicalKey == LogicalKeyboardKey.numpad0) {
//   viewModel.controller.text += '0';
// } else if (event.logicalKey == LogicalKeyboardKey.digit1 || event.logicalKey == LogicalKeyboardKey.numpad1) {
//   viewModel.controller.text += '1';
// } else if (event.logicalKey == LogicalKeyboardKey.digit2 || event.logicalKey == LogicalKeyboardKey.numpad2) {
//   viewModel.controller.text += '2';
// } else if (event.logicalKey == LogicalKeyboardKey.digit3 || event.logicalKey == LogicalKeyboardKey.numpad3) {
//   viewModel.controller.text += '3';
// } else if (event.logicalKey == LogicalKeyboardKey.digit4 || event.logicalKey == LogicalKeyboardKey.numpad4) {
//   viewModel.controller.text += '4';
// } else if (event.logicalKey == LogicalKeyboardKey.digit5 || event.logicalKey == LogicalKeyboardKey.numpad5) {
//   viewModel.controller.text += '5';
// } else if (event.logicalKey == LogicalKeyboardKey.digit6 || event.logicalKey == LogicalKeyboardKey.numpad6) {
//   viewModel.controller.text += '6';
// } else if (event.logicalKey == LogicalKeyboardKey.digit7 || event.logicalKey == LogicalKeyboardKey.numpad7) {
//   viewModel.controller.text += '7';
// } else if (event.logicalKey == LogicalKeyboardKey.digit8 || event.logicalKey == LogicalKeyboardKey.numpad8) {
//   viewModel.controller.text += '8';
// } else if (event.logicalKey == LogicalKeyboardKey.digit9 || event.logicalKey == LogicalKeyboardKey.numpad9) {
//   viewModel.controller.text += '9';
// } else if (event.logicalKey == LogicalKeyboardKey.backspace || event.logicalKey == LogicalKeyboardKey.delete) {
//   if (viewModel.controller.text.isNotEmpty) {
//     viewModel.backSpace();
//   }
// }
