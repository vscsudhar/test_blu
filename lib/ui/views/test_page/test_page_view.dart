import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stacked/stacked.dart';
import 'package:test_blu/ui/common/shared/styles.dart';
import 'package:test_blu/ui/common/widgets/button.dart';

import 'package:test_blu/ui/views/test_page/test_page_viewmodel.dart';

class TestPageView extends StackedView<TestPageViewModel> {
  const TestPageView({Key? key}) : super(key: key);

  @override
  Widget builder(
      BuildContext context, TestPageViewModel viewModel, Widget? child) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          viewModel.locationId.toString(),
          style: const TextStyle(fontSize: 22),
        ),
        centerTitle: true,
        actions: const [],
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          const Text('data'),
          InkWell(
            onTap: () => viewModel.selectFromDate(context),
            child: Container(
              margin: const EdgeInsets.only(top: 12) +
                  leftPadding10 +
                  rightPadding10,
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
                    DateFormat.yMMMEd().format(viewModel.pickDate),
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
                viewModel.submitData();
              }),
          viewModel.userList.isNotEmpty
              ? ListView.builder(
                  itemCount: viewModel.userList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => ListTile(
                    title: Text(viewModel.userList[index].weight.toString()),
                    subtitle:
                        Text(viewModel.userList[index].customerId.toString()),
                  ),
                )
              : const Text('No data'),
          Text(viewModel.csvFilePath.toString())
        ],
      )),
    );
  }

  @override
  TestPageViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      TestPageViewModel();
}
