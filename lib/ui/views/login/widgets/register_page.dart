import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:test_blu/ui/common/shared/styles.dart';
import 'package:test_blu/ui/common/ui_helpers.dart';
import 'package:test_blu/ui/common/widgets/button.dart';
import 'package:test_blu/ui/common/widgets/text_field1.dart';
import 'package:test_blu/ui/views/login/login_viewmodel.dart';

class Register extends StackedView<LoginViewModel> {
  const Register({super.key});

  static final formKey = GlobalKey<FormState>();

  @override
  Widget builder(BuildContext context, LoginViewModel viewModel, Widget? child) {
    return Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.white,
        body: Padding(
          padding: defaultPadding12,
          child: Form(
            key: formKey,
            child: Column(children: [
              verticalSpaceMedium,
              Text(
                'Register',
                style: fontFamilyMedium.appChambray1.size28,
              ),
              verticalSpacing12,
              TextField1(
                color: Colors.black,
                hintText: 'User Name',
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'User Name is required';
                  }
                  return null;
                },
                onSaved: (userName) => viewModel.setUserName(userName.toString()),
              ),
              verticalSpacing12,
              TextField1(
                obscureText: true,
                color: Colors.black,
                hintText: 'PassWord',
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
                onSaved: (pass) => viewModel.setUserPass(pass.toString()),
              ),
              verticalSpacing16,
              Button(
                  name: 'Register',
                  onTap: () {
                    if (formKey.currentState?.validate() ?? false) {
                      formKey.currentState?.save();
                      viewModel.submitData();
                      formKey.currentState?.reset();
                    }
                  })
            ]),
          ),
        ));
  }

  @override
  LoginViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LoginViewModel();
}
