import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:test_blu/ui/common/shared/styles.dart';
import 'package:test_blu/ui/common/widgets/button.dart';

import 'package:test_blu/ui/views/test_page/test_page_viewmodel.dart';

class TestPageView extends StackedView<TestPageViewModel> {
  const TestPageView({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context, TestPageViewModel viewModel, Widget? child) {
    final formKey = GlobalKey<FormState>();

    return !viewModel.isBusy
        ? Focus(
            autofocus: true,
            focusNode: viewModel.focusNode,
            onKey: (node, event) {
              if (event.logicalKey == LogicalKeyboardKey.escape) {
                viewModel.goBack();
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
            child: RawKeyboardListener(
              focusNode: FocusNode(),
              onKey: (RawKeyEvent event) {
                if (event is RawKeyDownEvent) {
                  if (event.logicalKey == LogicalKeyboardKey.enter || event.logicalKey == LogicalKeyboardKey.numpadEnter) {
                    viewModel.submitData(context);
                  } else if (event.logicalKey == LogicalKeyboardKey.escape) {
                    Navigator.pop(context);
                  }
                }
              },
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: appwhite1,
                  title: Text(
                    'Center-${viewModel.locationId.toString()}',
                    style: const TextStyle(fontSize: 22),
                  ),
                  centerTitle: true,
                  actions: const [],
                ),
                body: SingleChildScrollView(
                    child: Column(
                  children: [
                    // const Text('data'),
                    InkWell(
                      onTap: () => viewModel.selectFromDate(context),
                      child: Container(
                        margin: const EdgeInsets.only(top: 12) + leftPadding10 + rightPadding10,
                        padding: defaultPadding12,
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              DateFormat('dd-MM-yyyy').format(viewModel.pickDate),
                              style: fontFamilyMedium.size18,
                            ),
                            horizontalSpacing10,
                            const Icon(Icons.calendar_month),
                          ],
                        ),
                      ),
                    ),
                    verticalSpacing10,
                    Button(
                        name: 'Export',
                        onTap: () {
                          viewModel.submitData(context);
                        }),
                  ],
                )),
              ),
            ),
          )
        : const CircularProgressIndicator();
  }

  @override
  TestPageViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      TestPageViewModel();
}

// class CustomDialog extends StatelessWidget {
//   const CustomDialog({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Dialog(
//       backgroundColor: Colors.blue, // Set the background color here
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//       ),
//       elevation: 0, // No shadow
//       child: Container(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Text(
//               'Custom Dialog',
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               'This is a custom dialog with a blue background.',
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close the dialog
//               },
//               child: const Text('Close'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
