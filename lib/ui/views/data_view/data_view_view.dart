import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:test_blu/ui/common/shared/styles.dart';
import 'package:test_blu/ui/common/widgets/button.dart';

import 'data_view_viewmodel.dart';

class DataViewView extends StackedView<DataViewViewModel> {
  const DataViewView(
    {Key? key}) : super(key: key);


  @override
  Widget builder(
    BuildContext context,
    DataViewViewModel viewModel,
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
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: appwhite1,
          title: Text('Center-${viewModel.locationId}'),
          centerTitle: true,
          // leading: InkWell(
          //   onTap: () => viewModel.goToHome(),
          //   child: const Icon(Icons.arrow_back),
          // ),
          // actions: const [
          // InkWell(onTap: () => viewModel.deleteDatas(), child: const Icon(Icons.delete)),
          // horizontalSpacing10,
          // PopupMenuButton(
          //     tooltip: 'More',
          //     icon: const Icon(Icons.more_vert),
          //     itemBuilder: (BuildContext context) => [
          //           PopupMenuItem(
          //             child: Row(
          //               children: [
          //                 InkWell(
          //                     onTap: () => viewModel.export(),
          //                     child: const Icon(Icons.share)),
          //                 horizontalSpacing10,
          //                 const Text('Export'),
          //               ],
          //             ),
          //           ),
          //           PopupMenuItem(
          //             child: InkWell(
          //               onTap: () => viewModel.deleteDialog(context),
          //               child: const Row(
          //                 children: [
          //                   Icon(Icons.delete),
          //                   horizontalSpacing10,
          //                   Text('Delete'),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ]),
          //   horizontalSpacing10,
          // ],
        ),
        backgroundColor: appwhite1,
        body: Padding(
          padding: leftPadding10 + rightPadding10,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => viewModel.selectFromDate(context),
                      child: Container(
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
                        child: Row(
                          children: [
                            Text(
                              DateFormat('dd-MM-yyyy').format(viewModel.fromDate),
                              // DateFormat.yMMMEd().format(viewModel.fromDate),
                              style: fontFamilyMedium.size18,
                            ),
                            horizontalSpacing20,
                            const Icon(Icons.calendar_month),
                          ],
                        ),
                      ),
                    ),
                    horizontalSpacing10,
                    Padding(
                      padding: defaultPadding8,
                      child: DropdownButton<String>(
                        dropdownColor: Colors.blue.shade400,
                        value: viewModel.selectedValue,
                        onChanged: (value) => viewModel.selectSession(value.toString()),
                        items: <String>['AM', 'PM'].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
                verticalSpacing10,
                Button(height: 40, name: 'submit', onTap: () => viewModel.submitbutton()),
                Text('Center : ${viewModel.locationId}'),
                viewModel.userList.isNotEmpty
                    ? SizedBox(
                        height: 200,
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: ListView.builder(
                          itemCount: viewModel.userList.length,
                          shrinkWrap: true,
                          itemBuilder: ((context, index) => Card(
                                color: appViking,
                                child: ListTile(
                                  leading: const Icon(Icons.person),
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Text(
                                      //   viewModel.userList[index].dateTime.toString(),
                                      //   style: fontFamilyMedium.size16,
                                      // ),
                                      verticalSpacing8,
                                      Row(
                                        children: [
                                          Text(viewModel.userList[index].customerId.toString()),
                                          const Spacer(),
                                          Text(
                                            viewModel.userList[index].weight.toString(),
                                            style: fontFamilyMedium.size24,
                                          ),
                                          // Text(
                                          //   viewModel.userList[index].session.toString(),
                                          // ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // subtitle: Center(
                                  //   child: Text(
                                  //     viewModel.userList[index].weight.toString(),
                                  //     style: fontFamilyMedium.size24,
                                  //   ),
                                  // ),
                                  // trailing: InkWell(
                                  //     onTap: () => viewModel.deleteFromDialog(
                                  //           context,
                                  //           viewModel.userList[index].id,
                                  //         ),
                                  //     child: const Icon(Icons.delete)),
                                ),
                              )),
                        ),
                      )
                    : verticalSpacing20,
                const Text('Data'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  DataViewViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      DataViewViewModel();
}
