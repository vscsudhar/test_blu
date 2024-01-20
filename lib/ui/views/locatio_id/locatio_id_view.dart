import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart';
import 'package:stacked/stacked.dart';
import 'package:test_blu/ui/common/shared/styles.dart';
import 'package:test_blu/ui/common/widgets/button1.dart';
import 'package:test_blu/ui/common/widgets/text_field1.dart';
import 'package:test_blu/ui/common/widgets/text_field2.dart';

import 'locatio_id_viewmodel.dart';

class LocatioIdView extends StackedView<LocatioIdViewModel> {
  const LocatioIdView({Key? key}) : super(key: key);

  static final formKey = GlobalKey<FormState>();

  @override
  Widget builder(
    BuildContext context,
    LocatioIdViewModel viewModel,
    Widget? child,
  ) {
    return Focus(
      autofocus: true,
      focusNode: FocusNode(),
      onKey: (node, event) {
        if (event.logicalKey == LogicalKeyboardKey.escape) {
          viewModel.goBack(context);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: (RawKeyEvent event) {
          if (event is RawKeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.enter || event.logicalKey == LogicalKeyboardKey.numpadEnter) {
              _submithand(viewModel);
            } else if (event.logicalKey == LogicalKeyboardKey.escape) {
              Navigator.pop(context);
            }
          }
        },
        child: Scaffold(
            backgroundColor: appwhite1,
            appBar: AppBar(),
            body: Padding(
              padding: defaultPadding10,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text('Center-ID'),
                    verticalSpacing12,
                    TextField2(
                      textAlign: TextAlign.center,
                      hintText: viewModel.locationId,
                      readOnly: true,
                    ),
                    verticalSpacing12,
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: defaultPadding10,
                        child: Column(
                          children: [
                            const Text('Center-Id'),
                            verticalSpacing4,
                            TextField1(
                              hintText: 'Center Id',
                              color: Colors.black,
                              validator: (val) {
                                if (val == null || val.isEmpty) {
                                  return 'Center-Id is required';
                                }
                                return null;
                              },
                              onSaved: (id) => viewModel.selectLocation(id.toString()),
                            ),
                            verticalSpacing8,
                            Column(
                              children: [
                                const Text('Weight Scale'),
                                Container(
                                  margin: const EdgeInsets.only(top: 12) + leftPadding10 + rightPadding10,
                                  padding: defaultPadding8,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      5,
                                    ),
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.4),
                                        offset: Offset(3, 3),
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: DropdownButton(
                                    value: viewModel.selectedDevice,
                                    onChanged: (value) => viewModel.onChangeWeight(value),
                                    items: viewModel.bondedDevices.map<DropdownMenuItem<BluetoothDevice>>(
                                      (BluetoothDevice device) {
                                        return DropdownMenuItem<BluetoothDevice>(
                                          value: device,
                                          child: Text(device.name.toString()),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ),
                              ],
                            ),
                            verticalSpacing10,
                            Column(
                              children: [
                                const Text('Printer'),
                                Container(
                                  margin: const EdgeInsets.only(top: 12) + leftPadding10 + rightPadding10,
                                  padding: defaultPadding8,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(
                                      5,
                                    ),
                                    boxShadow: const <BoxShadow>[
                                      BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.4),
                                        offset: Offset(3, 3),
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: DropdownButton(
                                    value: viewModel.selectedPrinter,
                                    onChanged: (value) => viewModel.onChangePrinter(value),
                                    items: viewModel.bondedDevices.map<DropdownMenuItem<BluetoothDevice>>(
                                      (BluetoothDevice device) {
                                        return DropdownMenuItem<BluetoothDevice>(
                                          value: device,
                                          child: Text(device.name.toString()),
                                        );
                                      },
                                    ).toList(),
                                  ),
                                ),
                              ],
                            ),
                            verticalSpacing12,
                            Button1(
                              title: 'SubMit',
                              onTap: () {
                                _submithand(viewModel);
                              },
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }

  void _submithand(LocatioIdViewModel viewModel) {
    if (formKey.currentState?.validate() ?? false) {
      formKey.currentState?.save();
      viewModel.saveSubmit();
      formKey.currentState?.reset();
      FocusNode().requestFocus();
    }
  }

  @override
  LocatioIdViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LocatioIdViewModel();
}
