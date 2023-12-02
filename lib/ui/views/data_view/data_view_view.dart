import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:test_blu/ui/common/shared/styles.dart';
import 'package:test_blu/ui/common/widgets/button.dart';

import 'data_view_viewmodel.dart';

class DataViewView extends StackedView<DataViewViewModel> {
  const DataViewView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    DataViewViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        title: const Text('data'),
        // leading: InkWell(
        //   onTap: () => viewModel.goToHome(),
        //   child: const Icon(Icons.arrow_back),
        // ),
        actions: [
          // InkWell(onTap: () => viewModel.deleteDatas(), child: const Icon(Icons.delete)),
          // horizontalSpacing10,
          PopupMenuButton(
              tooltip: 'More',
              icon: const Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                      child: Row(
                        children: [
                          InkWell(onTap: () => viewModel.export(), child: const Icon(Icons.share)),
                          horizontalSpacing10,
                          const Text('Export'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      child: InkWell(
                        onTap: () => viewModel.deleteDialog(context),
                        child: const Row(
                          children: [
                            Icon(Icons.delete),
                            horizontalSpacing10,
                            Text('Delete'),
                          ],
                        ),
                      ),
                    ),
                  ]),
          horizontalSpacing10,
        ],
      ),
      backgroundColor: appwhite1,
      body: Padding(
        padding: defaultPadding10,
        child: Column(
          children: [
            Row(
              children: [
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
                          DateFormat.yMMMEd().format(viewModel.fromDate),
                          style: fontFamilyMedium.size18,
                        ),
                        horizontalSpacing10,
                        const Icon(Icons.calendar_month),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: defaultPadding10,
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
            Button(name: 'submit', onTap: () => viewModel.submitbutton()),
            viewModel.userList.isNotEmpty
                ? SingleChildScrollView(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * .55,
                      // height: 420,
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
                                    Text(
                                      viewModel.userList[index].dateTime.toString(),
                                      style: fontFamilyMedium.size16,
                                    ),
                                    verticalSpacing8,
                                    Row(
                                      children: [
                                        Text(viewModel.userList[index].customerId.toString()),
                                        const Spacer(),
                                        Text(
                                          viewModel.userList[index].session.toString(),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                subtitle: Center(
                                  child: Text(
                                    viewModel.userList[index].weight.toString(),
                                    style: fontFamilyMedium.size24,
                                  ),
                                ),
                                // trailing: InkWell(
                                //     onTap: () => viewModel.deleteFromDialog(
                                //           context,
                                //           viewModel.userList[index].id,
                                //         ),
                                //     child: const Icon(Icons.delete)),
                              ),
                            )),
                      ),
                    ),
                  )
                : verticalSpacing20,
            const Text('No Data'),
          ],
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
