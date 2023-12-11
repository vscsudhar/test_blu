import 'package:flutter/material.dart';
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
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(),
        body: Padding(
          padding: defaultPadding10,
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
                child: Column(
                  children: [
                    TextField1(
                      color: Colors.black,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'Center-Id is required';
                        }
                        return null;
                      },
                      onSaved: (id) => viewModel.selectLocation(id.toString()),
                    ),
                    verticalSpacing12,
                    Button1(
                      title: 'SubMit',
                      onTap: () {
                        if (formKey.currentState?.validate() ?? false) {
                          formKey.currentState?.save();
                          viewModel.submitAction();
                          formKey.currentState?.reset();
                        }
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  @override
  LocatioIdViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LocatioIdViewModel();
}
