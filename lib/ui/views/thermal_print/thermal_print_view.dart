import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart';
import 'package:stacked/stacked.dart';
import 'package:test_blu/ui/common/shared/styles.dart';
import 'thermal_print_viewmodel.dart';

class ThermalPrintView extends StackedView<ThermalPrintViewModel> {
  const ThermalPrintView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ThermalPrintViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Thermal Printer'),
      ),
      body: Column(
        children: [
          ListView.builder(
            itemCount: viewModel.devices.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(viewModel.devices[index].name ?? 'Unknown'), // Use ?? 'Unknown' to handle null names
                subtitle: Text(viewModel.devices[index].address),
                onTap: () {
                  // Handle the tapped device
                  print('Tapped on device: ${viewModel.devices[index].name}');
                },
              );
            },
          ),
          verticalSpacing10,
          InkWell(
            onTap: () => viewModel.sendPrintCommands(),
            child: Container(
              color: Colors.amber,
              child: const Text('print'),
            ),
          )
        ],
      ),
    );
  }

  @override
  ThermalPrintViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ThermalPrintViewModel();

  @override
  void onDispose(ThermalPrintViewModel viewModel) async {
    await FlutterBluetoothSerial.instance.cancelDiscovery();
    await viewModel.connection?.close();
    super.onDispose(viewModel);
  }
}
